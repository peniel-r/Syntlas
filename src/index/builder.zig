const std = @import("std");
const Allocator = std.mem.Allocator;
const schema = @import("../core/schema.zig");
const Neurona = schema.Neurona;
const inverted = @import("inverted.zig");
const graph = @import("graph.zig");
const metadata = @import("metadata.zig");
const use_case = @import("use_case.zig");

/// Index builder: scans tomes and builds all indices
pub const IndexBuilder = struct {
    inverted_index: inverted.InvertedIndex,
    graph_index: graph.GraphIndex,
    metadata_index: metadata.MetadataIndex,
    use_case_index: use_case.UseCaseIndex,
    allocator: Allocator,

    pub fn init(allocator: Allocator) IndexBuilder {
        return .{
            .inverted_index = inverted.InvertedIndex.init(allocator),
            .graph_index = graph.GraphIndex.init(allocator),
            .metadata_index = metadata.MetadataIndex.init(allocator),
            .use_case_index = use_case.UseCaseIndex.init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *IndexBuilder) void {
        self.inverted_index.deinit();
        self.graph_index.deinit();
        self.metadata_index.deinit();
        self.use_case_index.deinit();
    }

    /// Add a neurona to all indices
    pub fn addNeurona(self: *IndexBuilder, neurona: *const Neurona, content: []const u8) !void {
        // Build inverted index from keywords
        for (neurona.keywords) |keyword| {
            const tf = inverted.calculateTermFrequency(content, keyword);
            try self.inverted_index.addKeyword(keyword, neurona.id, tf);
        }

        // Build graph index from synapses
        for (neurona.prerequisites) |synapse| {
            try self.graph_index.addSynapse(
                neurona.id,
                synapse.id,
                .prerequisite,
                synapse.weight,
            );
        }

        for (neurona.related) |synapse| {
            try self.graph_index.addSynapse(
                neurona.id,
                synapse.id,
                .related,
                synapse.weight,
            );
        }

        for (neurona.next_topics) |synapse| {
            try self.graph_index.addSynapse(
                neurona.id,
                synapse.id,
                .next_topic,
                synapse.weight,
            );
        }

        // Build metadata index
        try self.metadata_index.addNeurona(
            neurona.id,
            neurona.category,
            neurona.difficulty,
            neurona.tags,
        );

        // Build use-case index
        for (neurona.use_cases) |uc| {
            try self.use_case_index.addUseCase(uc, neurona.id);
        }
    }

    /// Build indices from a collection of neuronas
    pub fn buildFromCollection(self: *IndexBuilder, neuronas: []const Neurona, contents: []const []const u8) !Statistics {
        const start_time = std.time.milliTimestamp();

        for (neuronas, 0..) |*neurona, i| {
            const content = if (i < contents.len) contents[i] else "";
            try self.addNeurona(neurona, content);
        }

        const end_time = std.time.milliTimestamp();
        const build_time_ms = end_time - start_time;

        return Statistics{
            .neurona_count = neuronas.len,
            .keyword_count = self.inverted_index.keywordCount(),
            .build_time_ms = @intCast(build_time_ms),
        };
    }

    pub const Statistics = struct {
        neurona_count: usize,
        keyword_count: usize,
        build_time_ms: u64,

        pub fn print(self: Statistics) void {
            std.debug.print("Index Statistics:\n", .{});
            std.debug.print("  Neuronas indexed: {d}\n", .{self.neurona_count});
            std.debug.print("  Unique keywords: {d}\n", .{self.keyword_count});
            std.debug.print("  Build time: {d}ms\n", .{self.build_time_ms});
        }
    };
};

test "IndexBuilder basic operations" {
    const allocator = std.testing.allocator;
    var builder = IndexBuilder.init(allocator);
    defer builder.deinit();

    var tags = [_][]const u8{"test"};
    var keywords = [_][]const u8{ "async", "await" };
    var use_cases = [_][]const u8{};
    var prereqs = [_]schema.Synapse{};
    var related = [_]schema.Synapse{};
    var next_topics = [_]schema.Synapse{};

    const neurona = Neurona{
        .id = "test.neurona",
        .title = "Test Neurona",
        .category = .concept,
        .difficulty = .intermediate,
        .tags = &tags,
        .keywords = &keywords,
        .use_cases = &use_cases,
        .prerequisites = &prereqs,
        .related = &related,
        .next_topics = &next_topics,
        .file_path = "test.md",
        .content_offset = 0,
    };

    const content = "This is about async and await in programming.";
    try builder.addNeurona(&neurona, content);

    // Verify inverted index
    const async_results = builder.inverted_index.search("async").?;
    try std.testing.expectEqual(@as(usize, 1), async_results.neurona_ids.items.len);

    // Verify metadata index
    const concepts = try builder.metadata_index.filterByCategory(.concept, allocator);
    defer allocator.free(concepts);
    try std.testing.expectEqual(@as(usize, 1), concepts.len);
}
