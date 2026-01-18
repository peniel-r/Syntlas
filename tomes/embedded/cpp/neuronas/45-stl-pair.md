---
# TIER 1: ESSENTIAL
id: "cpp.stl.pair"
title: "std::pair"
tags: [cpp, stl, pair, containers, beginner]
links: ["cpp.stl.tuple", "cpp.stl.map"]
hash: "sha256:0000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [pair, two-values, container, sequence]
prerequisites: ["cpp.basic.templates"]
next: ["cpp.stl.tuple", "cpp.stl.map"]
related:
  - id: "cpp.stl.tuple"
    type: similar
    weight: 85
  - id: "cpp.stl.map"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::pair

`std::pair` stores two heterogeneous values.

## Basic Usage

```cpp
#include <utility>

std::pair<int, std::string> p(42, "Hello");
```

## Creating Pairs

```cpp
// Using constructor
std::pair<int, std::string> p1(42, "Hello");

// Using std::make_pair
auto p2 = std::make_pair(42, "Hello");

// Using brace initialization (C++11)
std::pair<int, std::string> p3{42, "World"};
```

## Accessing Elements

```cpp
std::pair<int, std::string> p(42, "Hello");

p.first;   // 42
p.second;  // "Hello"
```

## Structured Bindings (C++17)

```cpp
std::pair<int, std::string> p(42, "Hello");

auto [i, s] = p;
std::cout << i << " " << s << std::endl;
// 42 Hello
```

## Comparison

```cpp
std::pair<int, int> p1(1, 2);
std::pair<int, int> p2(1, 3);

if (p1 < p2) {
    std::cout << "p1 < p2" << std::endl;
}
```

## See Also

- [std::tuple](cpp.stl.tuple) - Multi-element container
- [std::map](cpp.stl.map) - Uses pairs internally
