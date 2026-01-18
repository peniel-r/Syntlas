---
id: "zig.types.unions"
title: "Unions"
category: types
difficulty: intermediate
tags: [zig, types, unions, tagged]
keywords: [union, tag, switch]
use_cases: [variants, memory overlap]
prerequisites: ["zig.types.enums"]
related: ["zig.types.error-unions"]
next_topics: ["zig.types.error-unions"]
---

# Unions

Unions hold one active field at a time.

## Bare Union

Unsafe memory overlap.

```zig
const Payload = union {
    int: i64,
    float: f64,
};
```

## Tagged Union

Safe, essentially a "sum type" or "variant".

```zig
const Tagged = union(enum) {
    int: i64,
    float: f64,
    none: void,
};

const t = Tagged{ .int = 42 };
switch (t) {
    .int => |val| {},
    .float => |val| {},
    .none => {},
}
```
