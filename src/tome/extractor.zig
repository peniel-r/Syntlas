const std = @import("std");

pub const CodeBlock = struct {
    language: []const u8,
    content: []const u8,
    start_line: usize,
    end_line: usize,
};

pub const Heading = struct {
    level: u8,
    text: []const u8,
    line: usize,
};

/// Extract Markdown body content after frontmatter
pub fn extractBody(content: []const u8, offset: usize) []const u8 {
    if (offset >= content.len) return "";
    return std.mem.trimLeft(u8, content[offset..], "\r\n");
}

/// Extract all code blocks from Markdown content
pub fn extractCodeBlocks(allocator: std.mem.Allocator, content: []const u8) ![]CodeBlock {
    var blocks = std.ArrayListUnmanaged(CodeBlock){};
    errdefer blocks.deinit(allocator);

    var line_it = std.mem.tokenizeScalar(u8, content, '\n');
    var current_block: ?CodeBlock = null;
    var block_content = std.ArrayListUnmanaged(u8){};
    var line_num: usize = 1;

    while (line_it.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \t\r");

        if (current_block == null) {
            if (std.mem.startsWith(u8, trimmed, "```")) {
                var language: []const u8 = "";
                if (trimmed.len > 3) {
                    language = trimmed[3..];
                }
                current_block = CodeBlock{
                    .language = try allocator.dupe(u8, language),
                    .content = "",
                    .start_line = line_num,
                    .end_line = 0,
                };
                block_content = std.ArrayListUnmanaged(u8){};
            }
        } else {
            if (std.mem.eql(u8, trimmed, "```")) {
                var block = current_block.?;
                block.content = try block_content.toOwnedSlice(allocator);
                block.end_line = line_num;
                try blocks.append(allocator, block);
                current_block = null;
            } else {
                if (block_content.items.len > 0) {
                    try block_content.appendSlice(allocator, "\n");
                }
                try block_content.appendSlice(allocator, line);
            }
        }

        line_num += 1;
    }

    return try blocks.toOwnedSlice(allocator);
}

/// Extract all headings from Markdown content
pub fn extractHeadings(allocator: std.mem.Allocator, content: []const u8) ![]Heading {
    var headings = std.ArrayListUnmanaged(Heading){};
    errdefer headings.deinit(allocator);

    var line_it = std.mem.tokenizeScalar(u8, content, '\n');
    var line_num: usize = 1;

    while (line_it.next()) |line| {
        const trimmed = std.mem.trimLeft(u8, line, " \t");

        if (trimmed.len > 0 and trimmed[0] == '#') {
            var level: u8 = 0;
            var i: usize = 0;
            while (i < trimmed.len and trimmed[i] == '#') : (i += 1) {
                level += 1;
            }

            if (level > 0 and level <= 6 and i < trimmed.len) {
                const text = std.mem.trim(u8, trimmed[i..], " \t\r");
                try headings.append(allocator, .{
                    .level = level,
                    .text = try allocator.dupe(u8, text),
                    .line = line_num,
                });
            }
        }

        line_num += 1;
    }

    return try headings.toOwnedSlice(allocator);
}