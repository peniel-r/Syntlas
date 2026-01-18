---
id: "zig.stdlib.collections"
title: "Standard Library Collections"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, ArrayList, HashMap, StringHashMap]
keywords: [std.ArrayList, std.HashMap, std.StringHashMap, std.AutoHashMap]
use_cases: [dynamic arrays, key-value storage, string operations]
prerequisites: []
related: ["zig.stdlib.allocators"]
next_topics: ["zig.stdlib.io"]
---

# Standard Library Collections

Zig's std provides efficient collection types for common use cases.

## ArrayList - Dynamic Array

```zig
const std = @import("std");

fn array_list_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    // Create list with specific type
    var list = std.ArrayList(i32).init(gpa.allocator());

    // Add elements
    try list.append(1);
    try list.append(2);
    try list.append(3);

    // Access elements
    const first = list.items[0];
    const last = list.items[list.items.len - 1];

    std.debug.print("First: {}, Last: {}\n", .{first, last});

    // Free when done
    list.deinit();
}
```

## HashMap - Hash Map

```zig
const std = @import("std");

fn hash_map_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    var map = std.StringHashMap(i32).init(gpa.allocator());

    // Insert key-value pairs
    try map.put("one", 1);
    try map.put("two", 2);
    try map.put("three", 3);

    // Get values
    if (map.get("two")) |value| {
        std.debug.print("Found: {}\n", .{value});
    }

    // Check existence
    if (map.contains("three")) {
        std.debug.print("Three exists\n", .{});
    }

    // Remove value
    if (map.fetchRemove("one")) |entry| {
        std.debug.print("Removed: {}\n", .{entry.value});
    }

    map.deinit();
}
```

## StringHashMap - Optimized for String Keys

```zig
const std = @import("std");

fn string_hash_map_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    var map = std.StringHashMap(i32).init(gpa.allocator());

    try map.put("apple", 5);
    try map.put("banana", 3);
    try map.put("cherry", 7);

    // Iterate
    var iter = map.iterator();
    while (iter.next()) |entry| {
        std.debug.print("{s}: {}\n", .{entry.key_ptr.*, entry.value_ptr.*});
    }

    map.deinit();
}
```

## AutoHashMap - Auto-Managed HashMap

```zig
const std = @import("std");

fn auto_hash_map_example() !void {
    var map = std.AutoHashMap(u32, i32).init(
        std.heap.page_allocator,
    );

    // No explicit allocator management
    try map.put(1, 10);
    try map.put(2, 20);
    try map.put(3, 30);

    if (map.get(2)) |value| {
        std.debug.print("Value: {}\n", .{value});
    }
}
```

## ArrayListAligned - Aligned Dynamic Array

```zig
const std = @import("std");

fn aligned_list_example() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // List with specific alignment
    var list = std.ArrayListAligned(f64, null).init(arena.allocator());

    try list.append(1.5);
    try list.append(2.5);
    try list.append(3.14);

    std.debug.print("First: {}, Second: {}\n", .{list.items[0], list.items[1]});
}
```

## MultiArrayList - Multiple Types in One Structure

```zig
const std = @import("std");

fn multi_array_list_example() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // Multi-list for int and float
    var multi = std.MultiArrayList(i32, f64).init(arena.allocator());

    try multi.append(0, 42, 1);
    try multi.append(1, 3.14, 2);

    std.debug.print("Int: {}, Float: {}\n", .{multi.items[0][0], multi.items[1][0]});
}
```

## BoundedArray - Fixed-Size Array

```zig
const std = @import("std");

fn bounded_array_example() !void {
    var buffer: [5]u32 = undefined;
    var array = std.BoundedArray(u32, 5).init(&buffer);

    // Circular buffer behavior
    try array.append(1);
    try array.append(2);
    try array.append(3);
    try array.append(4);
    try array.append(5);

    // Overwrites oldest when full
    try array.append(6);  // Overwrites 1

    std.debug.print("Items: {any}\n", .{array.slice()});
}
```

## HashMap Iteration

```zig
const std = @import("std");

fn map_iteration_example() !void {
    var map = std.StringHashMap(i32).init(std.heap.page_allocator);
    defer map.deinit();

    try map.put("one", 1);
    try map.put("two", 2);

    // Get iterator
    var iter = map.iterator();

    while (iter.next()) |entry| {
        std.debug.print("Key: {s}, Value: {}\n", .{entry.key_ptr.*, entry.value_ptr.*});
    }
}
```

## Common Patterns

### Count occurrences

```zig
const std = @import("std");

fn count_words(text: []const u8) !void {
    var map = std.StringHashMap(u32).init(std.heap.page_allocator);
    defer map.deinit();

    var iter = std.mem.tokenize(u8, text, .any);
    while (iter.next()) |word| {
        const count = map.get(word) orelse 0;
        try map.put(word, count + 1);
    }

    // Print counts
    var map_iter = map.iterator();
    while (map_iter.next()) |entry| {
        std.debug.print("{s}: {}\n", .{entry.key_ptr.*, entry.value_ptr.*});
    }
}
```

### Group by key

```zig
const std = @import("std");

const Item = struct { key: []const u8, value: i32 };

fn group_by_key(items: []const Item) !void {
    var groups = std.StringHashMap(std.ArrayList(i32)).init(std.heap.page_allocator);
    defer {
        var iter = groups.valueIterator();
        while (iter.next()) |entry| {
            entry.value_ptr.deinit();
        }
        groups.deinit();
    }

    for (items) |item| {
        const entry = try groups.getOrPut(item.key, std.heap.page_allocator);
        try entry.value_ptr.append(item.value);
    }
}
```

### Queue using ArrayList

```zig
const std = @import("std");

fn queue_example() !void {
    var queue = std.ArrayList(i32).init(std.heap.page_allocator);
    defer queue.deinit();

    try queue.append(1);
    try queue.append(2);
    try queue.append(3);

    // Dequeue from front
    const first = queue.orderedRemove(0);
    std.debug.print("Dequeued: {}\n", .{first});

    // Peek at front without removing
    const peek = queue.items[0];
    std.debug.print("Peek: {}\n", .{peek});
}
```

### Stack using ArrayList

```zig
const std = @import("std");

fn stack_example() !void {
    var stack = std.ArrayList(i32).init(std.heap.page_allocator);
    defer stack.deinit();

    try stack.append(1);
    try stack.append(2);
    try stack.append(3);

    // Pop from end
    const top = stack.pop();
    std.debug.print("Popped: {}\n", .{top});
}
```

### Priority queue

```zig
const std = @import("std");

fn priority_queue_example() !void {
    const Item = struct { value: i32, priority: u32 };

    var queue = std.ArrayList(Item).init(std.heap.page_allocator);
    defer queue.deinit();

    try queue.append(.{ .value = 1, .priority = 1 });
    try queue.append(.{ .value = 2, .priority = 3 });
    try queue.append(.{ .value = 3, .priority = 2 });

    // Sort by priority (highest first)
    std.sort.sort(Item, queue.items, .{}, comptime struct { field: priority });

    const item = queue.orderedRemove(0);
    std.debug.print("Next: {}\n", .{item.value});
}
```

> **Tip**: Use AutoHashMap for automatic memory management, HashMap for explicit control.
