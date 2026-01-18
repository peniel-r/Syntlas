---
id: "zig.std.arraylist"
title: "ArrayList"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, collection, arraylist]
keywords: [ArrayList, append, items]
use_cases: [dynamic array]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.std.hashmap"]
next_topics: ["zig.std.hashmap"]
---

# ArrayList

Growable array.

## Usage

```zig
var list = std.ArrayList(i32).init(allocator);
defer list.deinit();

try list.append(10);
try list.append(20);

// Access slice
const slice = list.items;
```
