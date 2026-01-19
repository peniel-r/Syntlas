const std = @import("std");
const search = @import("../search/mod.zig");
const schema = @import("../core/schema.zig");
const themes = @import("themes.zig");
const OutputConfig = @import("mod.zig").OutputConfig;

const ActivationSummary = schema.ActivationSummary;

pub fn formatSearchResults(allocator: std.mem.Allocator, results: []const ActivationSummary, query: []const u8, query_time_ms: f64, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const title = try themes.colorizeText(allocator, theme, "title", query, config.use_color);
    defer allocator.free(title);
    
    try writer.print("Search results for: {s}\n", .{title});
    try writer.print("Time: {d:.2}ms | Results: {d}\n\n", .{ query_time_ms, results.len });
    
    for (results, 0..) |result, i| {
        const id_colored = try themes.colorizeText(allocator, theme, "id", result.id, config.use_color);
        defer allocator.free(id_colored);
        
        const title_colored = try themes.colorizeText(allocator, theme, "title", "Neurona", config.use_color);
        defer allocator.free(title_colored);
        
        const score_str = try std.fmt.allocPrint(allocator, "{d:.4}", .{result.score});
        defer allocator.free(score_str);
        const score_colored = try themes.colorizeText(allocator, theme, "score", score_str, config.use_color);
        defer allocator.free(score_colored);
        
        const diff_str = "unknown";
        const cat_str = "unknown";
        
        try writer.print("{d}. {s}\n", .{ i + 1, id_colored });
        try writer.print("   {s}\n", .{title_colored});
        try writer.print("   Score: {s} | Difficulty: {s} | Category: {s}\n", .{ score_colored, diff_str, cat_str });
        
        // Snippet if available
        if (result.snippet) |snippet| {
            try writer.print("   {s}\n", .{snippet});
        }
        
        try writer.writeByte('\n');
    }
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatNeurona(allocator: std.mem.Allocator, neurona: *const schema.Neurona, content: []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const id_colored = try themes.colorizeText(allocator, theme, "id", neurona.id, config.use_color);
    defer allocator.free(id_colored);
    
    const title_colored = try themes.colorizeText(allocator, theme, "title", neurona.title, config.use_color);
    defer allocator.free(title_colored);
    
    try writer.print("{s}\n", .{id_colored});
    try writer.print("{s}\n\n", .{title_colored});
    
    // Metadata
    const diff_str = difficultyToString(neurona.difficulty);
    const cat_str = categoryToString(neurona.category);
    try writer.print("Difficulty: {s} | Category: {s}\n\n", .{ diff_str, cat_str });
    
    // Tags
    if (neurona.tags.len > 0) {
        try writer.writeAll("Tags: ");
        for (neurona.tags, 0..) |tag, j| {
            const tag_colored = try themes.colorizeText(allocator, theme, "keyword", tag, config.use_color);
            defer allocator.free(tag_colored);
            try writer.print("{s}", .{tag_colored});
            if (j < neurona.tags.len - 1) try writer.writeAll(", ");
        }
        try writer.writeByte('\n');
    }
    
    // Keywords
    if (neurona.keywords.len > 0) {
        try writer.writeAll("\nKeywords: ");
        for (neurona.keywords, 0..) |kw, j| {
            const kw_colored = try themes.colorizeText(allocator, theme, "keyword", kw, config.use_color);
            defer allocator.free(kw_colored);
            try writer.print("{s}", .{kw_colored});
            if (j < neurona.keywords.len - 1) try writer.writeAll(", ");
        }
        try writer.writeByte('\n');
    }
    
    // Synapses
    if (neurona.prerequisites.len > 0) {
        try writer.writeAll("\nPrerequisites:\n");
        for (neurona.prerequisites) |synapse| {
            const syn_colored = try themes.colorizeText(allocator, theme, "id", synapse.id, config.use_color);
            defer allocator.free(syn_colored);
            try writer.print("  - {s}", .{syn_colored});
            if (synapse.optional) try writer.writeAll(" (optional)");
            try writer.writeByte('\n');
        }
    }
    
    if (neurona.related.len > 0) {
        try writer.writeAll("\nRelated:\n");
        for (neurona.related) |synapse| {
            const syn_colored = try themes.colorizeText(allocator, theme, "id", synapse.id, config.use_color);
            defer allocator.free(syn_colored);
            try writer.print("  - {s}\n", .{syn_colored});
        }
    }
    
    if (neurona.next_topics.len > 0) {
        try writer.writeAll("\nNext Topics:\n");
        for (neurona.next_topics) |synapse| {
            const syn_colored = try themes.colorizeText(allocator, theme, "id", synapse.id, config.use_color);
            defer allocator.free(syn_colored);
            try writer.print("  - {s}\n", .{syn_colored});
        }
    }
    
    // Content with syntax highlighting
    try writer.writeAll("\n" ++ "---" ++ "\n\n");
    try formatContent(writer, allocator, content, config);
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatSnippet(allocator: std.mem.Allocator, neurona: *const schema.Neurona, content: []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const id_colored = try themes.colorizeText(allocator, theme, "id", neurona.id, config.use_color);
    defer allocator.free(id_colored);
    
    try writer.print("{s}\n\n", .{id_colored});
    
    // Extract and format code blocks
    var lines = std.mem.splitScalar(u8, content, '\n');
    var in_code_block = false;
    var code_block_lang: []const u8 = "";
    
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "```")) {
            if (!in_code_block) {
                in_code_block = true;
                code_block_lang = line[3..];
                // Trim whitespace
                while (code_block_lang.len > 0 and std.ascii.isWhitespace(code_block_lang[0])) {
                    code_block_lang = code_block_lang[1..];
                }
                try writer.writeAll("```");
                if (code_block_lang.len > 0) {
                    const lang_colored = try themes.colorizeText(allocator, theme, "keyword", code_block_lang, config.use_color);
                    defer allocator.free(lang_colored);
                    try writer.print("{s}\n", .{lang_colored});
                } else {
                    try writer.writeByte('\n');
                }
            } else {
                in_code_block = false;
                try writer.writeAll("```\n\n");
            }
        } else if (in_code_block) {
            try formatCodeLine(writer, allocator, line, config);
        } else if (!std.mem.startsWith(u8, line, "#") and line.len > 0) {
            // Only print non-empty, non-header lines
            try writer.print("{s}\n", .{line});
        }
    }
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatError(allocator: std.mem.Allocator, error_msg: []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const error_text = try themes.colorizeText(allocator, theme, "error", "Error", config.use_color);
    defer allocator.free(error_text);
    
    try writer.print("{s}: {s}\n", .{ error_text, error_msg });
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatSuccess(allocator: std.mem.Allocator, message: []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const success_text = try themes.colorizeText(allocator, theme, "success", "✓", config.use_color);
    defer allocator.free(success_text);
    
    try writer.print("{s} {s}\n", .{ success_text, message });
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatTomeList(allocator: std.mem.Allocator, tomes: []const []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const title_colored = try themes.colorizeText(allocator, theme, "title", "Installed Tomes", config.use_color);
    defer allocator.free(title_colored);
    
    try writer.print("{s} ({d})\n\n", .{ title_colored, tomes.len });
    
    for (tomes, 0..) |tome, i| {
        const tome_colored = try themes.colorizeText(allocator, theme, "id", tome, config.use_color);
        defer allocator.free(tome_colored);
        try writer.print("  {d}. {s}\n", .{ i + 1, tome_colored });
    }
    
    return buffer.toOwnedSlice(allocator);
}

pub fn formatNeuronaList(allocator: std.mem.Allocator, neuronas: []const []const u8, tome_name: []const u8, config: OutputConfig) ![]const u8 {
    var buffer = std.ArrayListUnmanaged(u8){};
    defer buffer.deinit(allocator);
    const writer = buffer.writer(allocator);
    const theme = themes.getTheme(config.theme);
    
    const title_str = try std.fmt.allocPrint(allocator, "Neuronas in '{s}'", .{tome_name});
    defer allocator.free(title_str);
    const title_colored = try themes.colorizeText(allocator, theme, "title", title_str, config.use_color);
    defer allocator.free(title_colored);
    
    try writer.print("{s} ({d})\n\n", .{ title_colored, neuronas.len });
    
    for (neuronas, 0..) |neurona, i| {
        const neurona_colored = try themes.colorizeText(allocator, theme, "id", neurona, config.use_color);
        defer allocator.free(neurona_colored);
        try writer.print("  {d}. {s}\n", .{ i + 1, neurona_colored });
    }
    
    return buffer.toOwnedSlice(allocator);
}

fn formatContent(writer: anytype, allocator: std.mem.Allocator, content: []const u8, config: OutputConfig) !void {
    var lines = std.mem.splitScalar(u8, content, '\n');
    var in_code_block = false;
    
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "```")) {
            in_code_block = !in_code_block;
            try writer.writeAll(line);
            try writer.writeByte('\n');
        } else if (in_code_block) {
            try formatCodeLine(writer, allocator, line, config);
        } else {
            try writer.writeAll(line);
            try writer.writeByte('\n');
        }
    }
}

fn formatCodeLine(writer: anytype, allocator: std.mem.Allocator, line: []const u8, config: OutputConfig) !void {
    if (!config.use_color) {
        try writer.writeAll(line);
        try writer.writeByte('\n');
        return;
    }
    
    const theme = themes.getTheme(config.theme);
    
    // Simple syntax highlighting for common patterns
    var i: usize = 0;
    while (i < line.len) {
        // Skip whitespace
        while (i < line.len and std.ascii.isWhitespace(line[i])) {
            try writer.writeByte(line[i]);
            i += 1;
        }
        
        if (i >= line.len) break;
        
        // Check for comments
        if (i + 1 < line.len and line[i] == '/' and (line[i + 1] == '/' or line[i + 1] == '*')) {
            const comment_colored = try themes.colorizeText(allocator, theme, "comment", line[i..], true);
            try writer.writeAll(comment_colored);
            break;
        }
        
        // Check for strings
        if (line[i] == '"' or line[i] == '\'') {
            const quote = line[i];
            try writer.writeByte(quote);
            i += 1;
            while (i < line.len and line[i] != quote) {
                if (line[i] == '\\' and i + 1 < line.len) {
                    try writer.writeByte(line[i]);
                    i += 1;
                }
                try writer.writeByte(line[i]);
                i += 1;
            }
            if (i < line.len) {
                try writer.writeByte(quote);
                i += 1;
            }
            continue;
        }
        
        // Check for keywords
        const keywords = [_][]const u8{ "fn", "func", "function", "const", "var", "let", "if", "else", "for", "while", "return", "import", "export", "struct", "enum", "class", "def", "public", "private", "async", "await", "try", "catch" };
        
        var keyword_found = false;
        for (keywords) |kw| {
            if (std.mem.startsWith(u8, line[i..], kw)) {
                const next_char = if (i + kw.len < line.len) line[i + kw.len] else ' ';
                if (!std.ascii.isAlphanumeric(next_char) and next_char != '_') {
                    const kw_colored = try themes.colorizeText(allocator, theme, "keyword", kw, true);
                    try writer.writeAll(kw_colored);
                    i += kw.len;
                    keyword_found = true;
                    break;
                }
            }
        }
        
        if (!keyword_found) {
            try writer.writeByte(line[i]);
            i += 1;
        }
    }
    
    try writer.writeByte('\n');
}

fn difficultyToString(diff: schema.Difficulty) []const u8 {
    return switch (diff) {
        .novice => "novice",
        .intermediate => "intermediate",
        .advanced => "advanced",
        .expert => "expert",
        .unknown => "unknown",
    };
}

fn categoryToString(cat: schema.Category) []const u8 {
    return switch (cat) {
        .language => "language",
        .library => "library",
        .framework => "framework",
        .concept => "concept",
        .pattern => "pattern",
        .snippet => "snippet",
        .unknown => "unknown",
    };
}