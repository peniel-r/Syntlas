---
id: "cpp.oo.friend"
title: "Friend"
category: oop
difficulty: intermediate
tags: [cpp, oop, friend, access]
keywords: [friend, private access]
use_cases: [operator overloading, testing, helper functions]
prerequisites: ["cpp.oo.classes"]
related: ["cpp.oo.classes"]
next_topics: []
---

# Friend

The `friend` keyword allows a function or another class to access private and protected members of a class.

## Friend Function

```cpp
class Box {
    int width;
public:
    friend void printWidth(Box b);
};

void printWidth(Box b) {
    // Can access private member width
    std::cout << b.width;
}
```

## Friend Class

```cpp
class A {
    friend class B;
    int data;
};

class B {
    void func(A a) {
        a.data = 10; // OK
    }
};
```
