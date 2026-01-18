---
id: "zig.build.c-source"
title: "Compiling C Source"
category: build
difficulty: intermediate
tags: [zig, build, c, compilation]
keywords: [addCSourceFile, addIncludePath]
use_cases: [mixed c/zig projects]
prerequisites: ["zig.build.basics"]
related: ["zig.interop.cimport"]
next_topics: []
---

# Compiling C Source

Zig is also a C compiler.

```zig
exe.addCSourceFile(.{ .file = b.path("src/foo.c"), .flags = &.{} });
exe.addIncludePath(b.path("include"));
exe.linkLibC();
```
