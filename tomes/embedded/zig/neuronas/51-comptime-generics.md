---
id: "zig.comptime.generics"
title: "Generics"
category: comptime
difficulty: intermediate
tags: [zig, comptime, generics, templates]
keywords: [type, function]
use_cases: [reusable types]
prerequisites: ["zig.comptime.basics"]
related: ["zig.comptime.typeinfo"]
next_topics: ["zig.comptime.typeinfo"]
---

# Generics

In Zig, types are values. Functions can take types as arguments.

## Generic Function

```zig
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

const x = max(i32, 1, 2);
```

## Generic Struct

```zig
fn List(comptime T: type) type {
    return struct {
        items: []T,
    };
}

const IntList = List(i32);
```
