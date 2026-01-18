---
id: "zig.std.heap"
title: "Heap"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, heap, memory]
keywords: [heap, page_size]
use_cases: [low level memory info]
prerequisites: ["zig.memory.management"]
related: ["zig.memory.management"]
next_topics: []
---

# Heap

Raw heap utilities.

```zig
const size = std.heap.page_size_min;
```
