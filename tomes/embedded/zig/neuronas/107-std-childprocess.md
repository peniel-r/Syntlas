---
id: "zig.std.childprocess"
title: "Child Process"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, subprocess, exec]
keywords: [ChildProcess, spawn, run]
use_cases: [running external commands]
prerequisites: ["zig.std.process"]
related: ["zig.std.process"]
next_topics: []
---

# Child Process

Spawning external commands.

```zig
const result = try std.process.Child.run(.{
    .allocator = allocator,
    .argv = &[_][]const u8{ "ls", "-l" },
});
defer allocator.free(result.stdout);
```
