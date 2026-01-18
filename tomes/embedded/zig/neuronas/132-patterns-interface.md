---
id: "zig.patterns.interface"
title: "Interface Pattern"
category: patterns
difficulty: advanced
tags: [zig, patterns, interface, vtable]
keywords: [vtable, tagged union]
use_cases: [polymorphism]
prerequisites: ["zig.basics.pointers"]
related: ["zig.types.structs"]
next_topics: []
---

# Interface Pattern

Zig uses vtables or tagged unions for polymorphism.

## VTable Approach

```zig
const Reader = struct {
    ptr: *anyopaque,
    readFn: *const fn(ptr: *anyopaque, buf: []u8) anyerror!usize,

    fn read(self: Reader, buf: []u8) !usize {
        return self.readFn(self.ptr, buf);
    }
};
```
