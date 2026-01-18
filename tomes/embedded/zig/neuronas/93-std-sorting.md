---
id: "zig.std.sorting"
title: "Sorting"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, sort, algorithm]
keywords: [sort, pdqsort]
use_cases: [ordering data]
prerequisites: ["zig.basics.slices"]
related: ["zig.std.arraylist"]
next_topics: []
---

# Sorting

`std.mem.sort` sorts a slice.

## Usage

```zig
var items = [_]i32{ 3, 1, 2 };
std.mem.sort(i32, &items, {}, std.sort.asc(i32));
```
