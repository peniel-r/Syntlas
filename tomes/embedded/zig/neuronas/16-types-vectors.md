---
id: "zig.types.vectors"
title: "Vectors (SIMD)"
category: types
difficulty: advanced
tags: [zig, types, simd, vector]
keywords: [@Vector, simd]
use_cases: [performance, math]
prerequisites: ["zig.basics.arrays"]
related: ["zig.basics.arrays"]
next_topics: []
---

# Vectors

SIMD vectors. Not to be confused with `std.ArrayList`.

## Usage

```zig
const v1 = @Vector(4, i32){ 1, 2, 3, 4 };
const v2 = @Vector(4, i32){ 5, 6, 7, 8 };

// Element-wise addition
const sum = v1 + v2; // { 6, 8, 10, 12 }
```

Length must be comptime known.
