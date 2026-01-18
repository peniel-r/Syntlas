const std = @import("std");
const mod = @import("mod.zig");

/// Validates a path for security issues like traversal or absolute paths.
pub fn validatePath(path: []const u8) mod.SecurityError!void {
    if (path.len == 0) return;

    // Reject absolute paths
    if (std.fs.path.isAbsolute(path)) {
        return error.AbsolutePathsNotAllowed;
    }

    // Reject path traversal
    var it = std.mem.tokenizeAny(u8, path, "/\\");
    while (it.next()) |component| {
        if (std.mem.eql(u8, component, "..")) {
            return error.PathTraversalDetected;
        }
    }
}

/// Checks if a code snippet contains dangerous patterns.
pub fn validateSnippet(snippet: []const u8) mod.SecurityError!void {
    const dangerous_patterns = [_][]const u8{
        "rm -rf",
        "format C:",
        "shred",
        ":(){ :|:& };:", // Fork bomb
        "mkfs",
        "dd if=",
    };

    for (dangerous_patterns) |pattern| {
        if (std.mem.indexOf(u8, snippet, pattern)) |_| {
            return error.DangerousPatternDetected;
        }
    }
}

/// Checks if a command is blocked.
pub fn isCommandBlocked(command: []const u8) bool {
    const blocklist = [_][]const u8{
        "rm",     "del",    "erase",
        "mkfs",   "format", "shred",
        "wget",   "curl",   "nc",
        "netcat",
    };

    var it = std.mem.tokenizeAny(u8, command, " ");
    const cmd = it.next() orelse return false;

    for (blocklist) |blocked| {
        if (std.mem.eql(u8, cmd, blocked)) {
            return true;
        }
    }

    return false;
}

/// Verifies the SHA-256 checksum of a file.
pub fn verifyChecksum(allocator: std.mem.Allocator, file_path: []const u8, expected_hex: []const u8) !void {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 10 * 1024 * 1024); // 10MB limit
    defer allocator.free(content);

    var hash: [std.crypto.hash.sha2.Sha256.digest_length]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(content, &hash, .{});

    var actual_hex: [hash.len * 2]u8 = undefined;
    _ = std.fmt.bufPrint(&actual_hex, "{s}", .{std.fmt.fmtSliceHexLower(&hash)}) catch unreachable;

    if (!std.mem.eql(u8, &actual_hex, expected_hex)) {
        return error.ChecksumMismatch;
    }
}

test "validatePath" {
    try validatePath("assets/image.png");
    try std.testing.expectError(error.PathTraversalDetected, validatePath("assets/../../etc/passwd"));
    try std.testing.expectError(error.AbsolutePathsNotAllowed, validatePath("/etc/passwd"));
    if (std.builtin.os.tag == .windows) {
        try std.testing.expectError(error.AbsolutePathsNotAllowed, validatePath("C:\\Windows\\System32"));
    }
}

test "validateSnippet" {
    try validateSnippet("echo hello");
    try std.testing.expectError(error.DangerousPatternDetected, validateSnippet("rm -rf /"));
}

test "isCommandBlocked" {
    try std.testing.expect(isCommandBlocked("rm -rf /"));
    try std.testing.expect(!isCommandBlocked("ls -l"));
}
