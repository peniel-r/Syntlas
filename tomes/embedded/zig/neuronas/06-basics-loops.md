---
id: "zig.basics.loops"
title: "Loops (while/for)"
category: basics
difficulty: beginner
tags: [zig, basics, loops, iteration]
keywords: [while, for, continue, break]
use_cases: [iteration]
prerequisites: ["zig.basics.assignment"]
related: ["zig.basics.slices"]
next_topics: []
---

# Loops

## While

```zig
var i: usize = 0;
while (i < 10) : (i += 1) {
    if (i == 5) continue;
}
```

## For

Iterates over slices/arrays.

```zig
const items = [_]i32{ 1, 2, 3 };
for (items) |item| {
    // item is copy
}

for (items, 0..) |item, index| {
    // with index
}
```
