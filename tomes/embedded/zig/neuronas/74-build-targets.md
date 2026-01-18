---
id: "zig.build.targets"
title: "Cross Compilation"
category: build
difficulty: intermediate
tags: [zig, build, cross-compile, targets]
keywords: [target, cpu, os, abi]
use_cases: [multi-platform builds]
prerequisites: ["zig.build.basics"]
related: ["zig.build.basics"]
next_topics: []
---

# Cross Compilation

Zig makes cross-compilation trivial.

```bash
zig build -Dtarget=x86_64-windows
zig build -Dtarget=aarch64-linux
```

## In build.zig

The `target` option passed to `standardTargetOptions` handles this automatically.
