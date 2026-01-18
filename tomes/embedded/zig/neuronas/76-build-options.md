---
id: "zig.build.options"
title: "Build Options"
category: build
difficulty: intermediate
tags: [zig, build, options]
keywords: [option, addOptions]
use_cases: [configuration flags]
prerequisites: ["zig.build.basics"]
related: ["zig.build.custom"]
next_topics: []
---

# Build Options

Pass comptime constants from build script to code.

## build.zig

```zig
const options = b.addOptions();
options.addOption(bool, "enable_foo", true);
exe.root_module.addOptions("config", options);
```

## code.zig

```zig
const config = @import("config");
if (config.enable_foo) { ... }
```
