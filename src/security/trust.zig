const std = @import("std");

pub const TrustLevel = enum {
    untrusted,
    community,
    official,
    embedded,

    pub fn isAtLeast(self: TrustLevel, other: TrustLevel) bool {
        return @intFromEnum(self) >= @intFromEnum(other);
    }
};

pub const Policy = struct {
    name: []const u8,
    allow_commands: bool,
    require_confirmation: bool,
    allow_network: bool,
    require_sandbox: bool,
};

pub fn getPolicy(level: TrustLevel) Policy {
    return switch (level) {
        .untrusted => .{
            .name = "untrusted",
            .allow_commands = false,
            .require_confirmation = true,
            .allow_network = false,
            .require_sandbox = true,
        },
        .community => .{
            .name = "community",
            .allow_commands = true,
            .require_confirmation = true,
            .allow_network = false,
            .require_sandbox = true,
        },
        .official => .{
            .name = "official",
            .allow_commands = true,
            .require_confirmation = true,
            .allow_network = true,
            .require_sandbox = true,
        },
        .embedded => .{
            .name = "embedded",
            .allow_commands = true,
            .require_confirmation = false,
            .allow_network = true,
            .require_sandbox = false,
        },
    };
}
