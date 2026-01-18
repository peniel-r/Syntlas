---
id: "zig.syntax.align"
title: "Alignment"
category: syntax
difficulty: advanced
tags: [zig, syntax, memory, layout]
keywords: [align, alignment]
use_cases: [hardware requirements, simd]
prerequisites: ["zig.basics.pointers"]
related: ["zig.types.vectors"]
next_topics: []
---

# Alignment

Specifying memory alignment.

```zig
const x: i32 align(16) = 123;
```

Pointers also carry alignment info.

```zig
const ptr: *align(4) i32 = ...;
```
