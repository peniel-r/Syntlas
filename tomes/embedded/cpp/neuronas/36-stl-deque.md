---
# TIER 1: ESSENTIAL
id: "cpp.stl.deque"
title: "std::deque"
tags: [cpp, stl, deque, containers, intermediate]
links: ["cpp.stl.vector", "cpp.stl.queue"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [deque, double-ended, container, sequence]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.queue", "cpp.stl.stack"]
related:
  - id: "cpp.stl.vector"
    type: similar
    weight: 80
  - id: "cpp.stl.queue"
    type: complement
    weight: 75
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::deque

`std::deque` is a double-ended queue with efficient insertion/removal at both ends.

## Basic Usage

```cpp
#include <deque>

std::deque<int> d;
d.push_back(10);  // Add to back: [10]
d.push_front(5);  // Add to front: [5, 10]
```

## Common Operations

```cpp
std::deque<int> d = {1, 2, 3, 4, 5};

d.push_front(0);   // [0, 1, 2, 3, 4, 5]
d.push_back(6);    // [0, 1, 2, 3, 4, 5, 6]
d.pop_front();     // [1, 2, 3, 4, 5, 6]
d.pop_back();      // [1, 2, 3, 4, 5]

d.front();  // 1
d.back();   // 5
d[2];      // 3 (random access)
```

## Size and Capacity

```cpp
std::deque<int> d;

d.empty();    // Check if empty
d.size();     // Number of elements
d.resize(10);  // Resize to 10 elements
d.shrink_to_fit();  // Reduce memory usage
```

## Vector vs Deque

```cpp
// Vector: Fast random access, slow insertion at front
std::vector<int> v;
v.insert(v.begin(), 10);  // O(n)

// Deque: Fast insertion at both ends, slightly slower random access
std::deque<int> d;
d.push_front(10);  // O(1)
```

## See Also

- [std::vector](cpp.stl.vector) - Dynamic array
- [std::queue](cpp.stl.queue) - Queue adapter
