const std = @import("std");
const syntlas = @import("Syntlas");
const validator = syntlas.tome.validator;

pub fn main() !void {
    std.debug.print("=== Phase 6: Embedded Tomes Verification ===\n", .{});
    const allocator = std.heap.page_allocator;

    const tomes = [_][]const u8{ "c", "cpp", "python", "rust", "zig" };
    const base_path = "tomes/embedded";

    for (tomes) |tome_name| {
        std.debug.print("Validating {s}... ", .{tome_name});
        const path = try std.fs.path.join(allocator, &.{ base_path, tome_name });
        defer allocator.free(path);

        var result = try validator.validateTome(allocator, path);
        defer result.deinit(allocator);

        if (result.valid) {
            std.debug.print("PASSED\n", .{});
        } else {
            std.debug.print("FAILED ({} errors)\n", .{result.errors.len});
            for (result.errors) |err| {
                std.debug.print("  {s}: {s}\n", .{ err.file_path, err.message });
            }
        }
    }
    std.debug.print("\nVerification Complete\n", .{});
}
