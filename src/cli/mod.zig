const std = @import("std");

pub const parser = @import("parser.zig");
pub const commands = @import("commands.zig");

// CLI configuration and state
pub const CliConfig = struct {
    json_output: bool = false,
    color_output: bool = true,
    debug_mode: bool = false,
    yes_mode: bool = false, // Skip confirmation prompts
    theme: ?[]const u8 = null,
};

pub const Command = enum {
    search,
    docs,
    snippet,
    install,
    list,
    @"create-tome",
    @"validate-tome",
    help,
};

pub const CommandArgs = union(Command) {
    search: SearchArgs,
    docs: DocsArgs,
    snippet: SnippetArgs,
    install: InstallArgs,
    list: ListArgs,
    @"create-tome": CreateTomeArgs,
    @"validate-tome": ValidateTomeArgs,
    help: HelpArgs,
};

pub const SearchArgs = struct {
    query: []const u8,
    difficulty: ?[]const u8 = null,
    tags: ?[]const []const u8 = null,
    limit: usize = 10,
};

pub const DocsArgs = struct {
    neurona_id: []const u8,
};

pub const SnippetArgs = struct {
    neurona_id: []const u8,
};

pub const InstallArgs = struct {
    source: []const u8,
};

pub const ListArgs = struct {
    tomes: bool = false,
    neuronas: bool = false,
    tome_name: ?[]const u8 = null,
};

pub const CreateTomeArgs = struct {
    name: []const u8,
    path: ?[]const u8 = null,
};

pub const ValidateTomeArgs = struct {
    path: []const u8,
};

pub const HelpArgs = struct {
    command: ?[]const u8 = null,
};