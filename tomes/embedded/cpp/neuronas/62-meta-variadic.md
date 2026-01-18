---
id: "cpp.meta.variadic"
title: "Variadic Templates"
category: metaprogramming
difficulty: advanced
tags: [cpp, templates, variadic, pack]
keywords: [template, typename..., parameter pack]
use_cases: [tuple implementation, type-safe printf]
prerequisites: ["cpp.basic.templates"]
related: ["cpp.meta.fold"]
next_topics: ["cpp.meta.fold"]
---

# Variadic Templates

Templates that accept an arbitrary number of arguments.

## Recursive Unpacking (Old Way)

```cpp
#include <iostream>

// Base case
void print() {}

// Recursive step
template<typename T, typename... Args>
void print(T first, Args... args) {
    std::cout << first << ' ';
    print(args...);
}

int main() {
    print(1, 2.5, "hello");
}
```
