---
id: "cpp.modern.coroutines"
title: "Coroutines (C++20)"
category: modern
difficulty: expert
tags: [cpp, modern, coroutines, async]
keywords: [co_await, co_yield, co_return]
use_cases: [async io, generators, lazy evaluation]
prerequisites: ["cpp.modern.lambdas"]
related: ["cpp.modern.lambdas"]
next_topics: []
---

# Coroutines

Functions that can suspend execution and resume later. C++20 provides the keywords, but library support (like `std::generator` in C++23) is evolving.

## Keywords

- `co_await`: Suspend execution until an operation finishes.
- `co_yield`: Suspend execution and produce a value.
- `co_return`: Finish execution and return a value.

## Example (Conceptual)

```cpp
Generator<int> range(int start, int end) {
    for (int i = start; i < end; ++i) {
        co_yield i; // Suspend and return i
    }
}
```
