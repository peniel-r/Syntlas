const std = @import("std");
const search = @import("search/mod.zig");
const tome = @import("tome/mod.zig");
const core = @import("core/mod.zig");
const builder_mod = @import("index/builder.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Demo: Search for pointers
    const query = "pointers";
    
    std.debug.print("Syntlas Demo - Neural Documentation Navigator\n", .{});
    std.debug.print("===========================================\n\n", .{});
    
    std.debug.print("Loading embedded tomes...\n", .{});
    const embedded_dir = "tomes/embedded";
    
    // Use TomeLoader to load all tomes
    var loader = tome.loader.TomeLoader.init(allocator);
    defer loader.deinit();
    
    try loader.loadAllEmbeddedTomes(embedded_dir);
    
    const neuronas = loader.getNeuronas();
    const contents = loader.getContents();
    std.debug.print("Loaded {d} neuronas\n\n", .{neuronas.len});
    
    std.debug.print("Building search index...\n", .{});
    
    // Build search indices
    var builder = builder_mod.IndexBuilder.init(allocator);
    defer builder.deinit();
    
    _ = try builder.buildFromCollection(neuronas, contents);
    
    // Create search engine with built indices
    var engine = search.engine.SearchEngine.init(
        allocator,
        &builder.inverted_index,
        &builder.graph_index,
        &builder.metadata_index,
        &builder.use_case_index,
    );
    
    std.debug.print("  Index built\n\n", .{});
    
    // Perform search
    std.debug.print("Searching for: '{s}'\n", .{query});
    const start_time = std.time.nanoTimestamp();
    
    const results = try engine.search(query, .{ .difficulty = null }, .{});
    defer allocator.free(results);
    
    const end_time = std.time.nanoTimestamp();
    const elapsed_ms = @as(f64, @floatFromInt(end_time - start_time)) / 1_000_000.0;
    
    std.debug.print("Found {d} results in {d:.2}ms\n\n", .{ results.len, elapsed_ms });
    
    // Display results
    for (results, 0..) |result, i| {
        std.debug.print("{d}. {s} (score: {d:.4})\n", .{ i + 1, result.id, result.score });
        
        if (result.snippet) |snippet| {
            std.debug.print("   Snippet: {s}\n", .{snippet});
        }
        std.debug.print("\n", .{});
    }
    
    std.debug.print("\nDemo complete!\n", .{});
}