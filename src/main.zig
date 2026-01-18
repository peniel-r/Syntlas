const std = @import("std");
const Syntlas = @import("Syntlas");
const core = Syntlas.core;
const config = Syntlas.config;
const tome = Syntlas.tome;
const index = Syntlas.index;
const search = Syntlas.search;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("Syntlas - The Neurona System\n", .{});
    std.debug.print("Phase 2: Index Engine Demo\n\n", .{});

    const cfg = try config.manager.load(allocator);
    defer cfg.deinit(allocator);
    std.debug.print("Config: {s}\n\n", .{cfg.tomes_path});

    // Create sample neuronas for indexing
    const tags1 = [_][]const u8{ "python", "async", "concurrency" };
    const keywords1 = [_][]const u8{ "async", "await", "coroutine" };
    const use_cases1 = [_][]const u8{ "handle concurrent requests", "optimize io bound tasks" };
    const prereqs1 = [_]core.schema.Synapse{
        .{ .id = "py.functions.generators", .weight = 90, .optional = false, .relationship = .prerequisite },
    };
    const related1 = [_]core.schema.Synapse{
        .{ .id = "py.async.await", .weight = 80, .optional = false, .relationship = .related },
    };
    const next1 = [_]core.schema.Synapse{};

    const neurona1 = core.schema.Neurona{
        .id = "py.async.coroutines",
        .title = "Python Async Coroutines",
        .category = .concept,
        .difficulty = .intermediate,
        .tags = @as([][]const u8, @constCast(&tags1)),
        .keywords = @as([][]const u8, @constCast(&keywords1)),
        .use_cases = @as([][]const u8, @constCast(&use_cases1)),
        .prerequisites = @as([]core.schema.Synapse, @constCast(&prereqs1)),
        .related = @as([]core.schema.Synapse, @constCast(&related1)),
        .next_topics = @as([]core.schema.Synapse, @constCast(&next1)),
        .file_path = "python/async/coroutines.md",
        .content_offset = 0,
    };

    const tags2 = [_][]const u8{ "javascript", "async" };
    const keywords2 = [_][]const u8{ "async", "promise", "then" };
    const use_cases2 = [_][]const u8{ "handle api response", "chain async operations" };
    const prereqs2 = [_]core.schema.Synapse{};
    const related2 = [_]core.schema.Synapse{};
    const next2 = [_]core.schema.Synapse{};

    const neurona2 = core.schema.Neurona{
        .id = "js.async.promises",
        .title = "JavaScript Promises",
        .category = .concept,
        .difficulty = .novice,
        .tags = @as([][]const u8, @constCast(&tags2)),
        .keywords = @as([][]const u8, @constCast(&keywords2)),
        .use_cases = @as([][]const u8, @constCast(&use_cases2)),
        .prerequisites = @as([]core.schema.Synapse, @constCast(&prereqs2)),
        .related = @as([]core.schema.Synapse, @constCast(&related2)),
        .next_topics = @as([]core.schema.Synapse, @constCast(&next2)),
        .file_path = "javascript/async/promises.md",
        .content_offset = 0,
    };

    const neuronas = [_]core.schema.Neurona{ neurona1, neurona2 };
    const contents = [_][]const u8{
        "Async coroutines in Python allow asynchronous programming using async and await keywords.",
        "JavaScript promises provide a way to handle async operations with then and catch methods.",
    };

    // Build indices
    std.debug.print("Building indices...\n", .{});
    var builder = index.builder.IndexBuilder.init(allocator);
    defer builder.deinit();

    const stats = try builder.buildFromCollection(&neuronas, &contents);
    stats.print();
    std.debug.print("\n", .{});

    // Demonstrate inverted index search
    std.debug.print("=== Inverted Index Demo ===\n", .{});
    if (builder.inverted_index.search("async")) |results| {
        std.debug.print("Search 'async': found {d} neuronas\n", .{results.neurona_ids.items.len});
        for (results.neurona_ids.items, results.term_frequencies.items) |id, tf| {
            std.debug.print("  - {s} (TF: {d:.4})\n", .{ id, tf });
        }
    }
    std.debug.print("\n", .{});

    // Demonstrate graph index
    std.debug.print("=== Graph Index Demo ===\n", .{});
    const prereqs = try builder.graph_index.getPrerequisites("py.async.coroutines", allocator);
    defer allocator.free(prereqs);
    std.debug.print("Prerequisites for 'py.async.coroutines': {d}\n", .{prereqs.len});
    for (prereqs) |conn| {
        std.debug.print("  - {s} (weight: {d})\n", .{ conn.target_id, conn.weight });
    }
    std.debug.print("\n", .{});

    // Demonstrate metadata index
    std.debug.print("=== Metadata Index Demo ===\n", .{});
    const concepts = try builder.metadata_index.filterByCategory(.concept, allocator);
    defer allocator.free(concepts);
    std.debug.print("Neuronas in 'concept' category: {d}\n", .{concepts.len});
    for (concepts) |id| {
        std.debug.print("  - {s}\n", .{id});
    }
    std.debug.print("\n", .{});

    const novices = try builder.metadata_index.filterByDifficulty(.novice, allocator);
    defer allocator.free(novices);
    std.debug.print("Neuronas at 'novice' difficulty: {d}\n", .{novices.len});
    for (novices) |id| {
        std.debug.print("  - {s}\n", .{id});
    }
    std.debug.print("\n", .{});

    // Combined filter
    const filtered = try builder.metadata_index.filterCombined(
        .concept,
        .novice,
        &[_][]const u8{"async"},
        allocator,
    );
    defer allocator.free(filtered);
    std.debug.print("Combined filter (concept + novice + async tag): {d}\n", .{filtered.len});
    for (filtered) |id| {
        std.debug.print("  - {s}\n", .{id});
    }
    std.debug.print("\n", .{});

    // Demonstrate Search Engine Stage 1 & 2
    // std.debug.print("=== Search Engine Demo ===\n", .{});
    // var engine = search.engine.SearchEngine.init(
    //     allocator,
    //     &builder.inverted_index,
    //     &builder.graph_index,
    //     &builder.metadata_index,
    //     &builder.use_case_index,
    // );

    // var stage1_results = try engine.stage1_TextMatch("async python");
    // defer stage1_results.deinit(allocator);

    // std.debug.print("Stage 1 'async python' activations: {d}\n", .{stage1_results.count()});
    // var it = stage1_results.iterator();
    // while (it.next()) |entry| {
    //     std.debug.print("  - {s}: {d:.4}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    // }
    // std.debug.print("\n", .{});

    // var stage2_results = try engine.stage2_SemanticMatch("optimize tasks");
    // defer stage2_results.deinit(allocator);

    // std.debug.print("Stage 2 'optimize tasks' activations: {d}\n", .{stage2_results.count()});
    // var it2 = stage2_results.iterator();
    // while (it2.next()) |entry| {
    //     std.debug.print("  - {s}: {d:.4}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    // }

    std.debug.print("\n✓ Index engine operational\n", .{});
}
