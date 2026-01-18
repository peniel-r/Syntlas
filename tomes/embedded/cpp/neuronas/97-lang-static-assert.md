---
id: "cpp.lang.static-assert"
title: "static_assert"
category: language
difficulty: intermediate
tags: [cpp, assertions, compile-time]
keywords: [static_assert, compile-time check]
use_cases: [template constraints, platform checks]
prerequisites: ["cpp.modern.constexpr"]
related: ["cpp.modern.constexpr"]
next_topics: []
---

# static_assert

Performs a check at compile-time. If false, compilation fails.

## Usage

```cpp
static_assert(sizeof(int) == 4, "Integers must be 4 bytes");

template <typename T>
void foo(T t) {
    static_assert(std::is_integral_v<T>, "T must be integral");
}
```
