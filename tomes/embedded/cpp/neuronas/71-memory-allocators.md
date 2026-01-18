---
id: "cpp.memory.allocators"
title: "Allocators"
category: memory
difficulty: expert
tags: [cpp, memory, allocators, stdlib]
keywords: [allocator, pmr, polymorphic_allocator]
use_cases: [custom memory strategy, performance tuning]
prerequisites: ["cpp.memory.new-delete"]
related: ["cpp.stl.vector"]
next_topics: []
---

# Allocators

Strategies for memory allocation used by STL containers.

## std::allocator

The default allocator using `new`/`delete`.

## std::pmr (Polymorphic Memory Resources) (C++17)

Allows changing allocation strategy at runtime.

```cpp
#include <vector>
#include <memory_resource>

char buffer[1024];
std::pmr::monotonic_buffer_resource res(buffer, sizeof(buffer));
std::pmr::vector<int> vec(&res);
```
