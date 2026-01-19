const std = @import("std");
const mod = @import("mod.zig");

const Command = mod.Command;
const CliConfig = mod.CliConfig;

pub const HelpEntry = struct {
    name: []const u8,
    short_desc: []const u8,
    long_desc: []const u8,
    usage: []const u8,
    examples: []const []const u8,
};

pub const help_data = struct {
    pub const general = HelpEntry{
        .name = "syntlas",
        .short_desc = "The Neurona System - Neural Documentation Navigator",
        .long_desc = 
        \\Syntlas is a revolutionary documentation navigator that treats knowledge as a neural network,
        \\enabling lightning-fast search and intelligent navigation through programming language documentation.
        \\
        \\Search neuronas by keywords, difficulty, tags, or use semantic matching. Explore connections
        \\through synapses (prerequisites, related topics, next topics).
        ,
        .usage = "syntlas <command> [options]",
        .examples = &[_][]const u8{
            "syntlas search async python",
            "syntlas docs c.pointers.01-basics",
            "syntlas list --tomes",
        },
    };
    
    pub const search = HelpEntry{
        .name = "search",
        .short_desc = "Search for neuronas by query",
        .long_desc = 
        \\Performs a neural search across all installed tomes. Uses a 5-stage pipeline:
        \\1. Text matching (inverted index)
        \\2. Semantic matching (use cases)
        \\3. Context filtering (difficulty, tags)
        \\4. Graph expansion (synapses)
        \\5. Ranking (relevance scoring)
        \\
        \\Supports fuzzy matching and returns results sorted by relevance score.
        ,
        .usage = "syntlas search <query> [options]",
        .examples = &[_][]const u8{
            "syntlas search async python",
            "syntlas search \"memory management\" --difficulty intermediate",
            "syntlas search pointers --limit 5",
        },
    };
    
    pub const docs = HelpEntry{
        .name = "docs",
        .short_desc = "View full neurona documentation",
        .long_desc = 
        \\Displays complete neurona content including:
        \\- Title and metadata (difficulty, category)
        \\- Tags and keywords
        \\- Synapse connections (prerequisites, related, next topics)
        \\- Full content with syntax highlighting
        ,
        .usage = "syntlas docs <neurona-id>",
        .examples = &[_][]const u8{
            "syntlas docs c.pointers.01-basics",
            "syntlas docs py.async.aiohttp.client",
        },
    };
    
    pub const snippet = HelpEntry{
        .name = "snippet",
        .short_desc = "Extract code snippets from a neurona",
        .long_desc = 
        \\Extracts and displays code blocks from a neurona with syntax highlighting.
        \\Useful for quickly viewing examples without reading full documentation.
        ,
        .usage = "syntlas snippet <neurona-id>",
        .examples = &[_][]const u8{
            "syntlas snippet c.pointers.01-basics",
            "syntlas snippet py.async.aiohttp.client",
        },
    };
    
    pub const install = HelpEntry{
        .name = "install",
        .short_desc = "Install a tome from source",
        .long_desc = 
        \\Installs a tome from various sources:
        \\- Local directory path
        \\- HTTP/HTTPS URL (downloads tar.gz)
        \\- Git repository (clone and extract)
        \\
        \\Automatically validates spec compliance and security before installation.
        ,
        .usage = "syntlas install <source>",
        .examples = &[_][]const u8{
            "syntlas install ./my-tome",
            "syntlas install https://example.com/tome.tar.gz",
            "syntlas install https://github.com/user/syntlas-tome",
        },
    };
    
    pub const list = HelpEntry{
        .name = "list",
        .short_desc = "List installed tomes or neuronas",
        .long_desc = 
        \\Lists installed tomes or neuronas within a tome. Use --tomes to see all
        \\installed tomes, or provide a tome name to list its neuronas.
        ,
        .usage = "syntlas list [options]",
        .examples = &[_][]const u8{
            "syntlas list --tomes",
            "syntlas list python",
            "syntlas list --tome rust",
        },
    };
    
    pub const create_tome = HelpEntry{
        .name = "create-tome",
        .short_desc = "Create a new tome structure",
        .long_desc = 
        \\Creates a new tome directory with the required structure:
        \\- tome.json (metadata)
        \\- neuronas/ (directory for neurona files)
        \\- assets/ (optional: images, diagrams)
        ,
        .usage = "syntlas create-tome <name> [path]",
        .examples = &[_][]const u8{
            "syntlas create-tome my-lang",
            "syntlas create-tome framework-x ./tomes",
        },
    };
    
    pub const validate_tome = HelpEntry{
        .name = "validate-tome",
        .short_desc = "Validate a tome against spec",
        .long_desc = 
        \\Validates a tome against the Neurona specification:
        \\- Checks tome.json structure
        \\- Validates all neurona files
        \\- Verifies synapse connections
        \\- Checks spec compliance
        ,
        .usage = "syntlas validate-tome <path>",
        .examples = &[_][]const u8{
            "syntlas validate-tome ./my-tome",
            "syntlas validate-tome ./tomes/python",
        },
    };
};

pub fn printGeneralHelp(_: std.mem.Allocator, config: CliConfig) !void {
    const title = if (config.color_output) "\x1b[1;33m" else "";
    const reset = if (config.color_output) "\x1b[0m" else "";
    
    std.debug.print("\n{s}{s}{s}\n\n", .{ title, help_data.general.name, reset });
    std.debug.print("{s}\n\n", .{help_data.general.short_desc});
    
    std.debug.print("USAGE:\n  {s}\n\n", .{help_data.general.usage});
    
    std.debug.print("COMMANDS:\n", .{});
    try printCommandList();
    
    std.debug.print("\nGLOBAL OPTIONS:\n", .{});
    try printGlobalOptions();
    
    std.debug.print("\nEXAMPLES:\n", .{});
    for (help_data.general.examples) |example| {
        std.debug.print("  {s}\n", .{example});
    }
    
    std.debug.print("\nUse 'syntlas help <command>' for more information on a specific command.\n", .{});
}

pub fn printCommandHelp(_: std.mem.Allocator, command: Command, config: CliConfig) !void {
    const title = if (config.color_output) "\x1b[1;33m" else "";
    const reset = if (config.color_output) "\x1b[0m" else "";
    
    const help_entry = getHelpEntry(command);
    
    std.debug.print("\n{s}syntlas {s}{s}\n\n", .{ title, @tagName(command), reset });
    std.debug.print("{s}\n\n", .{help_entry.short_desc});
    
    std.debug.print("USAGE:\n  {s}\n\n", .{help_entry.usage});
    
    std.debug.print("DESCRIPTION:\n", .{});
    var lines = std.mem.splitScalar(u8, help_entry.long_desc, '\n');
    while (lines.next()) |line| {
        std.debug.print("  {s}\n", .{line});
    }
    std.debug.print("\n", .{});
    
    std.debug.print("EXAMPLES:\n", .{});
    for (help_entry.examples) |example| {
        std.debug.print("  {s}\n", .{example});
    }
    
    std.debug.print("\n", .{});
}

pub fn printCommandList() !void {
    const commands = &[_]struct { name: []const u8, desc: []const u8 }{
        .{ .name = "search", .desc = "Search for neuronas" },
        .{ .name = "docs", .desc = "View neurona documentation" },
        .{ .name = "snippet", .desc = "Extract code snippets" },
        .{ .name = "install", .desc = "Install a tome" },
        .{ .name = "list", .desc = "List tomes/neuronas" },
        .{ .name = "create-tome", .desc = "Create a new tome" },
        .{ .name = "validate-tome", .desc = "Validate a tome" },
        .{ .name = "help", .desc = "Show help information" },
    };
    
    for (commands) |cmd| {
        std.debug.print("  {s: <14}  {s}\n", .{ cmd.name, cmd.desc });
    }
}

pub fn printGlobalOptions() !void {
    const options = &[_]struct { name: []const u8, desc: []const u8 }{
        .{ .name = "--json", .desc = "Output in JSON format" },
        .{ .name = "--color, --no-color", .desc = "Enable/disable color output" },
        .{ .name = "--theme <name>", .desc = "Set color theme (monokai, solarized-dark, solarized-light)" },
        .{ .name = "--debug", .desc = "Enable debug output" },
        .{ .name = "--yes, -y", .desc = "Skip confirmation prompts" },
        .{ .name = "--help, -h", .desc = "Show help information" },
    };
    
    for (options) |opt| {
        std.debug.print("  {s: <25}  {s}\n", .{ opt.name, opt.desc });
    }
}

fn getHelpEntry(command: Command) HelpEntry {
    return switch (command) {
        .search => help_data.search,
        .docs => help_data.docs,
        .snippet => help_data.snippet,
        .install => help_data.install,
        .list => help_data.list,
        .@"create-tome" => help_data.create_tome,
        .@"validate-tome" => help_data.validate_tome,
        .help => help_data.general,
    };
}