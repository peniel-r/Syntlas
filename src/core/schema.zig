const std = @import("std");

pub const Category = enum {
    language,
    framework,
    library,
    concept,
    pattern,
    snippet,
    unknown,
};

pub const Difficulty = enum {
    novice,
    intermediate,
    advanced,
    expert,
    unknown,
};

pub const RelationshipType = enum {
    prerequisite,
    related,
    next_topic,
    alternative,
    complement,
};

pub const MatchType = enum {
    exact_id,
    exact_title,
    fuzzy,
    semantic,
};

pub const Synapse = struct {
    id: []const u8,
    weight: u8, // 0 - 100 (quantized)
    optional: bool,
    relationship: RelationshipType,
};

pub const QualityFlags = packed struct {
    tested: bool = false,
    production_ready: bool = false,
    benchmarked: bool = false,
    deprecated: bool = false,
    _padding: u4 = 0,
};

pub const Neurona = struct {
    id: []const u8,
    title: []const u8,
    category: Category = .concept,
    difficulty: Difficulty = .intermediate,
    tags: [][]const u8,
    keywords: [][]const u8,
    use_cases: [][]const u8,

    // Synapses
    prerequisites: []Synapse,
    related: []Synapse,
    next_topics: []Synapse,

    // Metadata
    search_weight: u8 = 100, // 0 - 100 (quantized)
    quality: QualityFlags = .{},
    last_updated: i64 = 0, // Unix timestamp (seconds since epoch)

    // Content location
    file_path: []const u8,
    content_offset: usize,

    pub fn deinit(self: *Neurona, allocator: std.mem.Allocator) void {
        allocator.free(self.id);
        allocator.free(self.title);
        for (self.tags) |tag| allocator.free(tag);
        allocator.free(self.tags);
        for (self.keywords) |kw| allocator.free(kw);
        allocator.free(self.keywords);
        for (self.use_cases) |uc| allocator.free(uc);
        allocator.free(self.use_cases);
        for (self.prerequisites) |p| allocator.free(p.id);
        allocator.free(self.prerequisites);
        for (self.related) |r| allocator.free(r.id);
        allocator.free(self.related);
        for (self.next_topics) |n| allocator.free(n.id);
        allocator.free(self.next_topics);
    }
};

pub const Activation = struct {
    neurona: *const Neurona,
    relevance_score: f32,
    match_type: MatchType,
};

/// Lightweight summary of an activated Neurona for search results
pub const ActivationSummary = struct {
    id: []const u8,
    score: f32,
    snippet: ?[]const u8 = null,
};

test "Category enum values" {
    try std.testing.expectEqual(@as(i32, 7), @typeInfo(Category).@"enum".fields.len);
}

test "Difficulty enum values" {
    try std.testing.expectEqual(@as(i32, 5), @typeInfo(Difficulty).@"enum".fields.len);
}

test "QualityFlags defaults" {
    const flags = QualityFlags{};
    try std.testing.expect(!flags.tested);
    try std.testing.expect(!flags.production_ready);
    try std.testing.expect(!flags.benchmarked);
    try std.testing.expect(!flags.deprecated);
}

test "Neurona struct size" {
    try std.testing.expect(@sizeOf(Neurona) > 0);
}
