---
# TIER 1: ESSENTIAL
id: "cpp.stl.set"
title: "std::set"
tags: [cpp, stl, set, containers, beginner]
links: ["cpp.stl.vector", "cpp.stl.map"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [set, unique, ordered, associative]
prerequisites: ["cpp.stl.vector"]
next: ["cpp.stl.unordered-set", "cpp.stl.algorithm"]
related:
  - id: "cpp.stl.map"
    type: similar
    weight: 70
  - id: "cpp.stl.unordered-set"
    type: alternative
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::set

`std::set` stores unique elements in sorted order.

## Basic Usage

```cpp
#include <set>

std::set<int> s;
s.insert(10);
s.insert(20);
s.insert(10);  // Duplicate, not inserted

std::cout << s.size() << std::endl;  // 2
```

## Initialization

```cpp
std::set<int> s = {10, 20, 30, 10};
// s = {10, 20, 30}  (duplicates removed)
```

## Checking Existence

```cpp
std::set<int> s = {10, 20, 30};

if (s.find(20) != s.end()) {
    std::cout << "20 exists" << std::endl;
}

if (s.count(40) > 0) {
    std::cout << "40 exists" << std::endl;
} else {
    std::cout << "40 doesn't exist" << std::endl;
}
```

## Iterating

```cpp
std::set<int> s = {30, 10, 20};

// Iterates in sorted order: 10, 20, 30
for (int x : s) {
    std::cout << x << " ";
}
```

## Operations

```cpp
std::set<int> s = {10, 20, 30};

s.insert(40);          // Insert element
s.erase(20);           // Remove element
s.size();              // Number of elements
s.empty();             // Check if empty
s.clear();             // Remove all elements
s.lower_bound(15);     // First element >= 15
s.upper_bound(25);     // First element > 25
```

## Custom Comparator

```cpp
// Descending order
struct Descending {
    bool operator()(int a, int b) const {
        return a > b;
    }
};

std::set<int, Descending> s = {10, 20, 30};
// Iterates: 30, 20, 10
```

## See Also

- [std::unordered_set](cpp.stl.unordered-set) - Hash-based set (faster, unordered)
- [std::map](cpp.stl.map) - Key-value pairs
