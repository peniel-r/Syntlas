const std = @import("std");
const Allocator = std.mem.Allocator;
const schema = @import("../core/schema.zig");
const inverted = @import("../index/inverted.zig");
const graph = @import("../index/graph.zig");
const metadata = @import("../index/metadata.zig");
const use_case = @import("../index/use_case.zig");
const ranking = @import("ranking.zig");

pub const SearchOptions = struct {
    max_results: usize = 50,
    min_score: f32 = 0.1,
    include_snippets: bool = false,
};

const ActivationSummary = schema.ActivationSummary;

pub const ExpansionOptions = struct {
    depth: u8 = 1,
    decay: f32 = 0.5,
    min_weight: u8 = 50,
};

pub const SearchContext = struct {
    category: ?schema.Category = null,
    difficulty: ?schema.Difficulty = null,
    tags: []const []const u8 = &.{},
};

pub const SearchEngine = struct {
    inverted_index: *const inverted.InvertedIndex,
    graph_index: *const graph.GraphIndex,
    metadata_index: *const metadata.MetadataIndex,
    use_case_index: *const use_case.UseCaseIndex,
    allocator: Allocator,

    pub fn init(
        allocator: Allocator,
        inverted_index: *const inverted.InvertedIndex,
        graph_index: *const graph.GraphIndex,
        metadata_index: *const metadata.MetadataIndex,
        use_case_index: *const use_case.UseCaseIndex,
    ) SearchEngine {
        return .{
            .inverted_index = inverted_index,
            .graph_index = graph_index,
            .metadata_index = metadata_index,
            .use_case_index = use_case_index,
            .allocator = allocator,
        };
    }

    /// Complete search pipeline: Stage 1-7
    pub fn search(
        self: *SearchEngine,
        query: []const u8,
        context: SearchContext,
        options: SearchOptions,
    ) ![]ActivationSummary {
        // 1. Initial retrieval (Exact)
        var activations = try self.stage1_TextMatch(query);
        defer activations.deinit(self.allocator);

        // Stage 6: Fuzzy
        try self.stage6_FuzzyMatch(&activations, query, 1);

        // 2. Semantic lookup (Stage 2)
        var semantic_scores = try self.stage2_SemanticMatch(query);
        defer semantic_scores.deinit(self.allocator);

        var sem_it = semantic_scores.iterator();
        while (sem_it.next()) |entry| {
            const res = try activations.getOrPut(self.allocator, entry.key_ptr.*);
            if (!res.found_existing) {
                res.value_ptr.* = entry.value_ptr.*;
            } else {
                res.value_ptr.* += entry.value_ptr.*;
            }
        }

        // 3. Filter by context (Stage 3)
        try self.stage3_ContextFilter(&activations, context);

        // 4. Expand via graph (Stage 4)
        try self.stage4_GraphExpansion(&activations, .{});

        // 5. Final ranking (Stage 5)
        try self.stage5_RankResults(&activations, .{});

        // 7. Format and sort (Stage 7)
        return try self.stage7_FormatResults(&activations, options);
    }

    /// Stage 1: Text Matching
    pub fn stage1_TextMatch(self: *SearchEngine, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        const tokens = try inverted.tokenize(self.allocator, query);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            if (self.inverted_index.search(token)) |posting_list| {
                for (posting_list.neurona_ids.items, posting_list.term_frequencies.items) |id, tf| {
                    const result = try activations.getOrPut(self.allocator, id);
                    if (!result.found_existing) {
                        result.value_ptr.* = tf;
                    } else {
                        result.value_ptr.* += tf;
                    }
                }
            }
        }

        return activations;
    }

    /// Stage 2: Semantic Matching
    pub fn stage2_SemanticMatch(self: *SearchEngine, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        return self.use_case_index.search(query);
    }

    /// Stage 3: Context Filtering
    pub fn stage3_ContextFilter(
        self: *SearchEngine,
        activations: *std.StringHashMapUnmanaged(f32),
        context: SearchContext,
    ) !void {
        if (context.category == null and context.difficulty == null and context.tags.len == 0) return;

        const allowed_ids = try self.metadata_index.filterCombined(
            context.category,
            context.difficulty,
            context.tags,
            self.allocator,
        );
        defer self.allocator.free(allowed_ids);

        var allowed_set = std.StringHashMapUnmanaged(void){};
        defer allowed_set.deinit(self.allocator);
        try allowed_set.ensureTotalCapacity(self.allocator, @intCast(allowed_ids.len));

        for (allowed_ids) |id| {
            allowed_set.putAssumeCapacity(id, {});
        }

        var keys_to_remove = std.ArrayListUnmanaged([]const u8){};
        defer keys_to_remove.deinit(self.allocator);

        var check_it = activations.iterator();
        while (check_it.next()) |entry| {
            if (!allowed_set.contains(entry.key_ptr.*)) {
                try keys_to_remove.append(self.allocator, entry.key_ptr.*);
            }
        }

        for (keys_to_remove.items) |key| {
            _ = activations.remove(key);
        }
    }

    /// Stage 4: Graph Expansion
    pub fn stage4_GraphExpansion(
        self: *SearchEngine,
        activations: *std.StringHashMapUnmanaged(f32),
        options: ExpansionOptions,
    ) !void {
        if (options.depth == 0) return;

        var current_frontier = try activations.clone(self.allocator);
        defer current_frontier.deinit(self.allocator);

        var next_frontier = std.StringHashMapUnmanaged(f32){};
        defer next_frontier.deinit(self.allocator);

        var d: u8 = 0;
        while (d < options.depth) : (d += 1) {
            next_frontier.clearRetainingCapacity();

            var it = current_frontier.iterator();
            while (it.next()) |entry| {
                const source_id = entry.key_ptr.*;
                const source_score = entry.value_ptr.*;

                if (self.graph_index.getOutgoing(source_id)) |synapses| {
                    for (synapses.synapses.items) |synapse| {
                        if (synapse.weight < options.min_weight) continue;

                        const weight_factor = @as(f32, @floatFromInt(synapse.weight)) / 100.0;
                        const propagated = source_score * weight_factor * options.decay;

                        const result = try next_frontier.getOrPut(self.allocator, synapse.target_id);
                        if (!result.found_existing) {
                            result.value_ptr.* = propagated;
                        } else {
                            result.value_ptr.* += propagated;
                        }

                        const main_result = try activations.getOrPut(self.allocator, synapse.target_id);
                        if (!main_result.found_existing) {
                            main_result.value_ptr.* = propagated;
                        } else {
                            main_result.value_ptr.* += propagated;
                        }
                    }
                }
            }

            if (d < options.depth - 1) {
                current_frontier.clearRetainingCapacity();
                var next_it = next_frontier.iterator();
                while (next_it.next()) |entry| {
                    try current_frontier.put(self.allocator, entry.key_ptr.*, entry.value_ptr.*);
                }
            }
        }
    }

    /// Stage 5: Ranking Algorithm
    pub fn stage5_RankResults(
        self: *SearchEngine,
        activations: *std.StringHashMapUnmanaged(f32),
        factors: ranking.RankingFactors,
    ) !void {
        var it = activations.iterator();
        while (it.next()) |entry| {
            const id = entry.key_ptr.*;
            const relevance = entry.value_ptr.*;

            const quality = self.metadata_index.getQuality(id) orelse schema.QualityFlags{};
            const search_weight_quantized = self.metadata_index.getSearchWeight(id);
            const search_weight = @as(f32, @floatFromInt(search_weight_quantized)) / 100.0;

            var score = ranking.calculateScore(relevance, quality, factors);
            score *= search_weight;
            entry.value_ptr.* = score;
        }
    }

    /// Stage 6: Fuzzy Matching
    pub fn stage6_FuzzyMatch(
        self: *SearchEngine,
        activations: *std.StringHashMapUnmanaged(f32),
        query: []const u8,
        max_distance: usize,
    ) !void {
        const tokens = try inverted.tokenize(self.allocator, query);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            var fuzzy_matches = try self.inverted_index.fuzzySearch(token, max_distance);
            defer fuzzy_matches.deinit(self.allocator);

            var it = fuzzy_matches.iterator();
            while (it.next()) |entry| {
                const keyword = entry.key_ptr.*;
                const posting_list = entry.value_ptr.*;

                const dist = try inverted.levenshteinDistance(self.allocator, token, keyword);
                const penalty: f32 = if (dist == 0) 1.0 else 0.7 / @as(f32, @floatFromInt(dist));

                for (posting_list.neurona_ids.items, posting_list.term_frequencies.items) |id, tf| {
                    const result = try activations.getOrPut(self.allocator, id);
                    const scored_tf = tf * penalty;
                    if (!result.found_existing) {
                        result.value_ptr.* = scored_tf;
                    } else {
                        result.value_ptr.* = @max(result.value_ptr.*, scored_tf);
                    }
                }
            }
        }
    }

    /// Stage 7: Result Formatting
    pub fn stage7_FormatResults(
        self: *SearchEngine,
        activations: *std.StringHashMapUnmanaged(f32),
        options: SearchOptions,
    ) ![]ActivationSummary {
        var results = std.ArrayListUnmanaged(ActivationSummary){};
        errdefer results.deinit(self.allocator);

        var it = activations.iterator();
        while (it.next()) |entry| {
            if (entry.value_ptr.* >= options.min_score) {
                try results.append(self.allocator, .{
                    .id = entry.key_ptr.*,
                    .score = entry.value_ptr.*,
                });
            }
        }

        // Sort before owning slice to make shrinking easier
        std.mem.sort(ActivationSummary, results.items, {}, sortResults);

        if (results.items.len > options.max_results) {
            results.shrinkRetainingCapacity(options.max_results);
            // Optionally shrink capacity to match formatted length
            results.shrinkAndFree(self.allocator, options.max_results);
        }

        return results.toOwnedSlice(self.allocator);
    }

    fn sortResults(_: void, a: ActivationSummary, b: ActivationSummary) bool {
        return a.score > b.score;
    }
};

test "Stage 1: Text Matching" {
    const allocator = std.testing.allocator;
    var inv_index = inverted.InvertedIndex.init(allocator);
    defer inv_index.deinit();
    try inv_index.addKeyword("async", "id1", 0.5);
    try inv_index.addKeyword("python", "id1", 0.3);
    try inv_index.addKeyword("async", "id2", 0.8);
    var graph_index = graph.GraphIndex.init(allocator);
    defer graph_index.deinit();
    var meta_index = metadata.MetadataIndex.init(allocator);
    defer meta_index.deinit();
    var use_case_index = use_case.UseCaseIndex.init(allocator);
    defer use_case_index.deinit();

    var engine = SearchEngine.init(allocator, &inv_index, &graph_index, &meta_index, &use_case_index);
    var results = try engine.stage1_TextMatch("async python");
    defer results.deinit(allocator);

    try std.testing.expect(results.contains("id1"));
    try std.testing.expect(results.contains("id2"));
    try std.testing.expectApproxEqAbs(results.get("id1").?, 0.8, 0.001);
    try std.testing.expectApproxEqAbs(results.get("id2").?, 0.8, 0.001);
}

test "Stage 3: Context Filtering" {
    const allocator = std.testing.allocator;
    var inv_index = inverted.InvertedIndex.init(allocator);
    defer inv_index.deinit();
    var graph_index = graph.GraphIndex.init(allocator);
    defer graph_index.deinit();
    var meta_index = metadata.MetadataIndex.init(allocator);
    defer meta_index.deinit();
    var use_case_index = use_case.UseCaseIndex.init(allocator);
    defer use_case_index.deinit();
    try inv_index.addKeyword("async", "id1", 1.0);
    try inv_index.addKeyword("async", "id2", 1.0);
    try meta_index.addNeurona("id1", .concept, .novice, &.{}, .{}, 100);
    try meta_index.addNeurona("id2", .concept, .expert, &.{}, .{}, 100);

    var engine = SearchEngine.init(allocator, &inv_index, &graph_index, &meta_index, &use_case_index);
    var activations = try engine.stage1_TextMatch("async");
    defer activations.deinit(allocator);

    try engine.stage3_ContextFilter(&activations, .{ .difficulty = .novice });
    try std.testing.expectEqual(@as(usize, 1), activations.count());
    try std.testing.expect(activations.contains("id1"));
}

test "Full Search Pipeline Integration" {
    const allocator = std.testing.allocator;
    var inv_index = inverted.InvertedIndex.init(allocator);
    defer inv_index.deinit();
    var graph_index = graph.GraphIndex.init(allocator);
    defer graph_index.deinit();
    var meta_index = metadata.MetadataIndex.init(allocator);
    defer meta_index.deinit();
    var use_case_index = use_case.UseCaseIndex.init(allocator);
    defer use_case_index.deinit();

    try inv_index.addKeyword("concurrency", "id1", 1.0);
    try meta_index.addNeurona("id1", .concept, .advanced, &.{}, .{ .tested = true }, 100);

    var engine = SearchEngine.init(allocator, &inv_index, &graph_index, &meta_index, &use_case_index);
    const results = try engine.search("concurrency", .{ .difficulty = .advanced }, .{});
    defer allocator.free(results);

    try std.testing.expectEqual(@as(usize, 1), results.len);
    try std.testing.expectEqualStrings("id1", results[0].id);
    try std.testing.expectApproxEqAbs(results[0].score, 1.1, 0.001);
}
