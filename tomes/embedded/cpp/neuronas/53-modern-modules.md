---
id: "cpp.modern.modules"
title: "Modules (C++20)"
category: modern
difficulty: advanced
tags: [cpp, modern, modules, import]
keywords: [import, export, module]
use_cases: [faster build times, encapsulation, header replacement]
prerequisites: ["cpp.basics.namespaces"]
related: ["cpp.basics.functions"]
next_topics: []
---

# Modules

Modules replace the ancient header (`#include`) system. They offer faster compilation and true isolation.

## Creating a Module

`math.cpp`:
```cpp
export module math;

export int add(int a, int b) {
    return a + b;
}
```

## Importing a Module

`main.cpp`:
```cpp
import math;
import <iostream>; // Standard library modules (C++23)

int main() {
    std::cout << add(1, 2);
}
```
