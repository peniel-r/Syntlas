---
id: "zig.basics.assignment"
title: "Assignment (const vs var)"
category: basics
difficulty: beginner
tags: [zig, basics, assignment, mutability]
keywords: [const, var, undefined]
use_cases: [variable declaration]
prerequisites: ["zig.basics.values"]
related: ["zig.basics.values"]
next_topics: ["zig.basics.arrays"]
---

# Assignment

Zig requires explicit mutability.

## const

Immutable. Preferred default.

```zig
const x = 1234;
// x = 5; // Error
```

## var

Mutable.

```zig
var y: i32 = 5678;
y += 1;
```

## undefined

Zig requires all variables to be initialized. Use `undefined` if you strictly mean to leave it uninitialized (dangerous).

```zig
var x: i32 = undefined;
x = 1;
```
