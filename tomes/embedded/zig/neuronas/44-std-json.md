---
id: "zig.std.json"
title: "JSON"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, json, serialization]
keywords: [json, stringify, parse]
use_cases: [data exchange]
prerequisites: ["zig.std.io"]
related: ["zig.std.io"]
next_topics: []
---

# JSON

Parsing and stringifying.

## Parse

```zig
const parsed = try std.json.parseFromSlice(MyStruct, allocator, json_str, .{});
defer parsed.deinit();
```

## Stringify

```zig
try std.json.stringify(obj, .{}, writer);
```
