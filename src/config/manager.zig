const std = @import("std");
const builtin = @import("builtin");
const yaml = @import("../tome/yaml.zig");

pub const Config = struct {
    tomes_path: []const u8,
    index_path: []const u8,
    max_neuronas: usize,
    search_timeout_ms: u64,

    pub fn deinit(self: *const Config, allocator: std.mem.Allocator) void {
        allocator.free(self.tomes_path);
        allocator.free(self.index_path);
    }
};

const DEFAULT_CONFIG = struct {
    const TOMES_PATH = "~/.config/syntlas";
    const INDEX_PATH = "~/.config/syntlas/index.db";
    const MAX_NEURONAS = 10000;
    const SEARCH_TIMEOUT_MS = 5000;
};

/// Expand home directory tilde (~) to actual path
fn expandHome(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    if (path.len == 0 or path[0] != '~') return try allocator.dupe(u8, path);

    const home = std.process.getEnvVarOwned(allocator, "HOME") catch |err| switch (err) {
        error.EnvironmentVariableNotFound => blk: {
            if (builtin.os.tag == .windows) {
                break :blk try std.process.getEnvVarOwned(allocator, "USERPROFILE");
            }
            return error.HomeDirectoryNotFound;
        },
        else => |e| return e,
    };
    defer allocator.free(home);

    var expanded = std.ArrayListUnmanaged(u8){};
    defer expanded.deinit(allocator);
    try expanded.appendSlice(allocator, home);
    if (path.len > 1) {
        try expanded.appendSlice(allocator, path[1..]);
    }
    return expanded.toOwnedSlice(allocator);
}

/// Load configuration from file or use defaults
pub fn load(allocator: std.mem.Allocator) !Config {
    // Try to load from config file
    const config_path = try expandHome(allocator, "~/.config/syntlas/config.yaml");
    defer allocator.free(config_path);

    var tomes_path: ?[]const u8 = null;
    var index_path: ?[]const u8 = null;
    var max_neuronas: usize = DEFAULT_CONFIG.MAX_NEURONAS;
    var search_timeout_ms: u64 = DEFAULT_CONFIG.SEARCH_TIMEOUT_MS;

    if (std.fs.cwd().openFile(config_path, .{})) |file| {
        defer file.close();
        const content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
        defer allocator.free(content);

        var parser = yaml.Parser.init(allocator, content);
        var map = try parser.parse();
        defer map.deinit();

        // Parse config values
        if (map.get("tomes_path")) |val| {
            tomes_path = try expandHome(allocator, val);
        } else {
            tomes_path = try expandHome(allocator, DEFAULT_CONFIG.TOMES_PATH);
        }

        if (map.get("index_path")) |val| {
            index_path = try expandHome(allocator, val);
        } else {
            index_path = try expandHome(allocator, DEFAULT_CONFIG.INDEX_PATH);
        }

        if (map.get("max_neuronas")) |val| {
            max_neuronas = try std.fmt.parseInt(usize, val, 10);
        }

        if (map.get("search_timeout_ms")) |val| {
            search_timeout_ms = try std.fmt.parseInt(u64, val, 10);
        }
    } else |err| switch (err) {
        error.FileNotFound => {
            // Use defaults
            tomes_path = try expandHome(allocator, DEFAULT_CONFIG.TOMES_PATH);
            index_path = try expandHome(allocator, DEFAULT_CONFIG.INDEX_PATH);
        },
        else => |e| return e,
    }

    // Override with environment variables if present
    if (std.process.getEnvVarOwned(allocator, "SYNTLAS_TOMES_PATH")) |env_path| {
        if (tomes_path) |old_path| allocator.free(old_path);
        tomes_path = env_path;
    } else |_| {}

    if (std.process.getEnvVarOwned(allocator, "SYNTLAS_INDEX_PATH")) |env_path| {
        if (index_path) |old_path| allocator.free(old_path);
        index_path = env_path;
    } else |_| {}

    if (std.process.getEnvVarOwned(allocator, "SYNTLAS_MAX_NEURONAS")) |env_val| {
        defer allocator.free(env_val);
        max_neuronas = try std.fmt.parseInt(usize, env_val, 10);
    } else |_| {}

    if (std.process.getEnvVarOwned(allocator, "SYNTLAS_SEARCH_TIMEOUT_MS")) |env_val| {
        defer allocator.free(env_val);
        search_timeout_ms = try std.fmt.parseInt(u64, env_val, 10);
    } else |_| {}

    return Config{
        .tomes_path = tomes_path orelse return error.InvalidConfig,
        .index_path = index_path orelse return error.InvalidConfig,
        .max_neuronas = max_neuronas,
        .search_timeout_ms = search_timeout_ms,
    };
}

test "load default config" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = try load(allocator);
    defer config.deinit(allocator);

    try std.testing.expect(config.tomes_path.len > 0);
    try std.testing.expect(config.index_path.len > 0);
    try std.testing.expectEqual(DEFAULT_CONFIG.MAX_NEURONAS, config.max_neuronas);
}

test "expandHome" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const expanded = try expandHome(allocator, "~/test");
    defer allocator.free(expanded);

    try std.testing.expect(expanded.len > 0);
    try std.testing.expect(!std.mem.eql(u8, expanded, "~/test"));
}