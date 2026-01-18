---
id: "zig.patterns.iterator"
title: "Iterator Pattern"
category: patterns
difficulty: intermediate
tags: [zig, patterns, iterator]
keywords: [next, optional]
use_cases: [custom collections]
prerequisites: ["zig.types.optionals"]
related: ["zig.basics.loops"]
next_topics: []
---

# Iterator Pattern

Zig iterators typically return `?T` (optional). When `null`, iteration stops.

```zig
const Iter = struct {
    count: usize = 0,
    fn next(self: *Iter) ?usize {
        if (self.count > 5) return null;
        self.count += 1;
        return self.count;
    }
};

while (iter.next()) |val| {
    // ...
}
```
