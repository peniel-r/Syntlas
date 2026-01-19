const std = @import("std");

const ColorCode = struct {
    red: u8,
    green: u8,
    blue: u8,
};

pub const Color = enum {
    reset,
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    bright_black,
    bright_red,
    bright_green,
    bright_yellow,
    bright_blue,
    bright_magenta,
    bright_cyan,
    bright_white,
};

pub const Theme = struct {
    name: []const u8,
    title: ColorCode,
    keyword: ColorCode,
    string: ColorCode,
    comment: ColorCode,
    number: ColorCode,
    id: ColorCode,
    score: ColorCode,
    error_color: ColorCode,
    warning: ColorCode,
    success: ColorCode,
    dim: ColorCode,
};

pub const themes = struct {
    pub const monokai = Theme{
        .name = "monokai",
        .title = .{ .red = 249, .green = 240, .blue = 107 }, // Yellow
        .keyword = .{ .red = 253, .green = 151, .blue = 31 }, // Orange
        .string = .{ .red = 190, .green = 183, .blue = 57 }, // Yellow
        .comment = .{ .red = 117, .green = 113, .blue = 94 }, // Gray
        .number = .{ .red = 174, .green = 129, .blue = 255 }, // Purple
        .id = .{ .red = 97, .green = 175, .blue = 239 }, // Cyan
        .score = .{ .red = 253, .green = 151, .blue = 31 }, // Orange
        .error_color = .{ .red = 255, .green = 85, .blue = 85 }, // Red
        .warning = .{ .red = 241, .green = 250, .blue = 140 }, // Yellow
        .success = .{ .red = 80, .green = 250, .blue = 123 }, // Green
        .dim = .{ .red = 100, .green = 100, .blue = 100 }, // Dim gray
    };

    pub const solarized_dark = Theme{
        .name = "solarized-dark",
        .title = .{ .red = 181, .green = 137, .blue = 0 }, // Yellow
        .keyword = .{ .red = 211, .green = 54, .blue = 130 }, // Magenta
        .string = .{ .red = 42, .green = 161, .blue = 152 }, // Cyan
        .comment = .{ .red = 88, .green = 110, .blue = 117 }, // Base01
        .number = .{ .red = 38, .green = 139, .blue = 210 }, // Blue
        .id = .{ .red = 133, .green = 153, .blue = 0 }, // Green
        .score = .{ .red = 220, .green = 50, .blue = 47 }, // Red
        .error_color = .{ .red = 220, .green = 50, .blue = 47 }, // Red
        .warning = .{ .red = 181, .green = 137, .blue = 0 }, // Yellow
        .success = .{ .red = 133, .green = 153, .blue = 0 }, // Green
        .dim = .{ .red = 88, .green = 110, .blue = 117 }, // Base01
    };

    pub const solarized_light = Theme{
        .name = "solarized-light",
        .title = .{ .red = 133, .green = 153, .blue = 0 }, // Green
        .keyword = .{ .red = 211, .green = 54, .blue = 130 }, // Magenta
        .string = .{ .red = 42, .green = 161, .blue = 152 }, // Cyan
        .comment = .{ .red = 147, .green = 161, .blue = 161 }, // Base1
        .number = .{ .red = 38, .green = 139, .blue = 210 }, // Blue
        .id = .{ .red = 181, .green = 137, .blue = 0 }, // Yellow
        .score = .{ .red = 203, .green = 75, .blue = 22 }, // Orange
        .error_color = .{ .red = 220, .green = 50, .blue = 47 }, // Red
        .warning = .{ .red = 181, .green = 137, .blue = 0 }, // Yellow
        .success = .{ .red = 133, .green = 153, .blue = 0 }, // Green
        .dim = .{ .red = 147, .green = 161, .blue = 161 }, // Base1
    };

    pub const default = monokai;
};

fn colorToAnsi(color: ColorCode) []const u8 {
    // 256-color mode
    const code = 16 + 
        (36 * @divTrunc(color.red, 51)) +
        (6 * @divTrunc(color.green, 51)) +
        @divTrunc(color.blue, 51);
    
    return std.fmt.allocPrint(std.heap.page_allocator, "\x1b[38;5;{d}m", .{code}) catch "\x1b[0m";
}

pub fn getTheme(name: ?[]const u8) Theme {
    if (name) |theme_name| {
        if (std.mem.eql(u8, theme_name, "monokai")) return themes.monokai;
        if (std.mem.eql(u8, theme_name, "solarized-dark")) return themes.solarized_dark;
        if (std.mem.eql(u8, theme_name, "solarized-light")) return themes.solarized_light;
    }
    
    // Check NO_COLOR environment variable
    if (std.process.getEnvVarOwned(std.heap.page_allocator, "NO_COLOR")) |_| {
        return themes.default; // Will be overridden by use_color flag
    } else |_| {}
    
    return themes.default;
}

pub fn reset() []const u8 {
    return "\x1b[0m";
}

pub fn bold() []const u8 {
    return "\x1b[1m";
}

pub fn dim() []const u8 {
    return "\x1b[2m";
}

pub fn italic() []const u8 {
    return "\x1b[3m";
}

pub fn underline() []const u8 {
    return "\x1b[4m";
}

// Color helpers
fn colorize(allocator: std.mem.Allocator, color: ColorCode, text: []const u8, use_color: bool) []const u8 {
    if (!use_color) return text;
    
    const ansi = colorToAnsi(color);
    return std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ansi, text, reset()}) catch text;
}

pub fn colorizeText(allocator: std.mem.Allocator, theme: Theme, color_type: []const u8, text: []const u8, use_color: bool) ![]const u8 {
    if (!use_color) return text;
    
    const color: ColorCode = blk: {
        if (std.mem.eql(u8, color_type, "title")) break :blk theme.title;
        if (std.mem.eql(u8, color_type, "keyword")) break :blk theme.keyword;
        if (std.mem.eql(u8, color_type, "string")) break :blk theme.string;
        if (std.mem.eql(u8, color_type, "comment")) break :blk theme.comment;
        if (std.mem.eql(u8, color_type, "number")) break :blk theme.number;
        if (std.mem.eql(u8, color_type, "id")) break :blk theme.id;
        if (std.mem.eql(u8, color_type, "score")) break :blk theme.score;
        if (std.mem.eql(u8, color_type, "error")) break :blk theme.error_color;
        if (std.mem.eql(u8, color_type, "warning")) break :blk theme.warning;
        if (std.mem.eql(u8, color_type, "success")) break :blk theme.success;
        if (std.mem.eql(u8, color_type, "dim")) break :blk theme.dim;
        break :blk theme.title;
    };
    
    return colorize(allocator, color, text, use_color);
}