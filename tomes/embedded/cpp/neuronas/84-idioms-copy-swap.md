---
id: "cpp.idioms.copy-swap"
title: "Copy-and-Swap Idiom"
category: patterns
difficulty: advanced
tags: [cpp, patterns, assignment, exception-safety]
keywords: [copy swap, operator=, swap]
use_cases: [implementing assignment operator]
prerequisites: ["cpp.oo.rule-of-five"]
related: ["cpp.oo.rule-of-five"]
next_topics: []
---

# Copy-and-Swap Idiom

A robust way to implement the assignment operator (`operator=`) that provides strong exception safety.

## Usage

```cpp
class Array {
    int* data;
    size_t size;
public:
    // ... constructors ...
    
    friend void swap(Array& first, Array& second) {
        using std::swap;
        swap(first.data, second.data);
        swap(first.size, second.size);
    }

    Array& operator=(Array other) { // Passed by value (copy)
        swap(*this, other);
        return *this;
    } // other destroyed here (releasing old resources)
};
```
