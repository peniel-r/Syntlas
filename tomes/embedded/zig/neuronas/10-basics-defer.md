---
id: "zig.basics.defer"
title: "Defer"
category: basics
difficulty: beginner
tags: [zig, basics, defer, cleanup]
keywords: [defer, errdefer]
use_cases: [resource cleanup, unwinding]
prerequisites: ["zig.basics.functions"]
related: ["zig.basics.functions"]
next_topics: []
---

# Defer

`defer` executes a statement when the block exits (scope exit).

## Usage

```zig
fn example() !void {
    const file = try std.fs.cwd().openFile("test.txt", .{});
    defer file.close(); // Runs at end of function

    // ... use file ...
}
```

## LIFO Order

Multiple defers run in Last-In-First-Out order.

## errdefer

Runs only if the block exits with an error.

```zig
const ptr = allocator.alloc(u8, 100) catch return error.OOM;
errdefer allocator.free(ptr);
```
