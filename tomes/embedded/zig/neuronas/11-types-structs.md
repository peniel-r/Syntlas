---
id: "zig.types.structs"
title: "Structs"
category: types
difficulty: beginner
tags: [zig, types, structs, data]
keywords: [struct, packed, extern]
use_cases: [data aggregation, objects]
prerequisites: ["zig.basics.values"]
related: ["zig.types.enums"]
next_topics: ["zig.types.enums"]
---

# Structs

Structs group fields. They can also have methods (namespaced functions).

## Definition

```zig
const Point = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Point {
        return Point{ .x = x, .y = y };
    }
};
```

## Initialization

```zig
const p = Point{ .x = 1.0, .y = 2.0 };
```

## Defaults

```zig
const Config = struct {
    port: u16 = 8080,
};
```
