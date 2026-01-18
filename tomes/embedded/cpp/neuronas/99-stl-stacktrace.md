---
id: "cpp.stl.stacktrace"
title: "std::stacktrace (C++23)"
category: util
difficulty: intermediate
tags: [cpp, stl, debug, stacktrace]
keywords: [stacktrace, current]
use_cases: [error reporting, debugging]
prerequisites: ["cpp.stl.source-location"]
related: ["cpp.exceptions"]
next_topics: []
---

# std::stacktrace

Capture and print stack traces.

## Usage

```cpp
#include <stacktrace>
#include <iostream>

void foo() {
    std::cout << std::stacktrace::current() << '\n';
}

int main() {
    foo();
}
```

```
