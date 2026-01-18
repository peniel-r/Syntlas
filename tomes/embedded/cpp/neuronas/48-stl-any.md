---
id: "cpp.stl.any"
title: "std::any (C++17)"
category: stl
difficulty: intermediate
tags: [cpp, stl, any, type-erasure]
keywords: [any, any_cast, type erasure]
use_cases: [storing arbitrary types, heterogeneous containers]
prerequisites: ["cpp.modern.auto"]
related: ["cpp.stl.variant"]
next_topics: []
---

# std::any

`std::any` is a type-safe container for single values of any type.

## Usage

```cpp
#include <any>
#include <string>
#include <iostream>

int main() {
    std::any a = 1;
    a = 3.14;
    a = std::string("hello");

    try {
        std::string s = std::any_cast<std::string>(a);
        std::cout << s << '\n';
    } catch (const std::bad_any_cast& e) {
        std::cout << e.what() << '\n';
    }
}
```

Unlike `variant`, `any` can hold *anything*, but incurs dynamic allocation and runtime type checking.

```
