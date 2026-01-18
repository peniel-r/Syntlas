---
id: "zig.std.time"
title: "Time"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, time, sleep]
keywords: [time, timestamp, sleep, ns_per_ms]
use_cases: [delays, current time]
prerequisites: ["zig.basics.values"]
related: ["zig.std.timer"]
next_topics: ["zig.std.timer"]
---

# Time

`std.time` utilities.

## Sleep

```zig
std.time.sleep(1 * std.time.ns_per_s);
```

## Timestamp

```zig
const ts = std.time.timestamp(); // Seconds since epoch
const ms = std.time.milliTimestamp();
```
