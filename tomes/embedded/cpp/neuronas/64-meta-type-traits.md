---
id: "cpp.meta.type-traits"
title: "Type Traits"
category: metaprogramming
difficulty: advanced
tags: [cpp, templates, traits, introspection]
keywords: [type_traits, is_same, enable_if]
use_cases: [conditional compilation, static assertions]
prerequisites: ["cpp.modern.templates"]
related: ["cpp.meta.sfinae"]
next_topics: ["cpp.meta.sfinae"]
---

# Type Traits

The `<type_traits>` header provides compile-time constants about types.

## Usage

```cpp
#include <type_traits>
#include <iostream>

template<typename T>
void foo(T t) {
    if constexpr (std::is_integral_v<T>) {
        std::cout << "Integral\n";
    } else {
        std::cout << "Not integral\n";
    }
}
```

```