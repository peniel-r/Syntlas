---
id: "zig.std.epoch"
title: "Epoch"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, time, epoch]
keywords: [epoch, days, seconds]
use_cases: [date calculation]
prerequisites: ["zig.std.time"]
related: ["zig.std.time"]
next_topics: []
---

# Epoch

Zig has utilities for epoch time.

```zig
const s = std.time.epoch.EpochSeconds{ .secs = 1234567890 };
const day = s.getEpochDay();
```
