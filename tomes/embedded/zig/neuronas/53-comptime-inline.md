---
id: "zig.comptime.inline"
title: "Inline Loops"
category: comptime
difficulty: advanced
tags: [zig, comptime, inline, unroll]
keywords: [inline for, inline while]
use_cases: [loop unrolling, type iteration]
prerequisites: ["zig.comptime.basics"]
related: ["zig.comptime.generics"]
next_topics: []
---

# Inline Loops

Unrolls loops at compile time. Essential for iterating over tuples of types or struct fields.

```zig
const types = .{ i32, f32, bool };
inline for (types) |T| {
    // Generates code for each T
}
```
