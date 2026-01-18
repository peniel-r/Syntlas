---
id: "zig.comptime.typeinfo"
title: "Type Info (Reflection)"
category: comptime
difficulty: advanced
tags: [zig, comptime, reflection, typeinfo]
keywords: [@typeInfo, @TypeOf]
use_cases: [serialization, inspection]
prerequisites: ["zig.comptime.generics"]
related: ["zig.comptime.inline"]
next_topics: ["zig.comptime.inline"]
---

# Type Info

Zig has compile-time reflection.

## @typeInfo

Returns a tagged union describing the type.

```zig
const info = @typeInfo(i32);
if (info == .Int) {
    // ...
}
```

## @TypeOf

Returns the type of a value.
