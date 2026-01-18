---
# TIER 1: ESSENTIAL
id: "cpp.stl.array"
title: "std::array"
tags: [cpp, stl, array, containers, beginner]
links: ["cpp.basic.arrays", "cpp.stl.vector"]
hash: "sha256:0000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [array, fixed-size, container, sequence]
prerequisites: ["cpp.basic.arrays"]
next: ["cpp.stl.vector", "cpp.stl.deque"]
related:
  - id: "cpp.stl.vector"
    type: similar
    weight: 85
  - id: "cpp.basic.arrays"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::array

`std::array` is a fixed-size container with stack allocation.

## Basic Usage

```cpp
#include <array>

std::array<int, 5> arr = {1, 2, 3, 4, 5};
```

## Accessing Elements

```cpp
std::array<int, 5> arr = {10, 20, 30, 40, 50};

arr[0];        // 10 (no bounds check)
arr.at(1);      // 20 (with bounds check)
arr.front();     // 10 (first element)
arr.back();      // 50 (last element)
```

## Size and Iteration

```cpp
std::array<int, 5> arr = {1, 2, 3, 4, 5};

arr.size();     // 5
arr.empty();    // false

// Range-based for
for (int x : arr) {
    std::cout << x << " ";
}
```

## Iterators

```cpp
std::array<int, 5> arr = {1, 2, 3, 4, 5};

auto it = arr.begin();
auto end = arr.end();

for (auto it = arr.begin(); it != arr.end(); ++it) {
    std::cout << *it << " ";
}
```

## C-Style Array Access

```cpp
std::array<int, 5> arr = {1, 2, 3, 4, 5};

int* ptr = arr.data();  // Pointer to underlying array
ptr[0] = 100;      // Modify through pointer
```

## Fill and Swap

```cpp
std::array<int, 5> arr = {1, 2, 3, 4, 5};
std::array<int, 5> arr2 = {0};

arr.fill(0);  // [0, 0, 0, 0, 0]

arr.swap(arr2);  // Swap contents
```

## See Also

- [std::vector](cpp.stl.vector) - Dynamic array
- [C Arrays](cpp.basic.arrays) - Built-in arrays
