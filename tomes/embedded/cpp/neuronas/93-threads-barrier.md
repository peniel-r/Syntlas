---
id: "cpp.threads.barrier"
title: "std::barrier (C++20)"
category: concurrency
difficulty: advanced
tags: [cpp, threads, barrier, synchronization]
keywords: [barrier, arrive_and_wait]
use_cases: [reusable synchronization, phases]
prerequisites: ["cpp.threads.latch"]
related: ["cpp.threads.latch"]
next_topics: []
---

# std::barrier

Reusable synchronization point. Threads wait until N threads arrive, then they all proceed (potentially to the next phase).

## Usage

```cpp
#include <barrier>

std::barrier sync_point(3);

void worker() {
    // Phase 1
    sync_point.arrive_and_wait();
    
    // Phase 2
    sync_point.arrive_and_wait();
}
```
