---
# TIER 1: ESSENTIAL
id: "cpp.modern.concepts"
title: "Concepts"
tags: [cpp, modern, concepts, advanced]
links: ["cpp.basic.templates", "cpp.modern.type-inference"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: advanced
keywords: [concept, requires, template-constraint, c++20]
prerequisites: ["cpp.basic.templates"]
next: ["cpp.modern.ranges", "cpp.modern.coroutines"]
related:
  - id: "cpp.basic.templates"
    type: complement
    weight: 90
version:
  minimum: "C++20"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Concepts (C++20)

Concepts specify requirements for template arguments, improving error messages and enabling better overloads.

## Basic Concept Definition

```cpp
template<typename T>
concept Integral = std::is_integral_v<T>;

template<Integral T>
T add(T a, T b) {
    return a + b;
}

add(1, 2);      // OK
add(1.5, 2.5);  // Error: double is not Integral
```

## Using requires Clause

```cpp
template<typename T>
requires std::is_integral_v<T>
T multiply(T a, T b) {
    return a * b;
}

// Or as a trailing requires
template<typename T>
T multiply2(T a, T b) requires std::is_integral_v<T> {
    return a * b;
}
```

## Combining Concepts

```cpp
// AND
template<typename T>
concept Number = std::is_integral_v<T> || std::is_floating_point_v<T>;

// OR
template<typename T>
concept Addable = requires(T a, T b) {
    a + b;  // Must support addition
};
```

## Standard Concepts

```cpp
#include <concepts>

std::integral auto x = 42;           // Must be integral
std::floating_point auto y = 3.14;   // Must be floating point
std::copyable auto z = x;           // Must be copyable

// With containers
template<std::ranges::range R>
void print(R&& r) {
    for (auto&& elem : r) {
        std::cout << elem << " ";
    }
}
```

## Auto with Concepts

```cpp
// Constrained auto
std::integral auto value = 42;

// In function parameters
void process(std::integral auto x) {
    std::cout << x << std::endl;
}
```

## See Also

- [Templates](cpp.basic.templates) - Template basics
- [Ranges](cpp.modern.ranges) - Modern iteration (C++20)
