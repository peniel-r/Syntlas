---
id: "zig.basics.functions"
title: "Functions"
category: basics
difficulty: beginner
tags: [zig, basics, functions]
keywords: [fn, return, pub]
use_cases: [code structure]
prerequisites: ["zig.basics.values"]
related: ["zig.basics.defer"]
next_topics: ["zig.basics.defer"]
---

# Functions

Functions are declared with `fn`.

## Usage

```zig
fn add(a: i32, b: i32) i32 {
    return a + b;
}
```

## Parameters

Parameters are immutable (conceptually `const`).

## Visibility

Use `pub` to make functions visible to other files.

```zig
pub fn main() void {
    // ...
}
```
