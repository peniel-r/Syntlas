---
id: "cpp.threads.condition-variable"
title: "std::condition_variable"
category: concurrency
difficulty: advanced
tags: [cpp, threads, synchronization, wait]
keywords: [condition_variable, notify_one, notify_all, wait]
use_cases: [producer-consumer, event waiting]
prerequisites: ["cpp.threads.mutex"]
related: ["cpp.threads.mutex"]
next_topics: []
---

# std::condition_variable

A synchronization primitive used to block a thread, or multiple threads at the same time, until another thread modifies a shared variable and notifies the `condition_variable`.

## Usage

```cpp
#include <condition_variable>
#include <mutex>
#include <thread>
#include <queue>

std::mutex m;
std::condition_variable cv;
std::queue<int> q;
bool done = false;

void producer() {
    {
        std::lock_guard lk(m);
        q.push(1);
    }
    cv.notify_one();
}

void consumer() {
    std::unique_lock lk(m);
    cv.wait(lk, []{ return !q.empty() || done; });
    
    if (!q.empty()) {
        int val = q.front();
        q.pop();
    }
}
```
