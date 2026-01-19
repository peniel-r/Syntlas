const std_ = @import("std");
const cli_parser = @import("cli/parser.zig");
const cli_commands = @import("cli/commands.zig");

pub fn main() !void {
    var gpa = std_.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get command line arguments
    const args = try std_.process.argsAlloc(allocator);
    defer std_.process.argsFree(allocator, args);

    // Parse command line
    const parse_result = cli_parser.parse(allocator, args) catch |err| {
        // Commands handle their own error reporting
        switch (err) {
            error.UnknownCommand => {
                try cli_commands.runHelp(allocator, .{ .command = null }, .{});
            },
            error.MissingArgument => {
                try cli_commands.runHelp(allocator, .{ .command = null }, .{});
            },
            error.InvalidArgument => {
                try cli_commands.runHelp(allocator, .{ .command = null }, .{});
            },
            error.TooManyArguments => {
                try cli_commands.runHelp(allocator, .{ .command = null }, .{});
            },
            else => {
                try cli_commands.runHelp(allocator, .{ .command = null }, .{});
            },
        }
        
        return err;
    };

    // Execute command
    cli_commands.runCommand(allocator, parse_result.command, parse_result.args, parse_result.config) catch |err| {
        switch (err) {
            error.NeuronaNotFound => {
                // Already handled by command
                std_.process.exit(1);
            },
            error.NotImplemented => {
                // Already handled by command
                std_.process.exit(1);
            },
            error.ValidationFailed => {
                // Already handled by command
                std_.process.exit(1);
            },
            error.OutOfMemory => {
                std_.process.exit(1);
            },
            else => {
                std_.process.exit(1);
            },
        }
    };
}