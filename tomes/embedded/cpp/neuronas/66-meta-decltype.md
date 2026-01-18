---
id: "cpp.meta.decltype"
title: "decltype"
category: metaprogramming
difficulty: intermediate
tags: [cpp, templates, decltype, auto]
keywords: [decltype, type deduction]
use_cases: [deducing return types, template metaprogramming]
prerequisites: ["cpp.modern.auto"]
related: ["cpp.modern.auto"]
next_topics: []
---

# decltype

Inspects the declared type of an entity or expression. Unlike `auto`, it deduces exact types (including references).

## Usage

```cpp
int x = 0;
decltype(x) y = x; // y is int

const int& cx = x;
decltype(cx) cy = x; // cy is const int&

// Trailing return type
auto add(int a, int b) -> decltype(a + b) {
    return a + b;
}
```
