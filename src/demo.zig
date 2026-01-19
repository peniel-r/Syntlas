const std = @import("std");
const config = @import("config/mod.zig");
const search = @import("search/mod.zig");
const tome = @import("tome/mod.zig");
const core = @import("core/mod.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Demo: Search for pointers in C tome
    const query = "pointers";
    const tome_filter = "c";
    
    std.debug.print("Syntlas Demo - Neural Documentation Navigator\n", .{});
    std.debug.print("===========================================\n\n", .{});
    
    std.debug.print("Loading embedded tomes...\n", .{});
    const embedded_dir = "tomes/embedded";
    var tomes = std.ArrayList(tome.Tome).init(allocator);
    defer {
        for (tomes.items) |t| {
            t.deinit(allocator);
        }
        tomes.deinit();
    }
    
    // Load all embedded tomes
    var dir = try std.fs.cwd().openIterableDir(embedded_dir, .{});
    defer dir.close();
    
    var iterator = dir.iterateAssumeFirstType();
    while (try iterator.next()) |entry| {
        if (entry.kind == .directory) {
            const tome_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ embedded_dir, entry.name });
            defer allocator.free(tome_path);
            
            if (try tome.loadTome(allocator, tome_path)) |loaded_tome| {
                std.debug.print("  Loaded {s} tome ({d} neuronas)\n", .{ loaded_tome.name, loaded_tome.neuronas.count() });
                try tomes.append(loaded_tome);
            } else |_| {
                std.debug.print("  Skipped {s} (invalid or empty)\n", .{entry.name});
            }
        }
    }
    
    std.debug.print("\nBuilding search index...\n", .{});
    
    // Build search index from all tomes
    var search_engine = try search.SearchEngine.init(allocator);
    defer search_engine.deinit(allocator);
    
    for (tomes.items) |t| {
        try search_engine.addTome(t);
    }
    
    try search_engine.buildIndex();
    std.debug.print("  Index built with {d} neuronas\n\n", .{search_engine.neuronaCount()});
    
    // Perform search
    std.debug.print("Searching for: '{s}'\n", .{query});
    const start_time = std.time.nanoTimestamp();
    
    const results = try search_engine.search(allocator, query, .{
        .difficulty = null,
        .limit = 5,
    });
    defer allocator.free(results);
    
    const end_time = std.time.nanoTimestamp();
    const elapsed_ms = @as(f64, @floatFromInt(end_time - start_time)) / 1_000_000.0;
    
    std.debug.print("Found {d} results in {d:.2}ms\n\n", .{ results.len, elapsed_ms });
    
    // Display results
    for (results, 0..) |result, i| {
        std.debug.print("{d}. {s} (score: {d:.4})\n", .{ i + 1, result.neurona.id, result.score });
        std.debug.print("   Title: {s}\n", .{result.neurona.title});
        
        if (result.snippet) |snippet| {
            std.debug.print("   Snippet: {s}\n", .{snippet});
        }
        std.debug.print("\n");
    }
    
    std.debug.print("\nDemo complete!\n", .{});
}