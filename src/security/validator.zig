const std = @import("std");
const mod = @import("mod.zig");

/// Validates a path for security issues like traversal or absolute paths.
pub fn validatePath(path: []const u8) mod.SecurityError!void {
    if (path.len == 0) return;

    // Normalize path separators
    var buf: [std.fs.max_path_bytes]u8 = undefined;
    const normalized = std.mem.replace(u8, path, "\\", "/", &buf);
    _ = normalized; // Use buf[0..n] if needed, but for now we just check the output of sub-parts

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

    // Validate file extensions (if present)
    const ext = std.fs.path.extension(path);
    if (ext.len > 0) {
        const allowed_exts = [_][]const u8{ ".md", ".json", ".png", ".jpg", ".jpeg", ".svg", ".yaml", ".yml", ".tome" };
        var allowed = false;
        for (allowed_exts) |allowed_ext| {
            if (std.mem.eql(u8, ext, allowed_ext)) {
                allowed = true;
                break;
            }
        }
        if (!allowed) return error.InvalidFileExtension;
    }
}

/// Checks if a code snippet contains dangerous patterns.
pub fn validateSnippet(snippet: []const u8) mod.SecurityError!void {
    const dangerous_patterns = [_][]const u8{
        "rm -rf /",
        "format C:",
        "shred /dev/",
        ":(){ :|:& };:", // Fork bomb
        "mkfs.",
        "dd if=/dev/",
    };

    for (dangerous_patterns) |pattern| {
        if (std.mem.indexOf(u8, snippet, pattern)) |_| {
            return error.DangerousPatternDetected;
        }
    }
}

/// Checks if a command is blocked.
pub fn isCommandBlocked(command: []const u8, custom_blocklist: []const []const u8, allow_network: bool) bool {
    const builtin_blocklist = [_][]const u8{
        "rm",     "del",    "erase",
        "mkfs",   "format", "shred",
        "wget",   "curl",   "nc",
        "netcat",
    };

    var it = std.mem.tokenizeAny(u8, command, " ");
    const cmd = it.next() orelse return false;

    // Check built-in blocklist
    for (builtin_blocklist) |blocked| {
        if (std.mem.eql(u8, cmd, blocked)) {
            return true;
        }
    }

    // Check custom blocklist from config
    for (custom_blocklist) |blocked| {
        if (std.mem.eql(u8, cmd, blocked)) {
            return true;
        }
    }

    // Check for shell injection characters
    const injection_chars = [_]u8{ ';', '&', '|', '`', '$', '>', '<' };
    for (injection_chars) |char| {
        if (std.mem.indexOfScalar(u8, command, char)) |_| {
            return true;
        }
    }

    // Check network commands if network is not allowed
    if (!allow_network) {
        const network_commands = [_][]const u8{ "wget", "curl", "nc", "netcat", "ping", "telnet" };
        for (network_commands) |net_cmd| {
            if (std.mem.eql(u8, cmd, net_cmd)) {
                return true;
            }
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

/// Display verification status for SHA-256 checksum.
pub fn displayChecksumStatus(verified: bool, file_path: []const u8) void {
    if (verified) {
        std.debug.print("✓ SHA-256 checksum verified: {s}\n", .{file_path});
    } else {
        std.debug.print("✗ SHA-256 checksum mismatch: {s}\n", .{file_path});
    }
}

/// Warn about unsigned tomes.
pub fn warnUnsignedTome(tome_name: []const u8) void {
    std.debug.print("⚠ Warning: Tome '{s}' is not digitally signed.\n", .{tome_name});
    std.debug.print("  Unsigned tomes may have been modified or contain malicious content.\n", .{});
    std.debug.print("  Only install tomes from trusted sources.\n", .{});
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
    // Test built-in blocklist
    try std.testing.expect(isCommandBlocked("rm -rf /", &.{}, true));
    try std.testing.expect(!isCommandBlocked("ls -l", &.{}, true));

    // Test custom blocklist
    try std.testing.expect(isCommandBlocked("dangerous-cmd", &.{"dangerous-cmd"}, true));

    // Test network blocking
    try std.testing.expect(isCommandBlocked("curl http://example.com", &.{}, false));
    try std.testing.expect(isCommandBlocked("wget http://example.com", &.{}, true));
    try std.testing.expect(!isCommandBlocked("ls -l", &.{}, false));
}
