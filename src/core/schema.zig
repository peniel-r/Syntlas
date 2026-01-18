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
    weight: f32, // 0.0 - 1.0
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

    // Neural connections
    prerequisites: []Synapse,
    related: []Synapse,
    next_topics: []Synapse,

    // Metadata
    search_weight: f32 = 1.0,
    quality: QualityFlags = .{},

    // Content location
    file_path: []const u8,
    content_offset: usize,
};

pub const Activation = struct {
    neurona: *const Neurona,
    relevance_score: f32,
    match_type: MatchType,
};

test "Category enum values" {
    try std.testing.expectEqual(@as(i32, 6), @typeInfo(Category).@"enum".fields.len);
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
