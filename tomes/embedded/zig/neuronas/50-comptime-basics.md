---
id: "zig.comptime.basics"
title: "Comptime Basics"
category: comptime
difficulty: intermediate
tags: [zig, comptime, compile-time]
keywords: [comptime, const]
use_cases: [metaprogramming]
prerequisites: ["zig.basics.values"]
related: ["zig.comptime.generics"]
next_topics: ["zig.comptime.generics"]
---

# Comptime Basics

Code that runs at compile time.

## Comptime Variables

```zig
comptime var x = 0;
x += 1;
```

## Comptime Blocks

```zig
comptime {
    // This runs during compilation
}
```
