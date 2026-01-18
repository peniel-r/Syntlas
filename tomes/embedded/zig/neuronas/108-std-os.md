---
id: "zig.std.os"
title: "OS Primitives"
category: stdlib
difficulty: expert
tags: [zig, stdlib, os, syscalls]
keywords: [linux, windows, syscall]
use_cases: [low level system access]
prerequisites: ["zig.basics.values"]
related: ["zig.std.fs"]
next_topics: []
---

# OS Primitives

Direct access to OS structures.

```zig
if (builtin.os.tag == .linux) {
    // Linux specific
}
```
