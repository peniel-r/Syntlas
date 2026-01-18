const std = @import("std");

/// Tome metadata structure (parsed from tome.json)
pub const TomeMetadata = struct {
    name: []const u8,
    version: []const u8,
    author: []const u8,
    license: []const u8,
    description: []const u8,
    languages: [][]const u8,
    dependencies: [][]const u8,
    min_syntlas_version: []const u8,

    pub fn deinit(self: *TomeMetadata, allocator: std.mem.Allocator) void {
        allocator.free(self.name);
        allocator.free(self.version);
        allocator.free(self.author);
        allocator.free(self.license);
        allocator.free(self.description);
        for (self.languages) |lang| {
            allocator.free(lang);
        }
        allocator.free(self.languages);
        for (self.dependencies) |dep| {
            allocator.free(dep);
        }
        allocator.free(self.dependencies);
        allocator.free(self.min_syntlas_version);
    }
};

/// Parse tome.json file
pub fn parseMetadata(allocator: std.mem.Allocator, json_content: []const u8) !TomeMetadata {
    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_content, .{ .ignore_unknown_fields = true });
    defer parsed.deinit();

    const root = parsed.value.object;

    const name = if (root.get("name")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "unknown");
    errdefer allocator.free(name);

    const version = if (root.get("version")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "0.0.0");
    errdefer allocator.free(version);

    const author = if (root.get("author")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "Unknown");
    errdefer allocator.free(author);

    const license = if (root.get("license")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "Unset");
    errdefer allocator.free(license);

    const description = if (root.get("description")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "");
    errdefer allocator.free(description);

    // Parse languages array
    var languages_list = std.ArrayListUnmanaged([]const u8){};
    errdefer {
        for (languages_list.items) |lang| allocator.free(lang);
        languages_list.deinit(allocator);
    }

    if (root.get("languages")) |langs_value| {
        const array = langs_value.array;
        for (array.items) |lang| {
            try languages_list.append(allocator, try allocator.dupe(u8, lang.string));
        }
    } else if (root.get("language")) |lang_value| {
        try languages_list.append(allocator, try allocator.dupe(u8, lang_value.string));
    }

    // Parse dependencies array
    var dependencies_list = std.ArrayListUnmanaged([]const u8){};
    errdefer {
        for (dependencies_list.items) |dep| allocator.free(dep);
        dependencies_list.deinit(allocator);
    }

    if (root.get("dependencies")) |deps_value| {
        const array = deps_value.array;
        for (array.items) |dep| {
            try dependencies_list.append(allocator, try allocator.dupe(u8, dep.string));
        }
    }

    const min_syntlas_version = if (root.get("min_syntlas_version")) |v| try allocator.dupe(u8, v.string) else try allocator.dupe(u8, "0.1.0");
    errdefer allocator.free(min_syntlas_version);

    return TomeMetadata{
        .name = name,
        .version = version,
        .author = author,
        .license = license,
        .description = description,
        .languages = try languages_list.toOwnedSlice(allocator),
        .dependencies = try dependencies_list.toOwnedSlice(allocator),
        .min_syntlas_version = min_syntlas_version,
    };
}

test "parseMetadata" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const json =
        \\{
        \\  "name": "python-tome",
        \\  "version": "1.0.0",
        \\  "author": "Test Author",
        \\  "license": "MIT",
        \\  "description": "Python documentation tome",
        \\  "languages": ["python"],
        \\  "dependencies": [],
        \\  "min_syntlas_version": "0.1.0"
        \\}
    ;

    var metadata = try parseMetadata(allocator, json);
    defer metadata.deinit(allocator);

    try std.testing.expectEqualStrings("python-tome", metadata.name);
    try std.testing.expectEqualStrings("1.0.0", metadata.version);
    try std.testing.expectEqualStrings("Test Author", metadata.author);
    try std.testing.expectEqualStrings("MIT", metadata.license);
    try std.testing.expectEqual(@as(usize, 1), metadata.languages.len);
    try std.testing.expectEqualStrings("python", metadata.languages[0]);
}
