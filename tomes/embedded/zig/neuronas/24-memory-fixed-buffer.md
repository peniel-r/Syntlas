---
id: "zig.memory.fixed-buffer"
title: "FixedBufferAllocator"
category: memory
difficulty: intermediate
tags: [zig, memory, stack, buffer]
keywords: [FixedBufferAllocator, stack allocation]
use_cases: [embedded, no-heap, deterministic]
prerequisites: ["zig.memory.allocators"]
related: ["zig.memory.page"]
next_topics: []
---

# FixedBufferAllocator

Allocates from a fixed slice of memory (stack or pre-allocated).

## Usage

```zig
var buffer: [1024]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buffer);
const allocator = fba.allocator();

// Fast, fails if buffer full
```
