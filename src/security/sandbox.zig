const std = @import("std");

pub const SandboxOptions = struct {
    allow_network: bool = false,
    read_only: bool = true,
};

pub fn runInSandbox(allocator: std.mem.Allocator, argv: []const []const u8, options: SandboxOptions) !std.process.Child.Term {
    _ = options;
    // For now, this is a pass-through that just spawns the process normally.
    // Platform-specific hardening (seccomp, restricted tokens) will be added here.
    var child = std.process.Child.init(argv, allocator);
    return try child.spawnAndWait();
}
