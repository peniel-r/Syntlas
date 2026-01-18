---
id: "cpp.oo.rule-of-five"
title: "Rule of Five"
category: oop
difficulty: advanced
tags: [cpp, oop, move, copy]
keywords: [destructor, copy constructor, move constructor]
use_cases: [resource management classes]
prerequisites: ["cpp.oo.constructors", "cpp.modern.move-semantics"]
related: ["cpp.memory.raii"]
next_topics: []
---

# Rule of Five

If a class requires a user-defined destructor, it likely requires user-defined versions of all five special member functions:

1. Destructor
2. Copy Constructor
3. Copy Assignment Operator
4. Move Constructor
5. Move Assignment Operator

## Example

```cpp
class Buffer {
    int* ptr;
public:
    ~Buffer() { delete ptr; }
    
    // Copy
    Buffer(const Buffer& other) : ptr(new int(*other.ptr)) {}
    Buffer& operator=(const Buffer& other) { /*...*/ }
    
    // Move
    Buffer(Buffer&& other) noexcept : ptr(other.ptr) { other.ptr = nullptr; }
    Buffer& operator=(Buffer&& other) noexcept { /*...*/ }
};
```
