---
# TIER 1: ESSENTIAL
id: "cpp.threads.atomic"
title: "Atomic Operations"
tags: [cpp, threads, atomic, advanced]
links: ["cpp.threads.basic", "cpp.threads.mutex"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: advanced
keywords: [atomic, lock-free, memory-order, concurrency]
prerequisites: ["cpp.threads.basic"]
next: ["cpp.threads.condition-variable", "cpp.memory.smart-pointers"]
related:
  - id: "cpp.threads.mutex"
    type: alternative
    weight: 75
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Atomic Operations

Atomic operations provide lock-free synchronization for shared data.

## Basic Atomic

```cpp
#include <atomic>

std::atomic<int> counter(0);

void increment() {
    counter++;  // Atomic increment
}

std::thread t1(increment);
std::thread t2(increment);
t1.join();
t2.join();

std::cout << counter << std::endl;  // 2
```

## Atomic Operations

```cpp
std::atomic<int> value(10);

// Load
int current = value.load();

// Store
value.store(20);

// Exchange
int old = value.exchange(30);

// Compare and exchange
int expected = 30;
bool success = value.compare_exchange_weak(expected, 40);
```

## Memory Order

```cpp
std::atomic<int> flag(0);

// Relaxed - no synchronization
flag.store(1, std::memory_order_relaxed);

// Acquire - synchronize with release
int val = flag.load(std::memory_order_acquire);

// Release - synchronize with acquire
flag.store(1, std::memory_order_release);

// Sequentially consistent (default)
flag.fetch_add(1, std::memory_order_seq_cst);
```

## Atomic Types

```cpp
std::atomic<int> intAtomic;
std::atomic<bool> boolAtomic;
std::atomic<void*> ptrAtomic;
std::atomic<std::shared_ptr<int>> sharedPtrAtomic;  // C++20
```

## Atomic Flag

```cpp
std::atomic_flag lock = ATOMIC_FLAG_INIT;

void criticalSection() {
    while (lock.test_and_set(std::memory_order_acquire)) {
        // Spin until we get the lock
    }
    
    // Critical section
    
    lock.clear(std::memory_order_release);
}
```

## See Also

- [Mutex](cpp.threads.mutex) - Lock-based synchronization
- [Threads](cpp.threads.basic) - Thread basics
