---
id: "zig.basics.arrays"
title: "Arrays"
category: basics
difficulty: beginner
tags: [zig, basics, arrays]
keywords: [array, len, sentinel]
use_cases: [fixed size collections]
prerequisites: ["zig.basics.assignment"]
related: ["zig.basics.slices"]
next_topics: ["zig.basics.slices"]
---

# Arrays

Fixed-length, contiguous memory.

## Declaration

```zig
const a = [5]i32{ 1, 2, 3, 4, 5 };
const b = [_]u8{ 'h', 'e', 'l', 'l', 'o' }; // Infer length
```

## Access

```zig
const x = a[0];
const len = a.len;
```

## Sentinel-Terminated

```zig
const s = [_:0]u8{ 'h', 'i' }; // Null-terminated
```
