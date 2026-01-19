const std = @import("std");
const search = @import("../search/mod.zig");
const schema = @import("../core/schema.zig");

const ActivationSummary = schema.ActivationSummary;

pub const JsonValue = union(enum) {
    object: std.StringArrayHashMap(JsonValue),
    array: std.ArrayList(JsonValue),
    string: []const u8,
    number: f64,
    boolean: bool,
    null,
};

pub fn formatSearchResults(allocator: std.mem.Allocator, results: []const ActivationSummary, query_time_ms: f64) ![]const u8 {
    var root = JsonValue{ .object = std.StringArrayHashMap(JsonValue).init(allocator) };

    try root.object.put("success", JsonValue{ .boolean = true });
    try root.object.put("query_time_ms", JsonValue{ .number = query_time_ms });

    var results_array = std.ArrayListUnmanaged(JsonValue){};

    for (results) |result| {
        var result_obj = std.StringArrayHashMap(JsonValue).init(allocator);

        try result_obj.put("id", JsonValue{ .string = result.id });
        try result_obj.put("score", JsonValue{ .number = @floatCast(result.score) });

        if (result.snippet) |snippet| {
            try result_obj.put("snippet", JsonValue{ .string = snippet });
        } else {
            try result_obj.put("snippet", JsonValue.null);
        }

        try results_array.append(allocator, JsonValue{ .object = result_obj });
    }

    try root.object.put("count", JsonValue{ .number = @floatFromInt(results.len) });
    try root.object.put("results", JsonValue{ .array = results_array });

    const output = try serializeJsonValue(allocator, root);
    
    deinit(&root, allocator);
    return output;
}

pub fn formatNeurona(allocator: std.mem.Allocator, neurona: *const schema.Neurona, content: []const u8) ![]const u8 {
    var root = JsonValue{ .object = std.StringArrayHashMap(JsonValue).init(allocator) };

    try root.object.put("success", JsonValue{ .boolean = true });

    var neurona_obj = std.StringArrayHashMap(JsonValue).init(allocator);

    try neurona_obj.put("id", JsonValue{ .string = neurona.id });
    try neurona_obj.put("title", JsonValue{ .string = neurona.title });
    try neurona_obj.put("category", JsonValue{ .string = categoryToString(neurona.category) });
    try neurona_obj.put("difficulty", JsonValue{ .string = difficultyToString(neurona.difficulty) });

    // Tags
    var tags_array = std.ArrayListUnmanaged(JsonValue){};
    for (neurona.tags) |tag| {
        try tags_array.append(allocator, JsonValue{ .string = tag });
    }
    try neurona_obj.put("tags", JsonValue{ .array = tags_array });

    // Keywords
    var keywords_array = std.ArrayListUnmanaged(JsonValue){};
    for (neurona.keywords) |keyword| {
        try keywords_array.append(allocator, JsonValue{ .string = keyword });
    }
    try neurona_obj.put("keywords", JsonValue{ .array = keywords_array });

    // Content
    try neurona_obj.put("content", JsonValue{ .string = content });

    // Synapses
    var prerequisites_array = std.ArrayListUnmanaged(JsonValue){};
    for (neurona.prerequisites) |synapse| {
        try prerequisites_array.append(allocator, JsonValue{ .string = synapse.id });
    }
    try neurona_obj.put("prerequisites", JsonValue{ .array = prerequisites_array });

    var related_array = std.ArrayListUnmanaged(JsonValue){};
    for (neurona.related) |synapse| {
        try related_array.append(allocator, JsonValue{ .string = synapse.id });
    }
    try neurona_obj.put("related", JsonValue{ .array = related_array });

    var next_topics_array = std.ArrayListUnmanaged(JsonValue){};
    for (neurona.next_topics) |synapse| {
        try next_topics_array.append(allocator, JsonValue{ .string = synapse.id });
    }
    try neurona_obj.put("next_topics", JsonValue{ .array = next_topics_array });

    try root.object.put("neurona", JsonValue{ .object = neurona_obj });

    const output = try serializeJsonValue(allocator, root);
    deinit(&root, allocator);
    return output;
}

pub fn formatError(allocator: std.mem.Allocator, error_msg: []const u8) ![]const u8 {
    var root = JsonValue{ .object = std.StringArrayHashMap(JsonValue).init(allocator) };

    try root.object.put("success", JsonValue{ .boolean = false });
    try root.object.put("error", JsonValue{ .string = error_msg });

    const output = try serializeJsonValue(allocator, root);
    deinit(&root, allocator);
    return output;
}

pub fn formatSuccess(allocator: std.mem.Allocator, message: []const u8) ![]const u8 {
    var root = JsonValue{ .object = std.StringArrayHashMap(JsonValue).init(allocator) };

    try root.object.put("success", JsonValue{ .boolean = true });
    try root.object.put("message", JsonValue{ .string = message });

    const output = try serializeJsonValue(allocator, root);
    deinit(&root, allocator);
    return output;
}

pub fn formatTomeList(allocator: std.mem.Allocator, tomes: []const []const u8) ![]const u8 {
    var root = JsonValue{ .object = std.StringArrayHashMap(JsonValue).init(allocator) };

    try root.object.put("success", JsonValue{ .boolean = true });

    var tomes_array = std.ArrayListUnmanaged(JsonValue){};
    for (tomes) |tome| {
        try tomes_array.append(allocator, JsonValue{ .string = tome });
    }

    try root.object.put("tomes", JsonValue{ .array = tomes_array });
    try root.object.put("count", JsonValue{ .number = @floatFromInt(tomes.len) });

    const output = try serializeJsonValue(allocator, root);
    deinit(&root, allocator);
    return output;
}

fn serializeJsonValue(allocator: std.mem.Allocator, value: JsonValue) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);

    try writeJsonValue(writer, value);

    return buffer.toOwnedSlice(allocator);
}

fn writeJsonValue(writer: anytype, value: JsonValue) !void {
    switch (value) {
        .null => try writer.writeAll("null"),
        .boolean => |b| try writer.writeAll(if (b) "true" else "false"),
        .number => |n| try writer.print("{d}", .{n}),
        .string => |s| {
            try writer.writeByte('"');
            try writeEscapedString(writer, s);
            try writer.writeByte('"');
        },
        .array => |arr| {
            try writer.writeByte('[');
            for (arr.items, 0..) |item, i| {
                if (i > 0) try writer.writeByte(',');
                try writeJsonValue(writer, item);
            }
            try writer.writeByte(']');
        },
        .object => |obj| {
            try writer.writeByte('{');
            var iter = obj.iterator();
            var first = true;
            while (iter.next()) |entry| {
                if (!first) try writer.writeByte(',');
                try writer.writeByte('"');
                try writeEscapedString(writer, entry.key_ptr.*);
                try writer.writeAll("\":");
                try writeJsonValue(writer, entry.value_ptr.*);
                first = false;
            }
            try writer.writeByte('}');
        },
    }
}

fn writeEscapedString(writer: anytype, s: []const u8) !void {
    for (s) |c| {
        switch (c) {
            '"' => try writer.writeAll("\\\""),
            '\\' => try writer.writeAll("\\\\"),
            '\n' => try writer.writeAll("\\n"),
            '\r' => try writer.writeAll("\\r"),
            '\t' => try writer.writeAll("\\t"),
            else => try writer.writeByte(c),
        }
    }
}

pub fn deinit(self: *JsonValue, allocator: std.mem.Allocator) void {
    switch (self.*) {
        .object => |*obj| {
            var iter = obj.iterator();
            while (iter.next()) |entry| {
                deinit(entry.value_ptr, allocator);
            }
            obj.deinit();
        },
        .array => |*arr| {
            for (arr.items) |*item| {
                deinit(item, allocator);
            }
            arr.deinit(allocator);
        },
        .string, .number, .boolean, .null => {},
    }
}

fn categoryToString(cat: schema.Category) []const u8 {
    return switch (cat) {
        .language => "language",
        .library => "library",
        .framework => "framework",
        .concept => "concept",
        .pattern => "pattern",
        .snippet => "snippet",
        .unknown => "unknown",
    };
}

fn difficultyToString(diff: schema.Difficulty) []const u8 {
    return switch (diff) {
        .novice => "novice",
        .intermediate => "intermediate",
        .advanced => "advanced",
        .expert => "expert",
        .unknown => "unknown",
    };
}