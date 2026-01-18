---
# TIER 1: ESSENTIAL
id: "cpp.modern.ranges"
title: "Ranges (C++20)"
tags: [cpp, modern, ranges, advanced]
links: ["cpp.stl.algorithm", "cpp.stl.iterator"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: advanced
keywords: [range, view, pipe, c++20]
prerequisites: ["cpp.stl.algorithm", "cpp.stl.iterator"]
next: ["cpp.modern.concepts", "cpp.threads.basic"]
related:
  - id: "cpp.stl.algorithm"
    type: alternative
    weight: 85
version:
  minimum: "C++20"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Ranges (C++20)

Ranges provide a composable way to work with sequences of elements.

## Basic Range Operations

```cpp
#include <ranges>
#include <vector>

std::vector<int> v = {1, 2, 3, 4, 5, 6};

// Filter even numbers
auto evens = v | std::views::filter([](int x) {
    return x % 2 == 0;
});

// Transform
auto squared = v | std::views::transform([](int x) {
    return x * 2;
});
```

## Chaining Views

```cpp
std::vector<int> v = {1, 2, 3, 4, 5, 6};

// Filter even, then square
auto result = v 
    | std::views::filter([](int x) { return x % 2 == 0; })
    | std::views::transform([](int x) { return x * 2; });

for (int x : result) {
    std::cout << x << " ";  // 4 8 12
}
```

## Common Views

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Take first 3 elements
auto take3 = v | std::views::take(3);  // 1, 2, 3

// Drop first 2 elements
auto drop2 = v | std::views::drop(2);  // 3, 4, 5

// Reverse
auto reversed = v | std::views::reverse;  // 5, 4, 3, 2, 1

// Keys from map
std::map<int, std::string> m = {{1, "a"}, {2, "b"}};
auto keys = m | std::views::keys;  // 1, 2

// Values from map
auto values = m | std::views::values;  // "a", "b"
```

## Range-Based Algorithms

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Range-based find
auto it = std::ranges::find(v, 3);

// Range-based sort
std::ranges::sort(v);

// Range-based count
int count = std::ranges::count(v, 2);
```

## See Also

- [STL Algorithms](cpp.stl.algorithm) - Traditional algorithms
- [Concepts](cpp.modern.concepts) - Range constraints
