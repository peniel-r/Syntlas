---
id: "zig.syntax.anytype"
title: "AnyType"
category: syntax
difficulty: advanced
tags: [zig, syntax, generics, duck-typing]
keywords: [anytype, inference]
use_cases: [generic parameters]
prerequisites: ["zig.comptime.generics"]
related: ["zig.comptime.generics"]
next_topics: []
---

# AnyType

Duck typing for function arguments. The compiler infers the type at usage and generates a specialized function.

```zig
fn print(val: anytype) void {
    std.debug.print("{any}", .{val});
}
```
