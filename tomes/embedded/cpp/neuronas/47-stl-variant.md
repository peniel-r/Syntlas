---
id: "cpp.stl.variant"
title: "std::variant (C++17)"
category: stl
difficulty: intermediate
tags: [cpp, stl, variant, sum-type]
keywords: [variant, visit, get_if, monostate]
use_cases: [type-safe union, error handling, state machines]
prerequisites: ["cpp.stl.optional"]
related: ["cpp.stl.any", "cpp.stl.optional"]
next_topics: ["cpp.stl.variant"]
---

# std::variant

`std::variant` is a type-safe union. It can hold a value of one of several alternative types.

## Usage

```cpp
#include <variant>
#include <string>
#include <iostream>

int main() {
    std::variant<int, float, std::string> v;

    v = 10;
    int i = std::get<int>(v);

    v = "Hello";
    std::string s = std::get<std::string>(v);
    
    // Check type
    if (std::holds_alternative<int>(v)) {
        std::cout << "It's an int\n";
    }
}
```

## std::visit

Apply a function to the stored value.

```cpp
std::visit([](auto&& arg) {
    std::cout << arg << '\n';
}, v);
```

