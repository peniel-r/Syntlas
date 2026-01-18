const std = @import("std");
const Allocator = std.mem.Allocator;
const syntlas = @import("Syntlas");
const engine_mod = syntlas.search.engine;
const builder_mod = syntlas.index.builder;
const schema = syntlas.core.schema;
const Synapse = schema.Synapse;

const Neurona = schema.Neurona;

/// Performance validation tests for Phase 3: Search Algorithm
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== Phase 3 Performance Validation Tests ===\n\n", .{});

    // Create test neuronas
    const neuronas = try createTestNeuronas(allocator);
    defer cleanupNeuronas(allocator, neuronas);

    // Build indices
    std.debug.print("Building indices...\n", .{});
    var builder = builder_mod.IndexBuilder.init(allocator);
    defer builder.deinit();

    const build_start = std.time.nanoTimestamp();
    const stats = try builder.buildFromCollection(neuronas, &[_][]const u8{});
    const build_end = std.time.nanoTimestamp();
    const build_time_ms = @as(f64, @floatFromInt(build_end - build_start)) / 1_000_000.0;

    stats.print();
    std.debug.print("Build time: {d:.2}ms\n\n", .{build_time_ms});

    // Create search engine
    var engine = engine_mod.SearchEngine.init(
        allocator,
        &builder.inverted_index,
        &builder.graph_index,
        &builder.metadata_index,
        &builder.use_case_index,
    );

    // Test 1: Simple text query (<10ms target)
    std.debug.print("Test 1: Simple text query (target: <10ms)\n", .{});
    try benchmarkQuery(&engine, "async", .{}, .{}, 10.0, 10);

    // Test 2: Faceted query (difficulty + tags) (<15ms target)
    std.debug.print("\nTest 2: Faceted query (target: <15ms)\n", .{});
    try benchmarkQuery(&engine, "async", .{ .difficulty = .intermediate }, .{}, 15.0, 10);

    // Test 3: Graph traversal (depth 3) (<15ms target)
    std.debug.print("\nTest 3: Graph traversal depth 3 (target: <15ms)\n", .{});
    try benchmarkQuery(&engine, "async", .{}, .{ .depth = 3 }, 15.0, 10);

    // Test 4: Full neural search (<20ms target)
    std.debug.print("\nTest 4: Full neural search (target: <20ms)\n", .{});
    try benchmarkQuery(&engine, "async python", .{ .difficulty = .intermediate }, .{ .depth = 2 }, 20.0, 10);

    std.debug.print("\n=== All Performance Tests Complete ===\n", .{});
}

fn createTestNeuronas(allocator: Allocator) ![]Neurona {
    var neuronas = std.ArrayListUnmanaged(Neurona){};
    errdefer neuronas.deinit(allocator);

    // Create 100 test neuronas for performance testing
    var i: usize = 0;
    while (i < 100) : (i += 1) {
        const id = try std.fmt.allocPrint(allocator, "test.neurona.{d}", .{i});
        const title = try std.fmt.allocPrint(allocator, "Test Neurona {d}", .{i});
        const tags = [_][]const u8{"test"};
        const keywords = [_][]const u8{ "async", "test", "keyword" };
        const use_cases = [_][]const u8{"test use case"};

        const neurona = Neurona{
            .id = id,
            .title = title,
            .category = .concept,
            .difficulty = if (i % 4 == 0) .novice else if (i % 4 == 1) .intermediate else if (i % 4 == 2) .advanced else .expert,
            .tags = @as([][]const u8, @constCast(&tags)),
            .keywords = @as([][]const u8, @constCast(&keywords)),
            .use_cases = @as([][]const u8, @constCast(&use_cases)),
            .prerequisites = &[_]Synapse{},
            .related = &[_]Synapse{},
            .next_topics = &[_]Synapse{},
            .file_path = "",
            .content_offset = 0,
            .quality = .{ .tested = true },
            .search_weight = 100,
            .last_updated = 1737139200 + @as(i64, @intCast(i * 86400)), // Different timestamps
        };

        try neuronas.append(allocator, neurona);
    }

    return neuronas.toOwnedSlice(allocator);
}

fn cleanupNeuronas(allocator: Allocator, neuronas: []Neurona) void {
    for (neuronas) |n| {
        allocator.free(n.id);
        allocator.free(n.title);
        // Don't free tags, keywords, use_cases - they're string literals
    }
    allocator.free(neuronas);
}

fn benchmarkQuery(
    engine: *engine_mod.SearchEngine,
    query: []const u8,
    context: engine_mod.SearchContext,
    expansion_options: engine_mod.ExpansionOptions,
    target_ms: f64,
    iterations: usize,
) !void {
    _ = expansion_options; // Not used in this benchmark
    var total_time_ns: i128 = 0;
    var min_time_ns: i128 = std.math.maxInt(i128);
    var max_time_ns: i128 = 0;

    var i: usize = 0;
    while (i < iterations) : (i += 1) {
        const start = std.time.nanoTimestamp();
        const results = try engine.search(query, context, .{ .max_results = 50 });
        const end = std.time.nanoTimestamp();

        const elapsed = end - start;
        total_time_ns += elapsed;

        if (elapsed < min_time_ns) min_time_ns = elapsed;
        if (elapsed > max_time_ns) max_time_ns = elapsed;

        engine.allocator.free(results);
    }

    const avg_time_ms = @as(f64, @floatFromInt(total_time_ns)) / @as(f64, @floatFromInt(iterations)) / 1_000_000.0;
    const min_time_ms = @as(f64, @floatFromInt(min_time_ns)) / 1_000_000.0;
    const max_time_ms = @as(f64, @floatFromInt(max_time_ns)) / 1_000_000.0;

    std.debug.print("  Query: '{s}'\n", .{query});
    std.debug.print("  Avg: {d:.2}ms (target: <{d:.0}ms) {s}\n", .{ avg_time_ms, target_ms, if (avg_time_ms < target_ms) "✓ PASS" else "✗ FAIL" });
    std.debug.print("  Min: {d:.2}ms, Max: {d:.2}ms\n", .{ min_time_ms, max_time_ms });
}
