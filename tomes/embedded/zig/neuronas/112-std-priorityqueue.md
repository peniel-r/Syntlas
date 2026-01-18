---
id: "zig.std.priorityqueue"
title: "PriorityQueue"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, collection, heap]
keywords: [PriorityQueue, add, remove]
use_cases: [ordering tasks]
prerequisites: ["zig.std.arraylist"]
related: ["zig.std.arraylist"]
next_topics: []
---

# PriorityQueue

Min/Max heap.

```zig
var pq = std.PriorityQueue(i32, void, std.sort.asc(i32)).init(allocator, {});
defer pq.deinit();

try pq.add(10);
const min = pq.remove();
```
