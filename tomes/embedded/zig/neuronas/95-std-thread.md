---
id: "zig.std.thread"
title: "Threads"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, thread, concurrency]
keywords: [Thread, spawn, join, mutex]
use_cases: [parallelism]
prerequisites: ["zig.basics.functions"]
related: ["zig.std.atomics"]
next_topics: []
---

# Threads

Spawning OS threads.

## Usage

```zig
fn worker(x: i32) void { ... }

const t = try std.Thread.spawn(.{}, worker, .{123});
t.join();
```
