---
id: "zig.std.ringbuffer"
title: "RingBuffer"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, buffer, ring]
keywords: [RingBuffer, write, read]
use_cases: [streams, queues]
prerequisites: ["zig.basics.arrays"]
related: ["zig.std.arraylist"]
next_topics: []
---

# RingBuffer

Circular buffer.

```zig
var rb = try std.RingBuffer.init(allocator, 1024);
defer rb.deinit();

try rb.writeSlice("data");
```
