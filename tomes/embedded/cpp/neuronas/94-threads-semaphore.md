---
id: "cpp.threads.semaphore"
title: "std::semaphore (C++20)"
category: concurrency
difficulty: advanced
tags: [cpp, threads, semaphore, synchronization]
keywords: [counting_semaphore, binary_semaphore, acquire, release]
use_cases: [limiting concurrency, signaling]
prerequisites: ["cpp.threads.mutex"]
related: ["cpp.threads.mutex"]
next_topics: []
---

# std::semaphore

Lightweight synchronization primitive.

## Counting Semaphore

Allows N simultaneous accesses.

```cpp
#include <semaphore>

std::counting_semaphore<5> sem(5); // 5 slots

void worker() {
    sem.acquire();
    // Use resource...
    sem.release();
}
```

## Binary Semaphore

Like a mutex but can be released by a different thread.
