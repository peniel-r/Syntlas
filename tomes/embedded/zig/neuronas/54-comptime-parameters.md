---
id: "zig.comptime.parameters"
title: "Comptime Parameters"
category: comptime
difficulty: intermediate
tags: [zig, comptime, parameters]
keywords: [comptime, anytype]
use_cases: [static configuration]
prerequisites: ["zig.comptime.basics"]
related: ["zig.comptime.generics"]
next_topics: []
---

# Comptime Parameters

Arguments that must be known at compile time.

```zig
fn repeat(comptime n: usize, msg: []const u8) void {
    inline for (0..n) |_| {
        std.debug.print("{s}", .{msg});
    }
}
```
