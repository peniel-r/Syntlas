---
id: "zig.std.stringhashmap"
title: "StringHashMap"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, map, string]
keywords: [StringHashMap]
use_cases: [string keys]
prerequisites: ["zig.std.hashmap"]
related: ["zig.std.arraylist"]
next_topics: []
---

# StringHashMap

Optimized for string keys (`[]const u8`).

## Usage

```zig
var map = std.StringHashMap(i32).init(allocator);
defer map.deinit();

try map.put("foo", 42);
```
