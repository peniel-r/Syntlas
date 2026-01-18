---
id: "zig.basics.switch"
title: "Switch Expressions"
category: basics
difficulty: beginner
tags: [zig, basics, control-flow]
keywords: [switch, else, range]
use_cases: [branching, matching]
prerequisites: ["zig.basics.if"]
related: ["zig.basics.if"]
next_topics: []
---

# Switch

Switch must handle all possible values (exhaustive).

## Usage

```zig
const x: i32 = 2;
switch (x) {
    0 => {},
    1, 2 => |val| std.debug.print("1 or 2: {}\n", .{{val}}),
    3...10 => {}, // Range
    else => {},
}
```

## Tagged Unions

Switch is often used with tagged unions.

```
