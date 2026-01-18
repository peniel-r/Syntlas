---
id: "zig.basics.slices"
title: "Slices"
category: basics
difficulty: beginner
tags: [zig, basics, slices]
keywords: [slice, pointer, len]
use_cases: [views into arrays, dynamic length views]
prerequisites: ["zig.basics.arrays"]
related: ["zig.basics.pointers"]
next_topics: ["zig.basics.pointers"]
---

# Slices

A slice is a pointer and a length. `[]T`.

## Creating Slices

```zig
const array = [_]i32{ 1, 2, 3, 4, 5 };
const slice: []const i32 = array[1..4]; // { 2, 3, 4 }
```

## Runtime Bounds Checking

Accessing a slice out of bounds causes a runtime panic (safety).

```zig
// slice[10] // Panic!
```
