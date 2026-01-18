const std = @import("std");
const core = @import("../core/mod.zig");

const yaml = @import("yaml.zig");

fn parseArrayField(allocator: std.mem.Allocator, value: []const u8) ![][]const u8 {
    if (value.len == 0) return &.{};

    var parts = std.ArrayListUnmanaged([]const u8){};
    errdefer {
        for (parts.items) |item| allocator.free(item);
        parts.deinit(allocator);
    }

    var start: usize = 0;
    for (value, 0..) |c, i| {
        if (c == ',') {
            if (i > start) {
                const trimmed = std.mem.trim(u8, value[start..i], " \t");
                const item = try allocator.dupe(u8, trimmed);
                try parts.append(allocator, item);
            }
            start = i + 1;
        }
    }

    if (start < value.len) {
        const item = try allocator.dupe(u8, std.mem.trim(u8, value[start..], " \t"));
        try parts.append(allocator, item);
    }

    return try parts.toOwnedSlice(allocator);
}

fn parseSynapses(allocator: std.mem.Allocator, value: []const u8) ![]core.Synapse {
    if (value.len == 0) return &.{};

    var synapses = std.ArrayListUnmanaged(core.Synapse){};
    errdefer synapses.deinit(allocator);

    var start: usize = 0;
    for (value, 0..) |c, i| {
        if (c == ',') {
            if (i > start) {
                const item = std.mem.trim(u8, value[start..i], " \t");
                if (item.len > 0) {
                    try synapses.append(allocator, .{
                        .id = try allocator.dupe(u8, item),
                        .weight = 100,
                        .optional = false,
                        .relationship = .prerequisite,
                    });
                }
            }
            start = i + 1;
        }
    }

    if (start < value.len) {
        const item = std.mem.trim(u8, value[start..], " \t");
        if (item.len > 0) {
            try synapses.append(allocator, .{
                .id = try allocator.dupe(u8, item),
                .weight = 100,
                .optional = false,
                .relationship = .prerequisite,
            });
        }
    }

    return try synapses.toOwnedSlice(allocator);
}

pub fn parse(allocator: std.mem.Allocator, content: []const u8) !core.Neurona {
    if (!std.mem.startsWith(u8, content, "---")) {
        return error.MissingFrontmatter;
    }

    const end_idx = std.mem.indexOfPos(u8, content, 3, "---") orelse return error.MissingFrontmatterEnd;
    const frontmatter = content[3..end_idx];

    var parser = yaml.Parser.init(allocator, frontmatter);
    var map = try parser.parse();
    defer map.deinit();

    const id = if (map.get("id")) |val| try allocator.dupe(u8, val) else try allocator.dupe(u8, "unknown");
    const title = if (map.get("title")) |val| try allocator.dupe(u8, val) else try allocator.dupe(u8, "Untitled");

    const tags = if (map.get("tags")) |val| try parseArrayField(allocator, val) else @as([][]const u8, &.{});
    const keywords = if (map.get("keywords")) |val| try parseArrayField(allocator, val) else @as([][]const u8, &.{});
    const use_cases = if (map.get("use_cases")) |val| try parseArrayField(allocator, val) else @as([][]const u8, &.{});
    const prerequisites = if (map.get("prerequisites")) |val| try parseSynapses(allocator, val) else @as([]core.Synapse, &.{});
    const related = if (map.get("related")) |val| try parseSynapses(allocator, val) else @as([]core.Synapse, &.{});
    const next_topics = if (map.get("next_topics")) |val| try parseSynapses(allocator, val) else @as([]core.Synapse, &.{});

    const category: core.Category = if (map.get("category")) |val| blk: {
        if (std.mem.eql(u8, val, "language")) break :blk .language;
        if (std.mem.eql(u8, val, "framework")) break :blk .framework;
        if (std.mem.eql(u8, val, "library")) break :blk .library;
        if (std.mem.eql(u8, val, "pattern")) break :blk .pattern;
        if (std.mem.eql(u8, val, "snippet")) break :blk .snippet;
        break :blk .concept;
    } else .concept;

    const difficulty: core.Difficulty = if (map.get("difficulty")) |val| blk: {
        if (std.mem.eql(u8, val, "novice")) break :blk .novice;
        if (std.mem.eql(u8, val, "intermediate")) break :blk .intermediate;
        if (std.mem.eql(u8, val, "advanced")) break :blk .advanced;
        if (std.mem.eql(u8, val, "expert")) break :blk .expert;
        break :blk .intermediate;
    } else .intermediate;

    return core.Neurona{
        .id = id,
        .title = title,
        .category = category,
        .difficulty = difficulty,
        .tags = tags,
        .keywords = keywords,
        .use_cases = use_cases,
        .prerequisites = prerequisites,
        .related = related,
        .next_topics = next_topics,
        .file_path = "",
        .content_offset = end_idx + 3,
    };
}

test "parseArrayField" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try parseArrayField(allocator, "tag1,tag2,tag3");
    defer {
        for (result) |item| allocator.free(item);
        allocator.free(result);
    }

    try std.testing.expectEqual(@as(usize, 3), result.len);
    try std.testing.expectEqualStrings("tag1", result[0]);
    try std.testing.expectEqualStrings("tag2", result[1]);
    try std.testing.expectEqualStrings("tag3", result[2]);
}

test "parseArrayField empty" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try parseArrayField(allocator, "");
    defer {
        for (result) |item| allocator.free(item);
        allocator.free(result);
    }

    try std.testing.expectEqual(@as(usize, 0), result.len);
}

test "parseSynapses" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try parseSynapses(allocator, "topic1,topic2");
    defer {
        for (result) |syn| allocator.free(syn.id);
        allocator.free(result);
    }

    try std.testing.expectEqual(@as(usize, 2), result.len);
    try std.testing.expectEqualStrings("topic1", result[0].id);
    try std.testing.expectEqualStrings("topic2", result[1].id);
}

test "parse simple neurona" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const neurona = try parse(allocator,
        \\---
        \\id: "test.neurona"
        \\title: "Test Neurona"
        \\---
        \\Content here
    );
    defer {
        allocator.free(neurona.id);
        allocator.free(neurona.title);
        for (neurona.tags) |tag| allocator.free(tag);
        for (neurona.keywords) |kw| allocator.free(kw);
        for (neurona.use_cases) |uc| allocator.free(uc);
        for (neurona.prerequisites) |p| allocator.free(p.id);
        for (neurona.related) |r| allocator.free(r.id);
        for (neurona.next_topics) |n| allocator.free(n.id);
        allocator.free(neurona.tags);
        allocator.free(neurona.keywords);
        allocator.free(neurona.use_cases);
        allocator.free(neurona.prerequisites);
        allocator.free(neurona.related);
        allocator.free(neurona.next_topics);
    }

    try std.testing.expectEqualStrings("test.neurona", neurona.id);
    try std.testing.expectEqualStrings("Test Neurona", neurona.title);
    try std.testing.expectEqual(core.Category.concept, neurona.category);
    try std.testing.expectEqual(core.Difficulty.intermediate, neurona.difficulty);
}

test "parse neurona with arrays" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const neurona = try parse(allocator,
        \\---
        \\id: "test.neurona"
        \\title: "Test Neurona"
        \\tags: [tag1, tag2]
        \\keywords: [kw1, kw2]
        \\prerequisites: [prereq1, prereq2]
        \\---
        \\Content here
    );
    defer {
        allocator.free(neurona.id);
        allocator.free(neurona.title);
        for (neurona.tags) |tag| allocator.free(tag);
        for (neurona.keywords) |kw| allocator.free(kw);
        for (neurona.use_cases) |uc| allocator.free(uc);
        for (neurona.prerequisites) |p| allocator.free(p.id);
        for (neurona.related) |r| allocator.free(r.id);
        for (neurona.next_topics) |n| allocator.free(n.id);
        allocator.free(neurona.tags);
        allocator.free(neurona.keywords);
        allocator.free(neurona.use_cases);
        allocator.free(neurona.prerequisites);
        allocator.free(neurona.related);
        allocator.free(neurona.next_topics);
    }

    try std.testing.expectEqual(@as(usize, 2), neurona.tags.len);
    try std.testing.expectEqual(@as(usize, 2), neurona.keywords.len);
    try std.testing.expectEqual(@as(usize, 2), neurona.prerequisites.len);
}
