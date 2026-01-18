---
id: "cpp.oo.operator-overloading"
title: "Operator Overloading"
category: oop
difficulty: intermediate
tags: [cpp, oop, operators, syntax]
keywords: [operator+, operator<<, operator()]
use_cases: [custom types, math classes, functors]
prerequisites: ["cpp.oo.classes"]
related: ["cpp.oo.friend"]
next_topics: []
---

# Operator Overloading

Customize how operators work with your types.

## Stream Insertion (<<)

```cpp
std::ostream& operator<<(std::ostream& os, const Point& p) {
    os << "(" << p.x << ", " << p.y << ")";
    return os;
}
```

## Function Call (Functor)

```cpp
struct Adder {
    int val;
    int operator()(int x) { return x + val; }
};
```
