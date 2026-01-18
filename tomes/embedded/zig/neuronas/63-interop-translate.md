---
id: "zig.interop.translate"
title: "Translate C"
category: interop
difficulty: intermediate
tags: [zig, interop, toolchain]
keywords: [zig translate-c]
use_cases: [porting c code, inspecting macros]
prerequisites: ["zig.interop.cimport"]
related: ["zig.interop.cimport"]
next_topics: []
---

# Translate C

Use the CLI tool to see how Zig views C code.

```bash
zig translate-c main.c
```

This is useful for debugging macros or complex typedefs.
