---
id: "zig.types.enums"
title: "Enums"
category: types
difficulty: beginner
tags: [zig, types, enums]
keywords: [enum, tag]
use_cases: [state machines, options]
prerequisites: ["zig.types.structs"]
related: ["zig.types.unions"]
next_topics: ["zig.types.unions"]
---

# Enums

Enumerations with integer tags.

## Usage

```zig
const Color = enum {
    red,
    green,
    blue,
};

const c = Color.red;
```

## Explicit Values

```zig
const Status = enum(u8) {
    ok = 200,
    not_found = 404,
};
```

## Methods

Enums can have methods too.
