---
id: "zig.memory.arena"
title: "ArenaAllocator"
category: memory
difficulty: intermediate
tags: [zig, memory, arena, performance]
keywords: [ArenaAllocator, reset, deinit]
use_cases: [batch allocation, short-lived tasks]
prerequisites: ["zig.memory.allocators"]
related: ["zig.memory.fixed-buffer"]
next_topics: ["zig.memory.fixed-buffer"]
---

# ArenaAllocator

Wraps another allocator. Frees everything at once.

## Usage

```zig
var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
defer arena.deinit(); // Frees EVERYTHING

const allocator = arena.allocator();
// Allocating... no individual frees needed
```
