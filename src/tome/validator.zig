const std = @import("std");
const core = @import("../core/mod.zig");
const parser = @import("parser.zig");
const metadata = @import("metadata.zig");
const security = @import("../security/mod.zig");

pub const ValidationError = struct {
    file_path: []const u8,
    line: ?usize,
    message: []const u8,

    pub fn deinit(self: *ValidationError, allocator: std.mem.Allocator) void {
        allocator.free(self.file_path);
        allocator.free(self.message);
    }
};

pub const ValidationResult = struct {
    valid: bool,
    errors: []ValidationError,

    pub fn deinit(self: *ValidationResult, allocator: std.mem.Allocator) void {
        for (self.errors) |*err| {
            err.deinit(allocator);
        }
        allocator.free(self.errors);
    }
};

/// Validate a tome directory structure and content
pub fn validateTome(allocator: std.mem.Allocator, tome_path: []const u8) !ValidationResult {
    var errors = std.ArrayListUnmanaged(ValidationError){};
    errdefer {
        for (errors.items) |*err| err.deinit(allocator);
        errors.deinit(allocator);
    }

    // Check for tome.json
    const tome_json_path = try std.fs.path.join(allocator, &.{ tome_path, "tome.json" });
    defer allocator.free(tome_json_path);

    const tome_json_file = std.fs.cwd().openFile(tome_json_path, .{}) catch |err| {
        try errors.append(allocator, .{
            .file_path = try allocator.dupe(u8, tome_json_path),
            .line = null,
            .message = try std.fmt.allocPrint(allocator, "Failed to open tome.json: {}", .{err}),
        });
        return ValidationResult{
            .valid = false,
            .errors = try errors.toOwnedSlice(allocator),
        };
    };
    defer tome_json_file.close();

    // Parse tome.json
    const tome_json_content = try tome_json_file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(tome_json_content);

    var tome_metadata = metadata.parseMetadata(allocator, tome_json_content) catch |err| {
        try errors.append(allocator, .{
            .file_path = try allocator.dupe(u8, tome_json_path),
            .line = null,
            .message = try std.fmt.allocPrint(allocator, "Failed to parse tome.json: {}", .{err}),
        });
        return ValidationResult{
            .valid = false,
            .errors = try errors.toOwnedSlice(allocator),
        };
    };
    defer tome_metadata.deinit(allocator);

    // Validate required fields
    if (tome_metadata.name.len == 0) {
        try errors.append(allocator, .{
            .file_path = try allocator.dupe(u8, tome_json_path),
            .line = null,
            .message = try allocator.dupe(u8, "tome.json: 'name' field is required"),
        });
    }

    if (tome_metadata.version.len == 0) {
        try errors.append(allocator, .{
            .file_path = try allocator.dupe(u8, tome_json_path),
            .line = null,
            .message = try allocator.dupe(u8, "tome.json: 'version' field is required"),
        });
    }

    // Check for neuronas directory
    const neuronas_path = try std.fs.path.join(allocator, &.{ tome_path, "neuronas" });
    defer allocator.free(neuronas_path);

    var neuronas_dir = std.fs.cwd().openDir(neuronas_path, .{ .iterate = true }) catch |err| {
        try errors.append(allocator, .{
            .file_path = try allocator.dupe(u8, neuronas_path),
            .line = null,
            .message = try std.fmt.allocPrint(allocator, "Failed to open neuronas directory: {}", .{err}),
        });
        return ValidationResult{
            .valid = false,
            .errors = try errors.toOwnedSlice(allocator),
        };
    };
    defer neuronas_dir.close();

    // Validate each neurona file
    var neurona_ids = std.StringHashMap(void).init(allocator);
    defer neurona_ids.deinit();

    var walker = try neuronas_dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind != .file) continue;
        if (!std.mem.endsWith(u8, entry.path, ".md")) continue;

        // Security check: Validate path
        security.validator.validatePath(entry.path) catch |err| {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, entry.path),
                .line = null,
                .message = try std.fmt.allocPrint(allocator, "Security violation in path: {}", .{err}),
            });
            continue;
        };

        const full_path = try std.fs.path.join(allocator, &.{ neuronas_path, entry.path });
        defer allocator.free(full_path);

        // Read and parse neurona
        const file = try neuronas_dir.openFile(entry.path, .{});
        defer file.close();

        const content = try file.readToEndAlloc(allocator, 1024 * 1024);
        defer allocator.free(content);

        var neurona = parser.parse(allocator, content) catch |err| {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, full_path),
                .line = null,
                .message = try std.fmt.allocPrint(allocator, "Failed to parse neurona: {}", .{err}),
            });
            continue;
        };

        // Security check: Validate code snippets in content
        security.validator.validateSnippet(content) catch |err| {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, full_path),
                .line = null,
                .message = try std.fmt.allocPrint(allocator, "Security violation in content: {}", .{err}),
            });
        };

        // Check for duplicate IDs
        if (neurona_ids.contains(neurona.id)) {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, full_path),
                .line = null,
                .message = try std.fmt.allocPrint(allocator, "Duplicate neurona ID: {s}", .{neurona.id}),
            });
        } else {
            try neurona_ids.put(try allocator.dupe(u8, neurona.id), {});
        }

        // Validate required fields
        if (neurona.id.len == 0) {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, full_path),
                .line = null,
                .message = try allocator.dupe(u8, "Missing required field: id"),
            });
        }

        if (neurona.title.len == 0) {
            try errors.append(allocator, .{
                .file_path = try allocator.dupe(u8, full_path),
                .line = null,
                .message = try allocator.dupe(u8, "Missing required field: title"),
            });
        }

        neurona.deinit(allocator);
    }

    // Validate synapses (check for broken links)
    var walker2 = try neuronas_dir.walk(allocator);
    defer walker2.deinit();

    while (try walker2.next()) |entry| {
        if (entry.kind != .file) continue;
        if (!std.mem.endsWith(u8, entry.path, ".md")) continue;

        const full_path = try std.fs.path.join(allocator, &.{ neuronas_path, entry.path });
        defer allocator.free(full_path);

        const file = try neuronas_dir.openFile(entry.path, .{});
        defer file.close();

        const content = try file.readToEndAlloc(allocator, 1024 * 1024);
        defer allocator.free(content);

        var neurona = parser.parse(allocator, content) catch continue;

        // Check prerequisites
        for (neurona.prerequisites) |synapse| {
            if (!neurona_ids.contains(synapse.id)) {
                try errors.append(allocator, .{
                    .file_path = try allocator.dupe(u8, full_path),
                    .line = null,
                    .message = try std.fmt.allocPrint(allocator, "Broken synapse (prerequisite): {s}", .{synapse.id}),
                });
            }
        }

        // Check related
        for (neurona.related) |synapse| {
            if (!neurona_ids.contains(synapse.id)) {
                try errors.append(allocator, .{
                    .file_path = try allocator.dupe(u8, full_path),
                    .line = null,
                    .message = try std.fmt.allocPrint(allocator, "Broken synapse (related): {s}", .{synapse.id}),
                });
            }
        }

        // Check next_topics
        for (neurona.next_topics) |synapse| {
            if (!neurona_ids.contains(synapse.id)) {
                try errors.append(allocator, .{
                    .file_path = try allocator.dupe(u8, full_path),
                    .line = null,
                    .message = try std.fmt.allocPrint(allocator, "Broken synapse (next_topics): {s}", .{synapse.id}),
                });
            }
        }

        neurona.deinit(allocator);
    }

    // Clean up neurona_ids
    var id_iter = neurona_ids.keyIterator();
    while (id_iter.next()) |key| {
        allocator.free(key.*);
    }

    return ValidationResult{
        .valid = errors.items.len == 0,
        .errors = try errors.toOwnedSlice(allocator),
    };
}
