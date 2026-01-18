---
# TIER 1: ESSENTIAL
id: "cpp.stl.tuple"
title: "std::tuple"
tags: [cpp, stl, tuple, containers, intermediate]
links: ["cpp.stl.pair", "cpp.basic.templates"]
hash: "sha256:0000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [tuple, heterogeneous, container, sequence]
prerequisites: ["cpp.basic.templates"]
next: ["cpp.stl.pair", "cpp.modern.type-inference"]
related:
  - id: "cpp.stl.pair"
    type: similar
    weight: 80
  - id: "cpp.modern.type-inference"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::tuple

`std::tuple` stores heterogeneous values of different types.

## Basic Usage

```cpp
#include <tuple>

std::tuple<int, double, std::string> t(42, 3.14, "Hello");
```

## Accessing Elements

```cpp
std::tuple<int, double, std::string> t(42, 3.14, "Hello");

// get<index>()
int i = std::get<0>(t);     // 42
double d = std::get<1>(t);   // 3.14
std::string s = std::get<2>(t); // "Hello"
```

## Creating Tuples

```cpp
// Using std::make_tuple
auto t = std::make_tuple(1, 3.14, "Hello");

// Using constructor
std::tuple<int, double, std::string> t2(1, 3.14, "World");

// Using brace initialization (C++17)
std::tuple t3(1, 3.14, "Test");
```

## Tuple Size

```cpp
std::tuple<int, double, std::string> t;

size_t size = std::tuple_size<decltype(t)>::value;  // 3
```

## Structured Bindings (C++17)

```cpp
auto t = std::make_tuple(42, 3.14, "Hello");

auto [i, d, s] = t;
std::cout << i << " " << d << " " << s << std::endl;
// 42 3.14 Hello
```

## Concatenating Tuples

```cpp
auto t1 = std::make_tuple(1, 2);
auto t2 = std::make_tuple(3.14, "Hello");

auto combined = std::tuple_cat(t1, t2);
// combined = (1, 2, 3.14, "Hello")
```

## See Also

- [std::pair](cpp.stl.pair) - Two-element tuple
- [Structured Bindings](cpp.modern.type-inference) - Tuple unpacking
