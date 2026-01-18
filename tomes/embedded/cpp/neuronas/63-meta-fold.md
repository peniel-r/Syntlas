---
id: "cpp.meta.fold"
title: "Fold Expressions (C++17)"
category: metaprogramming
difficulty: advanced
tags: [cpp, templates, fold, pack]
keywords: [fold expression, (...)]
use_cases: [simplifying variadic templates]
prerequisites: ["cpp.meta.variadic"]
related: ["cpp.meta.variadic"]
next_topics: []
---

# Fold Expressions

Simplifies operations on parameter packs without recursion.

## Syntax

- `(pack op ...)`: Unary right fold
- `(... op pack)`: Unary left fold
- `(init op ... op pack)`: Binary left fold

## Example

```cpp
template<typename... Args>
auto sum(Args... args) {
    return (... + args); // Unary left fold
}

int main() {
    int total = sum(1, 2, 3, 4); // 10
}
```
