---
id: "zig.build.dependencies"
title: "Package Management"
category: build
difficulty: intermediate
tags: [zig, build, zon, package]
keywords: [build.zig.zon, fetch, dependency]
use_cases: [external libraries]
prerequisites: ["zig.build.modules"]
related: ["zig.build.targets"]
next_topics: []
---

# Package Management

Zig uses `build.zig.zon` for dependencies.

## build.zig.zon

```zig
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = {
        .zap = .{
            .url = "https://github.com/...",
            .hash = "...",
        },
    },
}
```

## build.zig

```zig
const dep = b.dependency("zap", .{});
exe.root_module.addImport("zap", dep.module("zap"));
```
