---
# TIER 1: ESSENTIAL
id: "cpp.stl.list"
title: "std::list"
tags: [cpp, stl, list, containers, intermediate]
links: ["cpp.stl.vector", "cpp.stl.deque"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [list, linked-list, container, sequence]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.forward-list", "cpp.stl.deque"]
related:
  - id: "cpp.stl.vector"
    type: alternative
    weight: 75
  - id: "cpp.stl.deque"
    type: similar
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::list

`std::list` is a doubly-linked list with efficient insertion/deletion anywhere.

## Basic Usage

```cpp
#include <list>

std::list<int> lst;
lst.push_back(10);
lst.push_front(5);
// lst = [5, 10]
```

## Common Operations

```cpp
std::list<int> lst = {1, 2, 3, 4, 5};

lst.push_back(6);    // [1, 2, 3, 4, 5, 6]
lst.push_front(0);    // [0, 1, 2, 3, 4, 5, 6]
lst.pop_back();       // [0, 1, 2, 3, 4, 5]
lst.pop_front();      // [1, 2, 3, 4, 5]

lst.front();  // 1
lst.back();   // 5
```

## Insert and Erase

```cpp
std::list<int> lst = {1, 2, 4, 5};

auto it = lst.begin();
std::advance(it, 2);  // Move iterator to position 2

lst.insert(it, 3);  // [1, 2, 3, 4, 5]
lst.erase(it);       // [1, 2, 3, 5]
```

## List-Specific Operations

```cpp
std::list<int> lst1 = {1, 2, 3};
std::list<int> lst2 = {4, 5, 6};

// Splice - move elements between lists
lst1.splice(lst1.end(), lst2);
// lst1 = [1, 2, 3, 4, 5, 6], lst2 = []

// Sort
std::list<int> lst = {5, 2, 8, 1, 9};
lst.sort();
// lst = [1, 2, 5, 8, 9]

// Remove
lst.remove(5);  // Remove all 5s

// Unique
lst.unique();  // Remove consecutive duplicates
```

## Merge

```cpp
std::list<int> lst1 = {1, 3, 5};
std::list<int> lst2 = {2, 4, 6};

lst1.merge(lst2);  // Assumes both are sorted
// lst1 = [1, 2, 3, 4, 5, 6], lst2 = []
```

## See Also

- [std::forward_list](cpp.stl.forward-list) - Singly-linked list
- [std::vector](cpp.stl.vector) - Dynamic array
