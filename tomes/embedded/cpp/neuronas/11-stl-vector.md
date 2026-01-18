---
# TIER 1: ESSENTIAL
id: "cpp.stl.vector"
title: "std::vector"
tags: [cpp, stl, vector, containers, beginner]
links: ["cpp.basic.arrays", "cpp.stl.iterator"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [vector, dynamic-array, push-back, emplace-back]
prerequisites: ["cpp.basic.arrays", "cpp.basic.templates"]
next: ["cpp.stl.map", "cpp.stl.algorithm"]
related:
  - id: "cpp.stl.array"
    type: similar
    weight: 75
  - id: "cpp.stl.list"
    type: alternative
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::vector

`std::vector` is a dynamic array that automatically resizes itself.

## Basic Usage

```cpp
#include <vector>

std::vector<int> v1;                    // Empty vector
std::vector<int> v2(5);                 // 5 elements, all 0
std::vector<int> v3(5, 42);             // 5 elements, all 42
std::vector<int> v4 = {1, 2, 3, 4, 5}; // Initializer list
```

## Adding Elements

```cpp
std::vector<int> v;

v.push_back(10);    // Add to end: [10]
v.push_back(20);    // Add to end: [10, 20]
v.emplace_back(30); // Construct in place: [10, 20, 30]
```

## Accessing Elements

```cpp
std::vector<int> v = {10, 20, 30};

v[0];           // 10 (no bounds check)
v.at(1);         // 20 (with bounds check)
v.front();        // 10 (first element)
v.back();         // 30 (last element)
```

## Size and Capacity

```cpp
std::vector<int> v;

v.empty();    // true if empty
v.size();     // Number of elements
v.capacity(); // Allocated memory
v.reserve(100); // Reserve memory for 100 elements
v.shrink_to_fit(); // Reduce capacity to size
```

## Iterating

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Index-based
for (size_t i = 0; i < v.size(); i++) {
    std::cout << v[i] << " ";
}

// Range-based for (C++11)
for (int x : v) {
    std::cout << x << " ";
}

// Range-based for with reference
for (int& x : v) {
    x *= 2;  // Modify elements
}
```

## Removing Elements

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

v.pop_back();     // Remove last: [1, 2, 3, 4]
v.erase(v.begin() + 1); // Remove element at index 1: [1, 3, 4]
v.clear();        // Remove all elements
```

## 2D Vectors

```cpp
std::vector<std::vector<int>> matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

matrix[0][1];  // 2
```

## See Also

- [std::array](cpp.stl.array) - Fixed-size array
- [STL Algorithms](cpp.stl.algorithm) - Algorithms for containers
