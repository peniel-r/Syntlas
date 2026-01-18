const std = @import("std");
const Allocator = std.mem.Allocator;
const inverted = @import("inverted.zig");

/// Intent types for semantic matching
pub const IntentType = enum {
    learn, // User wants to learn about a concept
    fix, // User has a problem to solve
    implement, // User wants to implement something
    optimize, // User wants to improve existing code
    debug, // User is debugging an issue
};

/// Use-Case index for semantic/intent-based matching
pub const UseCaseIndex = struct {
    /// Underlying inverted index for use case text
    index: inverted.InvertedIndex,
    /// Intent-based index (intent keyword -> neurona_ids)
    intent_index: std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)),
    /// Problem-solution mapping (problem keyword -> solution neurona_ids)
    problem_index: inverted.InvertedIndex,
    /// Example query index (example query -> neurona_id)
    example_index: std.StringHashMapUnmanaged([]const u8),
    allocator: Allocator,

    pub fn init(allocator: Allocator) UseCaseIndex {
        return .{
            .index = inverted.InvertedIndex.init(allocator),
            .intent_index = .{},
            .problem_index = inverted.InvertedIndex.init(allocator),
            .example_index = .{},
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *UseCaseIndex) void {
        self.index.deinit();
        self.problem_index.deinit();

        var intent_it = self.intent_index.iterator();
        while (intent_it.next()) |entry| {
            for (entry.value_ptr.items) |id| {
                self.allocator.free(id);
            }
            entry.value_ptr.deinit(self.allocator);
            self.allocator.free(entry.key_ptr.*);
        }
        self.intent_index.deinit(self.allocator);

        var example_it = self.example_index.iterator();
        while (example_it.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
            self.allocator.free(entry.value_ptr.*);
        }
        self.example_index.deinit(self.allocator);
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

    /// Add intent-based mapping for a neurona
    pub fn addIntent(self: *UseCaseIndex, intent: IntentType, neurona_id: []const u8) !void {
        const intent_str = @tagName(intent);
        const result = try self.intent_index.getOrPut(self.allocator, intent_str);
        if (!result.found_existing) {
            result.value_ptr.* = std.ArrayListUnmanaged([]const u8){};
        }

        const id_copy = try self.allocator.dupe(u8, neurona_id);
        try result.value_ptr.append(self.allocator, id_copy);
    }

    /// Add problem-solution mapping
    pub fn addProblemSolution(self: *UseCaseIndex, problem: []const u8, neurona_id: []const u8) !void {
        const tokens = try inverted.tokenize(self.allocator, problem);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            const tf = inverted.calculateTermFrequency(problem, token);
            try self.problem_index.addKeyword(token, neurona_id, tf);
        }
    }

    /// Add example query for a neurona
    pub fn addExampleQuery(self: *UseCaseIndex, example: []const u8, neurona_id: []const u8) !void {
        const example_copy = try self.allocator.dupe(u8, example);
        errdefer self.allocator.free(example_copy);

        const id_copy = try self.allocator.dupe(u8, neurona_id);
        errdefer self.allocator.free(id_copy);

        try self.example_index.put(self.allocator, example_copy, id_copy);
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

    /// Intent-based discovery: find neuronas matching user intent
    pub fn searchByIntent(self: *const UseCaseIndex, intent: IntentType) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        const intent_str = @tagName(intent);
        if (self.intent_index.get(intent_str)) |neurona_list| {
            for (neurona_list.items) |id| {
                const result = try activations.getOrPut(self.allocator, id);
                if (!result.found_existing) {
                    result.value_ptr.* = 1.0; // Base score for intent match
                }
            }
        }

        return activations;
    }

    /// Problem-solution matching: find solutions for a problem
    pub fn searchSolutions(self: *const UseCaseIndex, problem: []const u8) !std.StringHashMapUnmanaged(f32) {
        var activations = std.StringHashMapUnmanaged(f32){};

        const tokens = try inverted.tokenize(self.allocator, problem);
        defer {
            for (tokens) |token| {
                self.allocator.free(token);
            }
            self.allocator.free(tokens);
        }

        for (tokens) |token| {
            if (self.problem_index.search(token)) |posting_list| {
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

    /// Example query matching: find neurona by exact example query
    pub fn searchByExample(self: *const UseCaseIndex, example: []const u8) !?[]const u8 {
        return self.example_index.get(example);
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
