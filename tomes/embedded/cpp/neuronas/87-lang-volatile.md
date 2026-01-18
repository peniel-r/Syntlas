---
id: "cpp.lang.volatile"
title: "volatile"
category: language
difficulty: advanced
tags: [cpp, keywords, volatile, hardware]
keywords: [volatile, optimization, side-effects]
use_cases: [memory-mapped io, signal handling]
prerequisites: ["cpp.basics.variables"]
related: ["cpp.threads.atomic"]
next_topics: []
---

# volatile

Tells the compiler that a variable's value may change at any time (e.g., by hardware), preventing optimization.

## Misconception

`volatile` is **NOT** for thread safety. Use `std::atomic` for threads.

```cpp
volatile int* status_reg = (int*)0xFFFF0000;
while (*status_reg == 0) {
    // Wait for hardware
}
```
