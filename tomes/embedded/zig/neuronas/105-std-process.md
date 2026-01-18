---
id: "zig.std.process"
title: "Process"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, os, process]
keywords: [args, exit, argsAlloc]
use_cases: [cli args, termination]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.std.env"]
next_topics: ["zig.std.env"]
---

# Process

## Arguments

```zig
const args = try std.process.argsAlloc(allocator);
defer std.process.argsFree(allocator, args);
```

## Exit

```zig
std.process.exit(0);
```
