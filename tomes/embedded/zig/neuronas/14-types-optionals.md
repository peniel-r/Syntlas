---
id: "zig.types.optionals"
title: "Optionals"
category: types
difficulty: beginner
tags: [zig, types, optional, null]
keywords: [?, null, if, orelse]
use_cases: [nullable values]
prerequisites: ["zig.basics.values"]
related: ["zig.types.error-unions"]
next_topics: []
---

# Optionals

A type prefixed with `?` can be `null`.

## Usage

```zig
var x: ?i32 = null;
x = 5;
```

## Unwrapping

```zig
// if capture
if (x) |val| {
    // val is i32
} else {
    // null
}

// orelse
const y = x orelse 0;

// .? (panic if null)
const z = x.?;
```
