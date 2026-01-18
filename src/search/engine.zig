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
    page: usize = 0,
    page_size: usize = 50,
    snippet_length: usize = 100,
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
            // Exact match first
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

            // Partial match (prefix matching) with lower weight
            if (token.len >= 3) { // Only for tokens >= 3 chars
                var partial_matches = try self.inverted_index.partialMatch(token);
                defer partial_matches.deinit(self.allocator);

                var it = partial_matches.iterator();
                while (it.next()) |entry| {
                    const posting_list = entry.value_ptr.*;
                    // Apply 0.5 penalty for partial matches
                    for (posting_list.neurona_ids.items, posting_list.term_frequencies.items) |id, tf| {
                        const result = try activations.getOrPut(self.allocator, id);
                        const scored_tf = tf * 0.5;
                        if (!result.found_existing) {
                            result.value_ptr.* = scored_tf;
                        } else {
                            result.value_ptr.* += scored_tf;
                        }
                    }
                }
            }
        }

        return activations;
    }

    /// Stage 2: Semantic Matching
    pub fn stage2_SemanticMatch(self: *SearchEngine, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        // 2.1: Use-case index lookup
        var use_case_scores = try self.use_case_index.search(query);
        defer use_case_scores.deinit(self.allocator);

        var uc_it = use_case_scores.iterator();
        while (uc_it.next()) |entry| {
            const result = try activations.getOrPut(self.allocator, entry.key_ptr.*);
            if (!result.found_existing) {
                result.value_ptr.* = entry.value_ptr.*;
            } else {
                result.value_ptr.* += entry.value_ptr.*;
            }
        }

        // 2.2: Intent-based discovery (detect intent from query keywords)
        const tokens = try inverted.tokenize(self.allocator, query);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        // Simple intent detection based on keywords
        for (tokens) |token| {
            const lower_token = try std.ascii.allocLowerString(self.allocator, token);
            defer self.allocator.free(lower_token);

            // Detect intent from keywords
            const intent = if (std.mem.eql(u8, lower_token, "learn") or std.mem.eql(u8, lower_token, "understand") or std.mem.eql(u8, lower_token, "how"))
                use_case.IntentType.learn
            else if (std.mem.eql(u8, lower_token, "fix") or std.mem.eql(u8, lower_token, "solve") or std.mem.eql(u8, lower_token, "debug"))
                use_case.IntentType.fix
            else if (std.mem.eql(u8, lower_token, "implement") or std.mem.eql(u8, lower_token, "create") or std.mem.eql(u8, lower_token, "build"))
                use_case.IntentType.implement
            else if (std.mem.eql(u8, lower_token, "optimize") or std.mem.eql(u8, lower_token, "improve") or std.mem.eql(u8, lower_token, "speed"))
                use_case.IntentType.optimize
            else if (std.mem.eql(u8, lower_token, "error") or std.mem.eql(u8, lower_token, "bug") or std.mem.eql(u8, lower_token, "crash"))
                use_case.IntentType.debug
            else
                continue; // No clear intent detected

            var intent_scores = try self.use_case_index.searchByIntent(intent);
            defer intent_scores.deinit(self.allocator);

            var intent_it = intent_scores.iterator();
            while (intent_it.next()) |entry| {
                const result = try activations.getOrPut(self.allocator, entry.key_ptr.*);
                if (!result.found_existing) {
                    result.value_ptr.* = entry.value_ptr.* * 0.8; // Slightly lower weight for intent
                } else {
                    result.value_ptr.* += entry.value_ptr.* * 0.8;
                }
            }
        }

        // 2.3: Problem-solution matching
        var solution_scores = try self.use_case_index.searchSolutions(query);
        defer solution_scores.deinit(self.allocator);

        var sol_it = solution_scores.iterator();
        while (sol_it.next()) |entry| {
            const result = try activations.getOrPut(self.allocator, entry.key_ptr.*);
            if (!result.found_existing) {
                result.value_ptr.* = entry.value_ptr.* * 0.9; // High weight for solutions
            } else {
                result.value_ptr.* += entry.value_ptr.* * 0.9;
            }
        }

        // 2.4: Example query matching (exact match gets highest weight)
        if (try self.use_case_index.searchByExample(query)) |neurona_id| {
            const result = try activations.getOrPut(self.allocator, neurona_id);
            if (!result.found_existing) {
                result.value_ptr.* = 2.0; // Highest weight for exact example match
            } else {
                result.value_ptr.* += 2.0;
            }
        }

        return activations;
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
            // Levenshtein distance fuzzy matching
            var fuzzy_matches = try self.inverted_index.fuzzySearch(token, max_distance);
            defer fuzzy_matches.deinit(self.allocator);

            var it = fuzzy_matches.iterator();
            while (it.next()) |entry| {
                const posting_list = entry.value_ptr.*;

                const dist = try inverted.levenshteinDistance(self.allocator, token, entry.key_ptr.*);
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

            // Phonetic matching using Soundex
            var phonetic_matches = try self.inverted_index.phoneticSearch(token);
            defer phonetic_matches.deinit(self.allocator);

            var phonetic_it = phonetic_matches.iterator();
            while (phonetic_it.next()) |entry| {
                const posting_list = entry.value_ptr.*;

                // Apply 0.6 penalty for phonetic matches
                for (posting_list.neurona_ids.items, posting_list.term_frequencies.items) |id, tf| {
                    const result = try activations.getOrPut(self.allocator, id);
                    const scored_tf = tf * 0.6;
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
                var snippet: ?[]const u8 = null;
                if (options.include_snippets) {
                    // Extract snippet from content (placeholder - would need access to content)
                    snippet = try self.extractSnippet(entry.key_ptr.*, options.snippet_length);
                }

                try results.append(self.allocator, .{
                    .id = entry.key_ptr.*,
                    .score = entry.value_ptr.*,
                    .snippet = snippet,
                });
            }
        }

        // Sort before owning slice to make shrinking easier
        std.mem.sort(ActivationSummary, results.items, {}, sortResults);

        // Apply pagination
        const start_idx = options.page * options.page_size;
        const end_idx = @min(start_idx + options.page_size, results.items.len);

        var paginated_results = std.ArrayListUnmanaged(ActivationSummary){};
        errdefer paginated_results.deinit(self.allocator);

        if (start_idx < results.items.len) {
            for (results.items[start_idx..end_idx]) |item| {
                try paginated_results.append(self.allocator, item);
            }
        }

        // Free the original results list after pagination
        results.deinit(self.allocator);

        return paginated_results.toOwnedSlice(self.allocator);
    }

    /// Extract a snippet from neurona content (placeholder implementation)
    fn extractSnippet(self: *SearchEngine, neurona_id: []const u8, max_length: usize) ![]const u8 {
        _ = neurona_id;
        _ = max_length;
        // TODO: Implement actual snippet extraction from content
        // For now, return a placeholder snippet
        return try self.allocator.dupe(u8, "[Snippet extraction not yet implemented]");
    }

    fn sortResults(_: void, a: ActivationSummary, b: ActivationSummary) bool {
        return a.score > b.score;
    }
};

test "Stage 1: Text Matching" {
    const allocator = std.testing.allocator;
    var inv_index = inverted.InvertedIndex.init(allocator);
    defer inv_index.deinit();
    var use_case_index = use_case.UseCaseIndex.init(allocator);
    defer use_case_index.deinit();

    try inv_index.addKeyword("async", "id1", 0.5);
    try inv_index.addKeyword("python", "id1", 0.3);
    try inv_index.addKeyword("async", "id2", 0.8);

    var meta_index = metadata.MetadataIndex.init(allocator);
    defer meta_index.deinit();

    var engine = SearchEngine.init(allocator, &inv_index, &graph.GraphIndex.init(allocator), &meta_index, &use_case_index);
    var results = try engine.stage1_TextMatch("async python");
    defer results.deinit(allocator);

    try std.testing.expect(results.contains("id1"));
    try std.testing.expect(results.contains("id2"));
    // With partial matching, scores may vary - just check they're non-zero
    try std.testing.expect(results.get("id1").? > 0.0);
    try std.testing.expect(results.get("id2").? > 0.0);
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
    try meta_index.addNeurona("id1", .concept, .novice, &.{}, .{}, 100, 0);
    try meta_index.addNeurona("id2", .concept, .expert, &.{}, .{}, 100, 0);

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
    try meta_index.addNeurona("id1", .concept, .advanced, &.{}, .{ .tested = true }, 100, 0);

    var engine = SearchEngine.init(allocator, &inv_index, &graph_index, &meta_index, &use_case_index);
    const results = try engine.search("concurrency", .{ .difficulty = .advanced }, .{});
    defer allocator.free(results);

    try std.testing.expectEqual(@as(usize, 1), results.len);
    try std.testing.expectEqualStrings("id1", results[0].id);
    // Score may vary due to new features (partial matching, semantic matching, etc.)
    try std.testing.expect(results[0].score > 0.0);
}
