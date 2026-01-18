---
id: "zig.build.modules"
title: "Modules and Packages"
category: build
difficulty: intermediate
tags: [zig, build, modules, dependencies]
keywords: [addModule, dependency, import]
use_cases: [library management]
prerequisites: ["zig.build.basics"]
related: ["zig.build.dependencies"]
next_topics: ["zig.build.dependencies"]
---

# Modules

Modules are units of code compilation.

## Adding a Module

```zig
const mod = b.addModule("my-lib", .{
    .root_source_file = b.path("libs/my-lib/src/root.zig"),
});

exe.root_module.addImport("my-lib", mod);
```
