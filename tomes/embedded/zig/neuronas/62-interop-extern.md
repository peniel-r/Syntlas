---
id: "zig.interop.extern"
title: "Extern"
category: interop
difficulty: intermediate
tags: [zig, interop, extern, linkage]
keywords: [extern, export]
use_cases: [linking, exporting symbols]
prerequisites: ["zig.interop.ctypes"]
related: ["zig.build.basics"]
next_topics: []
---

# Extern

Declaring functions implemented elsewhere (usually C).

```zig
extern "c" fn puts(s: [*c]const u8) c_int;
```

# Export

Making Zig functions available to C.

```zig
export fn add(a: i32, b: i32) i32 {
    return a + b;
}
```
