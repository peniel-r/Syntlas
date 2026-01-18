---
id: "zig.std.hashmap"
title: "AutoHashMap"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, map, hashmap]
keywords: [AutoHashMap, put, get]
use_cases: [key-value storage]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.std.stringhashmap"]
next_topics: ["zig.std.stringhashmap"]
---

# AutoHashMap

Hash map that automatically hashes keys.

## Usage

```zig
var map = std.AutoHashMap(i32, f32).init(allocator);
defer map.deinit();

try map.put(1, 1.5);
const val = map.get(1); // ?f32
```
