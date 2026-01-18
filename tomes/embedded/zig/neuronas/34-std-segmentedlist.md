---
id: "zig.std.segmentedlist"
title: "SegmentedList"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, list, segmented]
keywords: [SegmentedList, pointer stability]
use_cases: [stable pointers, growable]
prerequisites: ["zig.std.arraylist"]
related: ["zig.std.arraylist"]
next_topics: []
---

# SegmentedList

Like `ArrayList`, but guarantees pointer stability. Items don't move when the list grows. Access is slower.

```zig
var list = std.SegmentedList(i32, 32).init(allocator);
```
