---
id: "zig.std.path"
title: "Paths"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, fs, path]
keywords: [join, basename, extension]
use_cases: [file paths]
prerequisites: ["zig.std.fs"]
related: ["zig.std.fs"]
next_topics: []
---

# Paths

`std.fs.path` utilities.

```zig
const full = try std.fs.path.join(allocator, &[_][]const u8{ "a", "b", "c.txt" });
defer allocator.free(full);
```
