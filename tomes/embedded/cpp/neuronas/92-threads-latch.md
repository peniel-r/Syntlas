---
id: "cpp.threads.latch"
title: "std::latch (C++20)"
category: concurrency
difficulty: advanced
tags: [cpp, threads, latch, synchronization]
keywords: [latch, count_down, wait]
use_cases: [one-time synchronization]
prerequisites: ["cpp.threads.basic"]
related: ["cpp.threads.barrier"]
next_topics: []
---

# std::latch

A single-use synchronization primitive. Threads wait until the counter reaches zero.

## Usage

```cpp
#include <latch>
#include <thread>

std::latch work_done(3);

void worker() {
    // ... work ...
    work_done.count_down();
}

int main() {
    std::jthread t1(worker), t2(worker), t3(worker);
    work_done.wait(); // Blocks until counter is 0
}
```
