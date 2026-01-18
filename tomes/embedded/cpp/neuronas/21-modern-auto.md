---
# TIER 1: ESSENTIAL
id: "cpp.modern.type-inference"
title: "Type Inference with auto"
tags: [cpp, modern, auto, beginner]
links: ["cpp.basic.variables", "cpp.basic.templates"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [auto, decltype, type-deduction, template]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.modern.lambdas", "cpp.modern.ranges"]
related:
  - id: "cpp.meta.decltype"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Type Inference with auto

`auto` lets the compiler deduce types automatically.

## Basic auto Usage

```cpp
auto x = 42;              // int
auto y = 3.14;            // double
auto z = "Hello";           // const char*
auto v = std::vector<int>(); // std::vector<int>
```

## auto with References

```cpp
int value = 42;
auto a = value;          // int (copy)
auto& b = value;         // int& (reference)
const auto& c = value;   // const int& (read-only)
```

## auto in Range-Based For

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// By value (copy)
for (auto x : v) {
    std::cout << x << " ";
}

// By reference (modify original)
for (auto& x : v) {
    x *= 2;
}

// By const reference (read-only)
for (const auto& x : v) {
    std::cout << x << " ";
}
```

## auto with Function Return Types

```cpp
// C++14 return type deduction
auto add(int a, int b) {
    return a + b;  // Deduced as int
}

// Trailing return type (C++11)
template<typename T, typename U>
auto add(T a, U b) -> decltype(a + b) {
    return a + b;
}
```

## decltype

```cpp
int x = 42;
decltype(x) y = 10;  // y is int

// With expressions
decltype(x + 1) z = 53;  // z is int
```

## auto in Structured Bindings (C++17)

```cpp
std::pair<int, std::string> p(42, "Hello");

auto [num, text] = p;
// num = 42, text = "Hello"
```

## See Also

- [Lambdas](cpp.modern.lambdas) - auto in lambda parameters
- [Concepts](cpp.modern.concepts) - Constrained auto (C++20)
