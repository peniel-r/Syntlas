---
id: "zig.patterns.allocator"
title: "Allocator Passing"
category: patterns
difficulty: intermediate
tags: [zig, patterns, memory]
keywords: [init, deinit, allocator]
use_cases: [api design]
prerequisites: ["zig.memory.management"]
related: ["zig.memory.allocators"]
next_topics: []
---

# Allocator Passing

Explicitly pass allocators to `init`.

```zig
const MyType = struct {
    allocator: std.mem.Allocator,
    data: []u8,

    pub fn init(allocator: std.mem.Allocator) !MyType {
        const data = try allocator.alloc(u8, 100);
        return MyType{ .allocator = allocator, .data = data };
    }

    pub fn deinit(self: MyType) void {
        self.allocator.free(self.data);
    }
};
```
