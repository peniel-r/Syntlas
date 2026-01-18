---
id: "zig.memory.management.page"
title: "PageAllocator"
category: memory
difficulty: advanced
tags: [zig, memory, pages, os]
keywords: [page_allocator, mmap]
use_cases: [large allocations, backing allocator]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.memory.management.c-allocator"]
next_topics: []
---

# PageAllocator

Asks the OS for entire pages of memory. Very slow for small allocations. Use as a backing allocator for `ArenaAllocator` or `GPA`.

```zig
const allocator = std.heap.page_allocator;
```
