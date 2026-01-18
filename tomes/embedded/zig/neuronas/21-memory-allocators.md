---
id: "zig.memory.allocators"
title: "Allocators Interface"
category: memory
difficulty: intermediate
tags: [zig, memory, interface]
keywords: [Allocator, alloc, free]
use_cases: [using memory]
prerequisites: ["zig.memory.management"]
related: ["zig.memory.gpa"]
next_topics: ["zig.memory.gpa"]
---

# Allocator Interface

`std.mem.Allocator` is the interface.

## Methods

- `alloc(T, n)`: Allocate slice of `n` items.
- `create(T)`: Allocate single `T`.
- `free(slice)`: Free slice.
- `destroy(ptr)`: Free single item.

```zig
const slice = try allocator.alloc(u8, 100);
defer allocator.free(slice);
```
