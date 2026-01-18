---
# TIER 1: ESSENTIAL
id: "cpp.threads.mutex"
title: "Mutex"
tags: [cpp, threads, mutex, advanced]
links: ["cpp.threads.basic", "cpp.threads.atomic"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: advanced
keywords: [mutex, lock, thread-safety, synchronization]
prerequisites: ["cpp.threads.basic"]
next: ["cpp.threads.condition-variable", "cpp.threads.atomic"]
related:
  - id: "cpp.threads.basic"
    type: complement
    weight: 90
  - id: "cpp.threads.atomic"
    type: alternative
    weight: 75
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Mutex

Mutexes provide mutual exclusion for thread synchronization.

## Basic Mutex

```cpp
#include <mutex>

std::mutex mtx;
int counter = 0;

void increment() {
    mtx.lock();
    counter++;
    mtx.unlock();
}

std::thread t1(increment);
std::thread t2(increment);
t1.join();
t2.join();
```

## Using lock_guard (RAII)

```cpp
void increment() {
    std::lock_guard<std::mutex> lock(mtx);  // Automatically unlocked
    counter++;
}
```

## Using unique_lock (C++11)

```cpp
void increment() {
    std::unique_lock<std::mutex> lock(mtx);
    counter++;
    // Manual unlock available
    lock.unlock();
}
```

## Using scoped_lock (C++17)

```cpp
std::mutex mtx1, mtx2;

void function() {
    std::scoped_lock lock(mtx1, mtx2);  // Lock multiple mutexes
    // Critical section
}
```

## Try Lock

```cpp
bool tryIncrement() {
    if (mtx.try_lock()) {
        counter++;
        mtx.unlock();
        return true;
    }
    return false;
}
```

## See Also

- [Condition Variable](cpp.threads.condition-variable) - Thread notification
- [Atomic](cpp.threads.atomic) - Lock-free operations
