const std = @import("std");
const metadata = @import("metadata.zig");
const validator = @import("validator.zig");

pub const InstallSource = union(enum) {
    local_path: []const u8,
    git_url: []const u8,
    tar_gz: []const u8,
    http_url: []const u8,
};

pub const InstallOptions = struct {
    force: bool = false, // Overwrite existing tome
    validate: bool = true, // Validate after installation
};

/// Get the tomes directory path (~/.config/syntlas/tomes/)
pub fn getTomesDir(allocator: std.mem.Allocator) ![]const u8 {
    // Try HOME first (Unix), then USERPROFILE (Windows)
    const home = std.process.getEnvVarOwned(allocator, "HOME") catch |err| blk: {
        if (err == error.EnvironmentVariableNotFound) {
            break :blk std.process.getEnvVarOwned(allocator, "USERPROFILE") catch {
                return error.NoHomeDirectory;
            };
        }
        return err;
    };
    defer allocator.free(home);

    return try std.fs.path.join(allocator, &.{ home, ".config", "syntlas", "tomes" });
}

/// Install a tome from a source
pub fn install(allocator: std.mem.Allocator, source: InstallSource, options: InstallOptions) !void {
    const tomes_dir = try getTomesDir(allocator);
    defer allocator.free(tomes_dir);

    // Ensure tomes directory exists
    std.fs.cwd().makePath(tomes_dir) catch |err| {
        if (err != error.PathAlreadyExists) return err;
    };

    switch (source) {
        .local_path => |path| {
            try installFromLocalPath(allocator, path, tomes_dir, options);
        },
        .git_url => |url| {
            try installFromGit(allocator, url, tomes_dir, options);
        },
        .tar_gz => |path| {
            try installFromTarGz(allocator, path, tomes_dir, options);
        },
        .http_url => |url| {
            try installFromHttp(allocator, url, tomes_dir, options);
        },
    }
}

fn installFromLocalPath(allocator: std.mem.Allocator, source_path: []const u8, tomes_dir: []const u8, options: InstallOptions) !void {
    // Read tome.json to get the tome name
    const tome_json_path = try std.fs.path.join(allocator, &.{ source_path, "tome.json" });
    defer allocator.free(tome_json_path);

    const tome_json_file = try std.fs.cwd().openFile(tome_json_path, .{});
    defer tome_json_file.close();

    const tome_json_content = try tome_json_file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(tome_json_content);

    var tome_metadata = try metadata.parseMetadata(allocator, tome_json_content);
    defer tome_metadata.deinit(allocator);

    const dest_path = try std.fs.path.join(allocator, &.{ tomes_dir, tome_metadata.name });
    defer allocator.free(dest_path);

    // Check if tome already exists
    if (!options.force) {
        const exists = blk: {
            std.fs.cwd().access(dest_path, .{}) catch {
                break :blk false;
            };
            break :blk true;
        };
        if (exists) {
            return error.TomeAlreadyExists;
        }
    }

    // Copy directory recursively
    try copyDir(source_path, dest_path);

    // Validate if requested
    if (options.validate) {
        var result = try validator.validateTome(allocator, dest_path);
        defer result.deinit(allocator);

        if (!result.valid) {
            std.debug.print("Validation errors:\n", .{});
            for (result.errors) |err| {
                std.debug.print("  {s}: {s}\n", .{ err.file_path, err.message });
            }
            return error.ValidationFailed;
        }
    }

    std.debug.print("Installed tome: {s} v{s}\n", .{ tome_metadata.name, tome_metadata.version });
}

fn installFromGit(allocator: std.mem.Allocator, url: []const u8, tomes_dir: []const u8, options: InstallOptions) !void {
    // Create a temporary directory
    const tmp_dir = try std.fs.path.join(allocator, &.{ tomes_dir, ".tmp" });
    defer allocator.free(tmp_dir);

    std.fs.cwd().makePath(tmp_dir) catch |err| {
        if (err != error.PathAlreadyExists) return err;
    };

    // Clone the repository
    const git_args = [_][]const u8{ "git", "clone", "--depth", "1", url, tmp_dir };
    var child = std.process.Child.init(&git_args, allocator);
    const term = try child.spawnAndWait();

    if (term != .Exited or term.Exited != 0) {
        return error.GitCloneFailed;
    }

    // Install from the temporary directory
    try installFromLocalPath(allocator, tmp_dir, tomes_dir, options);

    // Clean up temporary directory
    std.fs.cwd().deleteTree(tmp_dir) catch {};
}

fn installFromTarGz(allocator: std.mem.Allocator, archive_path: []const u8, tomes_dir: []const u8, options: InstallOptions) !void {
    // Create a temporary directory
    const tmp_dir = try std.fs.path.join(allocator, &.{ tomes_dir, ".tmp" });
    defer allocator.free(tmp_dir);

    std.fs.cwd().makePath(tmp_dir) catch |err| {
        if (err != error.PathAlreadyExists) return err;
    };

    // Extract the archive
    const tar_args = [_][]const u8{ "tar", "-xzf", archive_path, "-C", tmp_dir };
    var child = std.process.Child.init(&tar_args, allocator);
    const term = try child.spawnAndWait();

    if (term != .Exited or term.Exited != 0) {
        return error.TarExtractionFailed;
    }

    // Install from the temporary directory
    try installFromLocalPath(allocator, tmp_dir, tomes_dir, options);

    // Clean up temporary directory
    std.fs.cwd().deleteTree(tmp_dir) catch {};
}

fn installFromHttp(allocator: std.mem.Allocator, url: []const u8, tomes_dir: []const u8, options: InstallOptions) !void {
    // Download to temporary file
    const tmp_file = try std.fs.path.join(allocator, &.{ tomes_dir, ".tmp.tar.gz" });
    defer allocator.free(tmp_file);

    // Use curl or wget to download
    const curl_args = [_][]const u8{ "curl", "-L", "-o", tmp_file, url };
    var child = std.process.Child.init(&curl_args, allocator);
    const term = try child.spawnAndWait();

    if (term != .Exited or term.Exited != 0) {
        return error.DownloadFailed;
    }

    // Install from the downloaded archive
    try installFromTarGz(allocator, tmp_file, tomes_dir, options);

    // Clean up temporary file
    std.fs.cwd().deleteFile(tmp_file) catch {};
}

fn copyDir(source: []const u8, dest: []const u8) !void {
    var source_dir = try std.fs.cwd().openDir(source, .{ .iterate = true });
    defer source_dir.close();

    std.fs.cwd().makePath(dest) catch |err| {
        if (err != error.PathAlreadyExists) return err;
    };

    var walker = try source_dir.walk(std.heap.page_allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        const dest_path = try std.fs.path.join(std.heap.page_allocator, &.{ dest, entry.path });
        defer std.heap.page_allocator.free(dest_path);

        switch (entry.kind) {
            .directory => {
                std.fs.cwd().makePath(dest_path) catch |err| {
                    if (err != error.PathAlreadyExists) return err;
                };
            },
            .file => {
                try source_dir.copyFile(entry.path, std.fs.cwd(), dest_path, .{});
            },
            else => {},
        }
    }
}

/// List installed tomes
pub fn listInstalled(allocator: std.mem.Allocator) ![]metadata.TomeMetadata {
    const tomes_dir = try getTomesDir(allocator);
    defer allocator.free(tomes_dir);

    var dir = std.fs.cwd().openDir(tomes_dir, .{ .iterate = true }) catch |err| {
        if (err == error.FileNotFound) {
            return &.{};
        }
        return err;
    };
    defer dir.close();

    var tomes = std.ArrayListUnmanaged(metadata.TomeMetadata){};
    errdefer {
        for (tomes.items) |*tome| tome.deinit(allocator);
        tomes.deinit(allocator);
    }

    var iter = dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .directory) continue;
        if (std.mem.startsWith(u8, entry.name, ".")) continue;

        const tome_json_path = try std.fs.path.join(allocator, &.{ tomes_dir, entry.name, "tome.json" });
        defer allocator.free(tome_json_path);

        const tome_json_file = std.fs.cwd().openFile(tome_json_path, .{}) catch continue;
        defer tome_json_file.close();

        const tome_json_content = try tome_json_file.readToEndAlloc(allocator, 1024 * 1024);
        defer allocator.free(tome_json_content);

        const tome_metadata = metadata.parseMetadata(allocator, tome_json_content) catch continue;
        try tomes.append(allocator, tome_metadata);
    }

    return try tomes.toOwnedSlice(allocator);
}

/// Uninstall a tome
pub fn uninstall(allocator: std.mem.Allocator, tome_name: []const u8) !void {
    const tomes_dir = try getTomesDir(allocator);
    defer allocator.free(tomes_dir);

    const tome_path = try std.fs.path.join(allocator, &.{ tomes_dir, tome_name });
    defer allocator.free(tome_path);

    try std.fs.cwd().deleteTree(tome_path);
    std.debug.print("Uninstalled tome: {s}\n", .{tome_name});
}
