---
# TIER 1: ESSENTIAL
id: "cpp.stl.forward-list"
title: "std::forward_list"
tags: [cpp, stl, forward-list, containers, intermediate]
links: ["cpp.stl.list", "cpp.stl.deque"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [forward-list, singly-linked, container, sequence]
prerequisites: ["cpp.stl.list"]
next: ["cpp.stl.list", "cpp.stl.vector"]
related:
  - id: "cpp.stl.list"
    type: similar
    weight: 85
  - id: "cpp.stl.deque"
    type: alternative
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::forward_list

`std::forward_list` is a singly-linked list with efficient insertion/deletion.

## Basic Usage

```cpp
#include <forward_list>

std::forward_list<int> fl;
fl.push_front(10);
fl.push_front(5);
// fl = [5, 10]
```

## Common Operations

```cpp
std::forward_list<int> fl = {1, 2, 3, 4, 5};

fl.push_front(0);  // [0, 1, 2, 3, 4, 5]
fl.pop_front();     // [1, 2, 3, 4, 5]

fl.front();  // 1
```

## Insert After

```cpp
std::forward_list<int> fl = {1, 3, 4};

auto it = fl.begin();
fl.insert_after(it, 2);  // [1, 2, 3, 4]
```

## Erase After

```cpp
std::forward_list<int> fl = {1, 2, 3, 4};

auto it = fl.begin();
fl.erase_after(it);  // [1, 3, 4]
```

## No size() method

```cpp
std::forward_list<int> fl = {1, 2, 3};

// No size() method - must count manually
size_t count = std::distance(fl.begin(), fl.end());
```

## vs std::list

```cpp
// std::forward_list: Less memory, no back() or size()
std::forward_list<int> fl;

// std::list: More memory, bidirectional, has back() and size()
std::list<int> lst;
```

## See Also

- [std::list](cpp.stl.list) - Doubly-linked list
- [std::vector](cpp.stl.vector) - Dynamic array
