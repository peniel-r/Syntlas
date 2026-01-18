const std = @import("std");
const Allocator = std.mem.Allocator;
const schema = @import("../core/schema.zig");
const inverted = @import("../index/inverted.zig");
const graph = @import("../index/graph.zig");
const metadata = @import("../index/metadata.zig");
const use_case = @import("../index/use_case.zig");

pub const SearchOptions = struct {
    max_results: usize = 50,
    min_score: f32 = 0.1,
    include_snippets: bool = false,
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

    /// Stage 1: Text Matching
    /// Perform inverted index lookup for query tokens
    pub fn stage1_TextMatch(self: *SearchEngine, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        // 1.1 Query Tokenization
        const tokens = try inverted.tokenize(self.allocator, query);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        // 1.2 Inverted Index Lookup & 1.3 Scoring
        for (tokens) |token| {
            if (self.inverted_index.search(token)) |posting_list| {
                for (posting_list.neurona_ids.items, posting_list.term_frequencies.items) |id, tf| {
                    const result = try activations.getOrPut(self.allocator, id);
                    if (!result.found_existing) {
                        result.value_ptr.* = tf;
                    } else {
                        result.value_ptr.* += tf; // Simple TF summation
                    }
                }
            }
        }

        return activations;
    }

    /// Stage 2: Semantic Matching
    /// Perform use-case index lookup
    pub fn stage2_SemanticMatch(self: *SearchEngine, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        return self.use_case_index.search(query);
    }
};

test "Stage 1: Text Matching" {
    const allocator = std.testing.allocator;

    // Setup mock indices
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

    // id1 has both keywords: 0.5 + 0.3 = 0.8
    // id2 has only async: 0.8
    try std.testing.expectApproxEqAbs(results.get("id1").?, 0.8, 0.001);
    try std.testing.expectApproxEqAbs(results.get("id2").?, 0.8, 0.001);
}
