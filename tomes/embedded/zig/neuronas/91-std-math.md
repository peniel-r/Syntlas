---
id: "zig.std.math"
title: "Math"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, math, numeric]
keywords: [math, sqrt, pow, sin]
use_cases: [calculations]
prerequisites: ["zig.basics.values"]
related: ["zig.std.random"]
next_topics: []
---

# Math

`std.math` contains standard mathematical functions.

```zig
const x = std.math.sqrt(16.0);
const y = std.math.pow(f32, 2.0, 3.0);
```

Also includes constants like `std.math.pi`.
