---
id: "cpp.oo.virtual-destructor"
title: "Virtual Destructor"
category: oop
difficulty: intermediate
tags: [cpp, oop, destructor, virtual]
keywords: [virtual destructor, inheritance, polymorphism]
use_cases: [polymorphic deletion]
prerequisites: ["cpp.oo.inheritance", "cpp.oo.polymorphism"]
related: ["cpp.oo.polymorphism"]
next_topics: []
---

# Virtual Destructor

If a class is meant to be used polymorphically (i.e., accessed via base class pointer), its destructor **must** be virtual.

## Why?

If not virtual, `delete basePtr` calls only the base destructor, leaking derived resources.

```cpp
class Base {
public:
    virtual ~Base() {} // Essential
};

class Derived : public Base {
    int* res;
public:
    ~Derived() { delete res; }
};
```
