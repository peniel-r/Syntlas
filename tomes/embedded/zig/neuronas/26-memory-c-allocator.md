---
id: "zig.memory.c-allocator"
title: "C Allocator"
category: memory
difficulty: intermediate
tags: [zig, memory, c, malloc]
keywords: [c_allocator, malloc]
use_cases: [c interop]
prerequisites: ["zig.interop.c"]
related: ["zig.memory.allocators"]
next_topics: []
---

# C Allocator

Wraps `malloc` and `free`. Requires linking `libc`.

```zig
const allocator = std.heap.c_allocator;
```
