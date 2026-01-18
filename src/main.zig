const std = @import("std");
const schema = @import("core/schema.zig");
const builder_mod = @import("index/builder.zig");
const engine_mod = @import("search/engine.zig");
const config_mod = @import("config/mod.zig");
const inverted = @import("index/inverted.zig");
const graph = @import("index/graph.zig");
const metadata = @import("index/metadata.zig");
const use_case = @import("index/use_case.zig");

const Neurona = schema.Neurona;
const Synapse = schema.Synapse;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("Syntlas - The Neurona System\n", .{});
    std.debug.print("Phase 3: Search Algorithm Demo\n\n", .{});

    const cfg = try config_mod.manager.load(allocator);
    defer cfg.deinit(allocator);
    std.debug.print("Config: {s}\n\n", .{cfg.tomes_path});

    // Create sample neuronas for indexing
    const tags1 = [_][]const u8{ "python", "async", "concurrency" };
    const keywords1 = [_][]const u8{ "async", "await", "coroutine" };
    const use_cases1 = [_][]const u8{ "handle concurrent requests", "optimize io bound tasks" };
    const prereqs1 = [_]Synapse{
        .{ .id = "py.functions.generators", .weight = 90, .optional = false, .relationship = .prerequisite },
    };
    const related1 = [_]Synapse{
        .{ .id = "py.async.await", .weight = 80, .optional = false, .relationship = .related },
    };
    const next1 = [_]Synapse{};

    const neurona1 = Neurona{
        .id = "py.async.coroutines",
        .title = "Python Async Coroutines",
        .category = .concept,
        .difficulty = .intermediate,
        .tags = @as([][]const u8, @constCast(&tags1)),
        .keywords = @as([][]const u8, @constCast(&keywords1)),
        .use_cases = @as([][]const u8, @constCast(&use_cases1)),
        .prerequisites = @as([]Synapse, @constCast(&prereqs1)),
        .related = @as([]Synapse, @constCast(&related1)),
        .next_topics = @as([]Synapse, @constCast(&next1)),
        .file_path = "python/async/coroutines.md",
        .content_offset = 0,
        .quality = .{ .tested = true, .production_ready = true },
        .search_weight = 100,
        .last_updated = 1737139200, // 2025-01-17
    };

    const tags2 = [_][]const u8{ "javascript", "async" };
    const keywords2 = [_][]const u8{ "async", "promise", "then" };
    const use_cases2 = [_][]const u8{ "handle api response", "chain async operations" };
    const prereqs2 = [_]Synapse{};
    const related2 = [_]Synapse{};
    const next2 = [_]Synapse{};

    const neurona2 = Neurona{
        .id = "js.async.promises",
        .title = "JavaScript Promises",
        .category = .concept,
        .difficulty = .novice,
        .tags = @as([][]const u8, @constCast(&tags2)),
        .keywords = @as([][]const u8, @constCast(&keywords2)),
        .use_cases = @as([][]const u8, @constCast(&use_cases2)),
        .prerequisites = @as([]Synapse, @constCast(&prereqs2)),
        .related = @as([]Synapse, @constCast(&related2)),
        .next_topics = @as([]Synapse, @constCast(&next2)),
        .file_path = "javascript/async/promises.md",
        .content_offset = 0,
        .quality = .{},
        .search_weight = 100,
        .last_updated = 1737052800, // 2025-01-16
    };

    const neuronas = [_]Neurona{ neurona1, neurona2 };
    const contents = [_][]const u8{
        "Async coroutines in Python allow asynchronous programming using async and await keywords.",
        "JavaScript promises provide a way to handle async operations with then and catch methods.",
    };

    // Build indices
    std.debug.print("Building indices...\n", .{});
    var builder = builder_mod.IndexBuilder.init(allocator);
    defer builder.deinit();

    const stats = try builder.buildFromCollection(&neuronas, &contents);
    stats.print();
    std.debug.print("\n", .{});

    // Demonstrate Search Engine complete pipeline
    std.debug.print("=== Search Engine Demo ===\n", .{});
    var engine = engine_mod.SearchEngine.init(
        allocator,
        &builder.inverted_index,
        &builder.graph_index,
        &builder.metadata_index,
        &builder.use_case_index,
    );

    const context = engine_mod.SearchContext{
        .difficulty = .intermediate,
    };

    // Perform search
    const query = "async python";
    const results = try engine.search(query, context, .{});
    defer allocator.free(results);

    std.debug.print("Search results for '{s}' (difficulty=intermediate):\n", .{query});
    for (results) |res| {
        std.debug.print("  - {s}: final score={d:.4}\n", .{ res.id, res.score });
    }
    std.debug.print("\n", .{});

    // Fuzzy demo
    std.debug.print("=== Fuzzy Search Demo ===\n", .{});
    const fuzzy_query = "pyton";
    const fuzzy_results = try engine.search(fuzzy_query, .{}, .{});
    defer allocator.free(fuzzy_results);

    std.debug.print("Search results for '{s}' (fuzzy):\n", .{fuzzy_query});
    for (fuzzy_results) |res| {
        std.debug.print("  - {s}: score={d:.4}\n", .{ res.id, res.score });
    }

    std.debug.print("\n✓ Index & Search engines operational\n", .{});
}
