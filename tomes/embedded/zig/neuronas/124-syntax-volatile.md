---
id: "zig.syntax.volatile"
title: "Volatile"
category: syntax
difficulty: advanced
tags: [zig, syntax, hardware]
keywords: [volatile, mmio]
use_cases: [memory mapped io]
prerequisites: ["zig.basics.pointers"]
related: ["zig.basics.pointers"]
next_topics: []
---

# Volatile

Prevents compiler from optimizing reads/writes. Essential for hardware registers.

```zig
const ptr: *volatile u8 = @ptrFromInt(0x4000);
ptr.* = 1;
```
