---
id: "zig.stdlib.allocators"
title: "Memory Allocators"
category: stdlib
difficulty: intermediate
tags: [zig, allocator, std.mem.Allocator, heap, arena]
keywords: [std.heap.ArenaAllocator, std.heap.GeneralPurposeAllocator, std.heap.page_allocator, std.heap.c_allocator]
use_cases: [memory management, performance, safety]
prerequisites: []
related: ["zig.comptime", "zig.memory.management"]
next_topics: ["zig.stdlib.collections"]
---

# Memory Allocators

Zig provides flexible memory allocation strategies.

## ArenaAllocator - Fast Stack-Like Allocation

```zig
const std = @import("std");

fn arena_example() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // Allocate strings (freed together)
    const s1 = try arena.allocator().allocPrint(u8, "Hello", .{});
    const s2 = try arena.allocator().allocPrint(u8, " World", .{});
    const combined = try arena.allocator().allocPrint(u8, "{s} {s}", .{s1, s2});

    std.debug.print("Combined: {s}\n", .{combined});
}
```

## GeneralPurposeAllocator - Safe Debug Allocator

```zig
const std = @import("std");

fn gpa_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    // Allocate with safety checks
    const data = try gpa.allocator().alloc(i32, 100);
    defer gpa.allocator().free(data);

    std.debug.print("Value: {}\n", .{data.*});
}
```

## PageAllocator - Direct OS Page Allocation

```zig
const std = @import("std");

fn page_allocator_example() !void {
    var page_allocator = std.heap.page_allocator;

    // Allocate pages directly from OS
    const page = try page_allocator.alloc(
        std.mem.page_size,
        std.mem.page_size,
        @alignOf(u32),
    );
    defer page_allocator.free(page);

    std.debug.print("Page allocated\n", .{});
}
```

## CAllocator - C-compatible Allocation

```zig
const std = @import("std");

fn c_allocator_example() !void {
    var c_allocator = std.heap.c_allocator;

    // Use C allocator for FFI
    const ptr = try c_allocator.alloc(i32, 100);
    defer c_allocator.free(ptr);

    std.debug.print("C allocation\n", .{});
}
```

## StackAllocator - Bounded Stack Allocation

```zig
const std = @import("std");

fn stack_allocator_example() !void {
    // Buffer for stack allocator
    var buffer: [100 * usize] = undefined;
    var stack_allocator = std.heap.StackAllocator.init(&buffer);

    // Fast allocation from stack buffer
    const data = try stack_allocator.allocator().alloc(i32, 100);

    std.debug.print("Stack allocated: {}\n", .{data.*});
}
```

## FixedBufferAllocator - Fixed-size Buffer

```zig
const std = @import("std");

fn fixed_buffer_example() !void {
    // Fixed-size buffer (no freeing)
    var buffer: [1000]u8 = undefined;
    var allocator = std.heap.FixedBufferAllocator.init(&buffer);

    const data = try allocator.allocator().alloc(u8, 100);
    std.debug.print("Fixed buffer: {s}\n", .{data[0..10]});
}
```

## Common Patterns

### Temporary allocations in scope

```zig
const std = @import("std");

fn process_with_arena(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    // All temp allocations freed at once
    const s1 = try arena.allocator().allocPrint(u8, "temp", .{});
    const s2 = try arena.allocator().allocPrint(u8, "data", .{});
    const s3 = try arena.allocator().allocPrint(u8, "result", .{});
}
```

### Fallback allocator chain

```zig
const std = @import("std");

fn fallback_example() !void {
    const fallback1 = std.heap.page_allocator;
    const fallback2 = std.heap.c_allocator;

    var allocator = std.heap.FallbackAllocator.init(
        &fallback1.allocator(),
        &fallback2.allocator(),
    );
}
```

### Arena for string building

```zig
const std = @import("std");

fn build_string_arena(allocator: std.mem.Allocator) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var list = std.ArrayList([]const u8).init(arena.allocator());

    try list.append("Hello");
    try list.append(" ");
    try list.append("World");

    return try list.toOwnedSlice();
}
```

### GeneralPurposeAllocator for testing

```zig
const std = @import("std");

fn test_with_gpa() !void {
    // GPA detects memory leaks, double-free
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer {
        const leaked = gpa.deinit();
        if (leaked > 0) {
            std.debug.print("Leaked {} bytes\n", .{leaked});
        }
    }

    // Run test code...
}
```

### Memory pool for small objects

```zig
const std = @import("std");

const PoolSize = 100;

fn pool_allocator_example() !void {
    var buffer: [PoolSize * @sizeOf(MyObject)] = undefined;
    var free_list = std.ArrayList(*MyObject).init(std.heap.page_allocator);
    defer free_list.deinit();

    // Simple pool implementation
    const obj = try allocate_from_pool();
    // ... use object ...
    return_to_pool(obj);
}
```

### Aligned allocations

```zig
const std = @import("std");

fn aligned_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    // Allocate with specific alignment
    const ptr = try gpa.allocator().rawAlloc(
        256,
        @alignOf(f64),  // 8-byte alignment
    );

    defer gpa.allocator().rawFree(ptr, 256, @alignOf(f64));
}
```

> **Tip**: Use ArenaAllocator for temporary allocations that share the same lifetime - much faster and safer.
