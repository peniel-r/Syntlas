---
id: "zig.basics.pointers"
title: "Pointers"
category: basics
difficulty: intermediate
tags: [zig, basics, pointers]
keywords: [pointer, single-item, multi-item]
use_cases: [memory references]
prerequisites: ["zig.basics.slices"]
related: ["zig.basics.slices"]
next_topics: []
---

# Pointers

Zig pointers are strict.

## Single-Item Pointer (`*T`)

Points to exactly one item. No arithmetic allowed.

```zig
var x: i32 = 10;
const ptr: *i32 = &x;
ptr.* += 1;
```

## Multi-Item Pointer (`[*]T`)

Points to unknown number of items. Arithmetic allowed.

```zig
const ptr: [*]u8 = buffer.ptr;
const byte = ptr[5];
```

## Sentinel-Terminated (`[*:0]u8`)

Common for C strings.
