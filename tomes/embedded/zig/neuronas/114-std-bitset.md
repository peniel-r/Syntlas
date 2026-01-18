---
id: "zig.std.bitset"
title: "BitSet"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, bitset, flags]
keywords: [BitSet, set, unset]
use_cases: [compact booleans]
prerequisites: ["zig.basics.values"]
related: ["zig.std.arraylist"]
next_topics: []
---

# BitSet

## Dynamic

```zig
var bits = try std.DynamicBitSet.initEmpty(allocator, 100);
defer bits.deinit();
bits.set(10);
```

## Static

```zig
var bits = std.StaticBitSet(100).initEmpty();
bits.set(10);
```
