---
id: "zig.memory.management.gpa"
title: "GeneralPurposeAllocator"
category: memory
difficulty: intermediate
tags: [zig, memory, gpa, debug]
keywords: [GeneralPurposeAllocator, leak check]
use_cases: [general usage, debug builds]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.memory.management.arena"]
next_topics: ["zig.memory.management.arena"]
---

# GeneralPurposeAllocator (GPA)

A safe, debug-friendly allocator.

## Usage

```zig
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
defer {
    const deinit_status = gpa.deinit();
    if (deinit_status == .leak) @panic("Memory leak");
}
```

It detects double-frees and leaks.
