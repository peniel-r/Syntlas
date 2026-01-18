---
id: "zig.basics.comptime-int"
title: "comptime_int"
category: basics
difficulty: beginner
tags: [zig, types, comptime]
keywords: [comptime_int, literal]
use_cases: [constants]
prerequisites: ["zig.basics.values"]
related: ["zig.basics.values"]
next_topics: []
---

# comptime_int

Integer literals in Zig are `comptime_int`. They have arbitrary precision but must fit into a runtime type eventually.

```zig
const x = 12345; // comptime_int
const y: u8 = x; // Error if x > 255
```
