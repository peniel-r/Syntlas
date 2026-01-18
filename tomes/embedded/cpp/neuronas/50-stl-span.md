---
id: "cpp.stl.span"
title: "std::span (C++20)"
category: stl
difficulty: intermediate
tags: [cpp, stl, span, view]
keywords: [span, view, contiguous memory]
use_cases: [array views, avoiding copies, buffer manipulation]
prerequisites: ["cpp.stl.vector", "cpp.stl.array"]
related: ["cpp.stl.string-view"]
next_topics: []
---

# std::span

`std::span` is a non-owning view over a contiguous sequence of objects (like array, vector, or C-array).

## Usage

It replaces passing `(T* ptr, size_t size)` pairs.

```cpp
#include <span>
#include <vector>
#include <iostream>

void print_values(std::span<int> data) {
    for (int x : data) {
        std::cout << x << ' ';
    }
}

int main() {
    int arr[] = {1, 2, 3};
    std::vector<int> vec = {4, 5, 6};
    
    print_values(arr); // Works with array
    print_values(vec); // Works with vector
}
```
