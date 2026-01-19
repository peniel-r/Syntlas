const std = @import("std");
const mod = @import("mod.zig");

const CliConfig = mod.CliConfig;
const Command = mod.Command;
const CommandArgs = mod.CommandArgs;

pub const ParseError = error{
    UnknownCommand,
    MissingArgument,
    InvalidArgument,
    TooManyArguments,
};

pub const ParseResult = struct {
    command: Command,
    args: CommandArgs,
    config: CliConfig,
};

pub fn parse(_: std.mem.Allocator, args: []const []const u8) !ParseResult {
    if (args.len == 0) {
        return ParseResult{
            .command = .help,
            .args = .{ .help = .{} },
            .config = .{},
        };
    }

    var config = CliConfig{};
    var arg_idx: usize = 1; // Skip program name

    // Check for command first
    if (arg_idx >= args.len) {
        return ParseResult{
            .command = .help,
            .args = .{ .help = .{} },
            .config = config,
        };
    }

    const cmd_str = args[arg_idx];
    arg_idx += 1;

    const command = try parseCommand(cmd_str);
    
    var command_args: CommandArgs = undefined;
    
    // Parse command-specific arguments and global flags together
    switch (command) {
        .search => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const query = args[arg_idx];
            arg_idx += 1;
            
            var difficulty: ?[]const u8 = null;
            var limit: usize = 10;
            
            // Parse optional flags and global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                
                // Global flags
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                }
                // Command-specific flags
                else if (std.mem.eql(u8, arg, "--difficulty") or std.mem.eql(u8, arg, "-d")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    difficulty = args[arg_idx + 1];
                    arg_idx += 1;
                } else if (std.mem.eql(u8, arg, "--limit") or std.mem.eql(u8, arg, "-l")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    limit = try std.fmt.parseInt(usize, args[arg_idx + 1], 10);
                    arg_idx += 1;
                } else {
                    return error.InvalidArgument;
                }
            }
            
            command_args = .{ .search = .{
                .query = query,
                .difficulty = difficulty,
                .limit = limit,
            }};
        },
        .docs => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const neurona_id = args[arg_idx];
            arg_idx += 1;
            
            // Parse global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    return error.InvalidArgument;
                }
            }
            
            command_args = .{ .docs = .{
                .neurona_id = neurona_id,
            }};
        },
        .snippet => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const neurona_id = args[arg_idx];
            arg_idx += 1;
            
            // Parse global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    return error.InvalidArgument;
                }
            }
            
            command_args = .{ .snippet = .{
                .neurona_id = neurona_id,
            }};
        },
        .install => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const source = args[arg_idx];
            arg_idx += 1;
            
            // Parse global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    return error.InvalidArgument;
                }
            }
            
            command_args = .{ .install = .{
                .source = source,
            }};
        },
        .list => {
            var list_tomes = false;
            var list_neuronas = false;
            var tome_name: ?[]const u8 = null;
            
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                
                // Global flags
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                }
                // Command-specific flags
                else if (std.mem.eql(u8, arg, "--tomes") or std.mem.eql(u8, arg, "-t")) {
                    list_tomes = true;
                } else if (std.mem.eql(u8, arg, "--neuronas") or std.mem.eql(u8, arg, "-n")) {
                    list_neuronas = true;
                } else if (std.mem.eql(u8, arg, "--tome")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    tome_name = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    // Default: if it's not a flag, it's a tome name
                    if (tome_name == null) {
                        tome_name = arg;
                        list_neuronas = true;
                    } else {
                        return error.TooManyArguments;
                    }
                }
            }
            
            command_args = .{ .list = .{
                .tomes = list_tomes,
                .neuronas = list_neuronas,
                .tome_name = tome_name,
            }};
        },
        .@"create-tome" => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const name = args[arg_idx];
            arg_idx += 1;
            
            var path: ?[]const u8 = null;
            
            // Parse global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    // Treat non-flag arguments as path
                    if (path == null) {
                        path = arg;
                    } else {
                        return error.TooManyArguments;
                    }
                }
            }
            
            command_args = .{ .@"create-tome" = .{
                .name = name,
                .path = path,
            }};
        },
        .@"validate-tome" => {
            if (arg_idx >= args.len) {
                return error.MissingArgument;
            }
            const path = args[arg_idx];
            arg_idx += 1;
            
            // Parse global flags
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    return error.InvalidArgument;
                }
            }
            
            command_args = .{ .@"validate-tome" = .{
                .path = path,
            }};
        },
        .help => {
            var cmd: ?[]const u8 = null;
            
            // Parse global flags (help doesn't use them, but we should accept them gracefully)
            while (arg_idx < args.len) : (arg_idx += 1) {
                const arg = args[arg_idx];
                if (std.mem.eql(u8, arg, "--json")) {
                    config.json_output = true;
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--no-color")) {
                    config.color_output = false;
                } else if (std.mem.eql(u8, arg, "--color")) {
                    config.color_output = true;
                } else if (std.mem.eql(u8, arg, "--debug")) {
                    config.debug_mode = true;
                } else if (std.mem.eql(u8, arg, "--yes") or std.mem.eql(u8, arg, "-y")) {
                    config.yes_mode = true;
                } else if (std.mem.eql(u8, arg, "--theme")) {
                    if (arg_idx + 1 >= args.len) return error.MissingArgument;
                    config.theme = args[arg_idx + 1];
                    arg_idx += 1;
                } else {
                    // Treat as command to get help for
                    cmd = arg;
                }
            }
            
            command_args = .{ .help = .{
                .command = cmd,
            }};
        },
    }

    return ParseResult{
        .command = command,
        .args = command_args,
        .config = config,
    };
}

fn parseCommand(str: []const u8) !Command {
    if (std.mem.eql(u8, str, "search")) return .search;
    if (std.mem.eql(u8, str, "docs")) return .docs;
    if (std.mem.eql(u8, str, "snippet")) return .snippet;
    if (std.mem.eql(u8, str, "install")) return .install;
    if (std.mem.eql(u8, str, "list")) return .list;
    if (std.mem.eql(u8, str, "create-tome")) return .@"create-tome";
    if (std.mem.eql(u8, str, "validate-tome")) return .@"validate-tome";
    if (std.mem.eql(u8, str, "help")) return .help;
    
    return error.UnknownCommand;
}