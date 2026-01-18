const std = @import("std");
const Allocator = std.mem.Allocator;

/// Inverted index: keyword → list of neurona IDs with term frequency
pub const InvertedIndex = struct {
    /// Maps keywords to posting lists
    index: std.StringHashMapUnmanaged(PostingList),
    allocator: Allocator,

    pub const PostingList = struct {
        /// Neurona IDs containing this keyword
        neurona_ids: std.ArrayListUnmanaged([]const u8),
        /// Term frequency for each neurona (parallel to neurona_ids)
        term_frequencies: std.ArrayListUnmanaged(f32),

        pub fn init() PostingList {
            return .{
                .neurona_ids = .{},
                .term_frequencies = .{},
            };
        }

        pub fn deinit(self: *PostingList, allocator: Allocator) void {
            for (self.neurona_ids.items) |id| {
                allocator.free(id);
            }
            self.neurona_ids.deinit(allocator);
            self.term_frequencies.deinit(allocator);
        }

        pub fn add(self: *PostingList, allocator: Allocator, neurona_id: []const u8, tf: f32) !void {
            const id_copy = try allocator.dupe(u8, neurona_id);
            errdefer allocator.free(id_copy);

            try self.neurona_ids.append(allocator, id_copy);
            try self.term_frequencies.append(allocator, tf);
        }
    };

    pub fn init(allocator: Allocator) InvertedIndex {
        return .{
            .index = .{},
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *InvertedIndex) void {
        var it = self.index.iterator();
        while (it.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(self.allocator);
        }
        self.index.deinit(self.allocator);
    }

    /// Add a keyword → neurona_id mapping with term frequency
    pub fn addKeyword(self: *InvertedIndex, keyword: []const u8, neurona_id: []const u8, tf: f32) !void {
        // Normalize keyword to lowercase for case-insensitive matching
        const normalized = try std.ascii.allocLowerString(self.allocator, keyword);
        errdefer self.allocator.free(normalized);

        const result = try self.index.getOrPut(self.allocator, normalized);
        if (!result.found_existing) {
            result.value_ptr.* = PostingList.init();
        } else {
            // Key already exists, free the duplicate
            self.allocator.free(normalized);
        }

        try result.value_ptr.add(self.allocator, neurona_id, tf);
    }

    /// Search for neuronas containing the keyword (case-insensitive)
    pub fn search(self: *const InvertedIndex, keyword: []const u8) ?*const PostingList {
        // Create temporary lowercase version for lookup
        var lower_buf: [256]u8 = undefined;
        if (keyword.len > lower_buf.len) return null;

        const lower = std.ascii.lowerString(&lower_buf, keyword);
        return self.index.getPtr(lower[0..keyword.len]);
    }

    /// Get the number of unique keywords indexed
    pub fn keywordCount(self: *const InvertedIndex) usize {
        return self.index.count();
    }
};

/// Tokenize text into keywords (simple whitespace + punctuation split)
pub fn tokenize(allocator: Allocator, text: []const u8) ![][]const u8 {
    var tokens = std.ArrayListUnmanaged([]const u8){};
    errdefer {
        for (tokens.items) |token| {
            allocator.free(token);
        }
        tokens.deinit();
    }

    var iter = std.mem.tokenizeAny(u8, text, " \t\n\r.,;:!?()[]{}\"'`");
    while (iter.next()) |token| {
        if (token.len > 0) {
            const token_copy = try allocator.dupe(u8, token);
            try tokens.append(allocator, token_copy);
        }
    }

    return tokens.toOwnedSlice(allocator);
}

/// Calculate term frequency for a keyword in a document
pub fn calculateTermFrequency(text: []const u8, keyword: []const u8) f32 {
    var count: usize = 0;
    var total: usize = 0;

    var iter = std.mem.tokenizeAny(u8, text, " \t\n\r.,;:!?()[]{}\"'`");
    while (iter.next()) |token| {
        total += 1;
        if (std.ascii.eqlIgnoreCase(token, keyword)) {
            count += 1;
        }
    }

    if (total == 0) return 0.0;
    return @as(f32, @floatFromInt(count)) / @as(f32, @floatFromInt(total));
}

test "InvertedIndex basic operations" {
    const allocator = std.testing.allocator;
    var index = InvertedIndex.init(allocator);
    defer index.deinit();

    try index.addKeyword("async", "py.async.coroutines", 0.05);
    try index.addKeyword("async", "js.async.promises", 0.08);
    try index.addKeyword("function", "py.functions.basics", 0.12);

    try std.testing.expectEqual(@as(usize, 2), index.keywordCount());

    const async_results = index.search("async").?;
    try std.testing.expectEqual(@as(usize, 2), async_results.neurona_ids.items.len);
}

test "InvertedIndex case insensitive" {
    const allocator = std.testing.allocator;
    var index = InvertedIndex.init(allocator);
    defer index.deinit();

    try index.addKeyword("Async", "test.id", 0.1);

    try std.testing.expect(index.search("async") != null);
    try std.testing.expect(index.search("ASYNC") != null);
    try std.testing.expect(index.search("Async") != null);
}

test "tokenize basic text" {
    const allocator = std.testing.allocator;
    const tokens = try tokenize(allocator, "Hello, world! This is a test.");
    defer {
        for (tokens) |token| {
            allocator.free(token);
        }
        allocator.free(tokens);
    }

    try std.testing.expectEqual(@as(usize, 6), tokens.len);
    try std.testing.expectEqualStrings("Hello", tokens[0]);
    try std.testing.expectEqualStrings("world", tokens[1]);
}

test "calculateTermFrequency" {
    const text = "async is great. async functions are async.";
    const tf = calculateTermFrequency(text, "async");
    try std.testing.expect(tf > 0.0);
    try std.testing.expect(tf < 1.0);
}
