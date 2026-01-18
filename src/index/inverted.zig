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

    /// Fuzzy search for neuronas containing keywords similar to the input
    pub fn fuzzySearch(self: *const InvertedIndex, keyword: []const u8, max_distance: usize) !std.StringHashMapUnmanaged(*const PostingList) {
        var results = std.StringHashMapUnmanaged(*const PostingList){};
        errdefer results.deinit(self.allocator);

        var lower_buf: [256]u8 = undefined;
        if (keyword.len > lower_buf.len) return results;
        const lower_query = std.ascii.lowerString(&lower_buf, keyword);
        const query = lower_query[0..keyword.len];

        var it = self.index.iterator();
        while (it.next()) |entry| {
            const dist = try levenshteinDistance(self.allocator, query, entry.key_ptr.*);
            if (dist <= max_distance) {
                try results.put(self.allocator, entry.key_ptr.*, entry.value_ptr);
            }
        }

        return results;
    }

    /// Get the number of unique keywords indexed
    pub fn keywordCount(self: *const InvertedIndex) usize {
        return self.index.count();
    }

    /// Partial match search - finds keywords that start with the prefix
    pub fn partialMatch(self: *const InvertedIndex, prefix: []const u8) !std.StringHashMapUnmanaged(*const PostingList) {
        var results = std.StringHashMapUnmanaged(*const PostingList){};
        errdefer results.deinit(self.allocator);

        var lower_buf: [256]u8 = undefined;
        if (prefix.len > lower_buf.len) return results;
        const lower_prefix = std.ascii.lowerString(&lower_buf, prefix);
        const prefix_slice = lower_prefix[0..prefix.len];

        var it = self.index.iterator();
        while (it.next()) |entry| {
            if (std.mem.startsWith(u8, entry.key_ptr.*, prefix_slice)) {
                try results.put(self.allocator, entry.key_ptr.*, entry.value_ptr);
            }
        }

        return results;
    }

    /// Phonetic search using Soundex
    pub fn phoneticSearch(self: *const InvertedIndex, word: []const u8) !std.StringHashMapUnmanaged(*const PostingList) {
        var results = std.StringHashMapUnmanaged(*const PostingList){};
        errdefer results.deinit(self.allocator);

        const word_soundex = try soundex(self.allocator, word);
        defer self.allocator.free(word_soundex);

        var it = self.index.iterator();
        while (it.next()) |entry| {
            const keyword_soundex = try soundex(self.allocator, entry.key_ptr.*);
            defer self.allocator.free(keyword_soundex);

            if (std.mem.eql(u8, word_soundex, keyword_soundex)) {
                try results.put(self.allocator, entry.key_ptr.*, entry.value_ptr);
            }
        }

        return results;
    }
};

/// Tokenize text into keywords (simple whitespace + punctuation split)
pub fn tokenize(allocator: Allocator, text: []const u8) ![][]const u8 {
    var tokens = std.ArrayListUnmanaged([]const u8){};
    errdefer {
        for (tokens.items) |token| {
            allocator.free(token);
        }
        tokens.deinit(allocator);
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

/// Calculate Levenshtein distance between two strings
pub fn levenshteinDistance(allocator: Allocator, a: []const u8, b: []const u8) !usize {
    const n = a.len;
    const m = b.len;

    if (n == 0) return m;
    if (m == 0) return n;

    // Standard iterative Levenshtein distance with Two-Row optimization
    const v0 = try allocator.alloc(usize, m + 1);
    defer allocator.free(v0);
    const v1 = try allocator.alloc(usize, m + 1);
    defer allocator.free(v1);

    for (v0, 0..) |*v, i| v.* = i;

    for (a, 0..) |char_a, i| {
        v1[0] = i + 1;
        for (b, 0..) |char_b, j| {
            const cost: usize = if (char_a == char_b) 0 else 1;
            v1[j + 1] = @min(v1[j] + 1, @min(v0[j + 1] + 1, v0[j] + cost));
        }
        @memcpy(v0, v1);
    }

    return v0[m];
}

/// Calculate Soundex code for a word (phonetic matching)
pub fn soundex(allocator: Allocator, word: []const u8) ![]const u8 {
    if (word.len == 0) return &[_]u8{};

    var result = std.ArrayListUnmanaged(u8){};
    defer result.deinit(allocator);

    // Step 1: Keep first letter
    const first_char = std.ascii.toUpper(word[0]);
    try result.append(allocator, first_char);

    // Step 2: Replace consonants with digits
    var prev_digit: u8 = 0;
    for (word[1..]) |c| {
        const upper = std.ascii.toUpper(c);
        const digit: u8 = switch (upper) {
            'B', 'F', 'P', 'V' => 1,
            'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' => 2,
            'D', 'T' => 3,
            'L' => 4,
            'M', 'N' => 5,
            'R' => 6,
            else => 0,
        };

        // Skip vowels, H, W, Y and repeated digits
        if (digit == 0) continue;
        if (digit == prev_digit) continue;

        try result.append(allocator, '0' + digit);
        prev_digit = digit;
    }

    // Step 3: Remove all zeros after first position
    var i: usize = 1;
    while (i < result.items.len) {
        if (result.items[i] == '0') {
            _ = result.orderedRemove(i);
        } else {
            i += 1;
        }
    }

    // Step 4: Pad or truncate to 4 characters
    while (result.items.len < 4) {
        try result.append(allocator, '0');
    }
    if (result.items.len > 4) {
        result.shrinkRetainingCapacity(4);
    }

    return result.toOwnedSlice(allocator);
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

test "levenshteinDistance" {
    const allocator = std.testing.allocator;
    try std.testing.expectEqual(@as(usize, 0), try levenshteinDistance(allocator, "test", "test"));
    try std.testing.expectEqual(@as(usize, 1), try levenshteinDistance(allocator, "test", "tent"));
    try std.testing.expectEqual(@as(usize, 4), try levenshteinDistance(allocator, "test", "texting"));
    // test -> text (1) -> texting (3 more) -> 4?
    // let's re-eval: test vs tent is 1 (s -> n)
    try std.testing.expectEqual(@as(usize, 1), try levenshteinDistance(allocator, "test", "tests"));
    try std.testing.expectEqual(@as(usize, 1), try levenshteinDistance(allocator, "test", "est"));
}

test "InvertedIndex fuzzy search" {
    const allocator = std.testing.allocator;
    var index = InvertedIndex.init(allocator);
    defer index.deinit();

    try index.addKeyword("python", "id1", 1.0);
    try index.addKeyword("cython", "id2", 1.0);
    try index.addKeyword("java", "id3", 1.0);

    var results = try index.fuzzySearch("pyton", 1);
    defer results.deinit(allocator);

    try std.testing.expectEqual(@as(usize, 1), results.count());
    try std.testing.expect(results.contains("python"));
    try std.testing.expect(!results.contains("cython"));
}
