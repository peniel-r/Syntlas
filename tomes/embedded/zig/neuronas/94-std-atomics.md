---
id: "zig.std.atomics"
title: "Atomics"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, atomic, concurrency]
keywords: [atomic, load, store, cmpxchg]
use_cases: [lock-free data structures, synchronization]
prerequisites: ["zig.basics.pointers"]
related: ["zig.std.thread"]
next_topics: []
---

# Atomics

Zig provides `std.atomic`.

## Usage

```zig
var x = std.atomic.Value(i32).init(0);
const old = x.fetchAdd(1, .Monotonic);
```
