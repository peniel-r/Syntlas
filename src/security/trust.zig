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

pub fn getPolicy(level: TrustLevel, override: ?[]const u8) Policy {
    // If trust override is provided, try to parse it as a trust level
    if (override) |override_str| {
        // Case-insensitive comparison for override
        if (std.ascii.eqlIgnoreCase(override_str, "untrusted")) {
            return getPolicyFromString(.untrusted);
        }
        if (std.ascii.eqlIgnoreCase(override_str, "community")) {
            return getPolicyFromString(.community);
        }
        if (std.ascii.eqlIgnoreCase(override_str, "official")) {
            return getPolicyFromString(.official);
        }
        if (std.ascii.eqlIgnoreCase(override_str, "embedded")) {
            return getPolicyFromString(.embedded);
        }

        // If override is invalid, log warning but continue with original level
        std.debug.print("⚠ Warning: Invalid trust override '{s}', using original level.\n", .{override_str});
    }

    return getPolicyFromString(level);
}

fn getPolicyFromString(level: TrustLevel) Policy {
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
