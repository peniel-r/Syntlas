---
id: "cpp.modern.consteval"
title: "consteval (C++20)"
category: modern
difficulty: intermediate
tags: [cpp, modern, consteval, immediate]
keywords: [consteval, immediate function]
use_cases: [guaranteed compile-time execution]
prerequisites: ["cpp.modern.constexpr"]
related: ["cpp.modern.constexpr"]
next_topics: []
---

# consteval

`consteval` declares an "immediate function". It **must** produce a constant expression at compile time. Unlike `constexpr`, it cannot execute at runtime.

## Usage

```cpp
consteval int sqr(int n) {
    return n * n;
}

int main() {
    int x = 10;
    // int y = sqr(x); // Error: x is not a constant
    int z = sqr(10);   // OK: 10 is constant
}
```
