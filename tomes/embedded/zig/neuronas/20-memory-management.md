---
id: "zig.memory.management"
title: "Manual Memory Management"
category: memory
difficulty: intermediate
tags: [zig, memory, allocation]
keywords: [allocator, free, create, destroy]
use_cases: [heap allocation]
prerequisites: ["zig.basics.pointers"]
related: ["zig.memory.management.allocators"]
next_topics: ["zig.memory.management.allocators"]
---

# Manual Memory

Zig has no hidden allocations. All heap allocation requires an `Allocator`.

## Core Philosophy

- If a function allocates, it takes an `allocator` parameter.
- You must manually `free` what you allocate (usually with `defer`).

```zig
const ptr = try allocator.create(i32);
defer allocator.destroy(ptr);
```
