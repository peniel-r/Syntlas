---
id: "cpp.modern.constexpr"
title: "constexpr"
category: modern
difficulty: intermediate
tags: [cpp, modern, constexpr, compile-time]
keywords: [constexpr, compile-time, optimization]
use_cases: [compile-time calculation, array sizes, templates]
prerequisites: ["cpp.basics.functions"]
related: ["cpp.modern.consteval"]
next_topics: ["cpp.modern.consteval"]
---

# constexpr

Specifies that the value of a variable or function can be computed at compile time.

## Variables

```cpp
constexpr int max_size = 100;
int arr[max_size]; // OK, size known at compile time
```

## Functions

Functions declared `constexpr` can be executed at compile time if given constant arguments.

```cpp
constexpr int factorial(int n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}

// Computed during compilation
constexpr int val = factorial(5); 
```
