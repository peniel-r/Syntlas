const std = @import("std");
const Allocator = std.mem.Allocator;
const inverted = @import("inverted.zig");

/// Use-Case index for semantic/intent-based matching
pub const UseCaseIndex = struct {
    /// Underlying inverted index for use case text
    index: inverted.InvertedIndex,
    allocator: Allocator,

    pub fn init(allocator: Allocator) UseCaseIndex {
        return .{
            .index = inverted.InvertedIndex.init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *UseCaseIndex) void {
        self.index.deinit();
    }

    /// Add a use case string to the index
    pub fn addUseCase(self: *UseCaseIndex, use_case_text: []const u8, neurona_id: []const u8) !void {
        // Tokenize and add to inverted index
        const tokens = try inverted.tokenize(self.allocator, use_case_text);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            // Weight could be based on something, but for now 1.0 (or split by length?)
            // If use case is "fix memory leak", accessing "memory" gives this neurona.
            // We might want to normalize weight by use case length?
            // Simple approach: TF (frequency in the use case string, usually 1)
            const tf = inverted.calculateTermFrequency(use_case_text, token);
            try self.index.addKeyword(token, neurona_id, tf);
        }
    }

    /// Search for neuronas matching a query in their use cases
    pub fn search(self: *const UseCaseIndex, query: []const u8) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        const tokens = try inverted.tokenize(self.allocator, query);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            if (self.index.search(token)) |posting_list| {
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
};

test "UseCaseIndex basic" {
    const allocator = std.testing.allocator;
    var index = UseCaseIndex.init(allocator);
    defer index.deinit();

    try index.addUseCase("fix memory leak", "id1");
    try index.addUseCase("handle memory", "id2");

    var results = try index.search("memory leak");
    defer results.deinit(allocator);

    try std.testing.expect(results.contains("id1")); // has memory + leak
    try std.testing.expect(results.contains("id2")); // has memory

    // id1 should score higher (2 matches) vs id2 (1 match) if TF logic holds
    // "fix memory leak": memory(1/3), leak(1/3) -> query "memory leak" hits both: 0.33 + 0.33 = 0.66
    // "handle memory": memory(1/2) -> query "memory leak" hits memory: 0.5
    try std.testing.expect(results.get("id1").? > results.get("id2").?);
}
