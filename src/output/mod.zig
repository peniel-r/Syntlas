const std = @import("std");

pub const text = @import("text.zig");
pub const json = @import("json.zig");
pub const themes = @import("themes.zig");

pub const Formatter = enum {
    text,
    json,
};

pub const OutputConfig = struct {
    use_color: bool = true,
    theme: ?[]const u8 = null,
    formatter: Formatter = .text,
    terminal_width: usize = 80,
};