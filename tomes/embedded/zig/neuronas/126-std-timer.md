---
id: "zig.std.timer"
title: "Timer"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, time, timer]
keywords: [Timer, lap, read, start]
use_cases: [benchmarking]
prerequisites: ["zig.std.time"]
related: ["zig.std.time"]
next_topics: []
---

# Timer

Monotonic timer for measuring duration.

```zig
var timer = try std.time.Timer.start();
// ... work ...
const ns = timer.read();
const lap = timer.lap();
```
