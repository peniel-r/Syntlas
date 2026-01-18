---
# TIER 1: ESSENTIAL
id: "cpp.threads.basic"
title: "Threads (C++11)"
tags: [cpp, threads, concurrency, advanced]
links: ["cpp.oo.classes", "cpp.modern.lambdas"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: advanced
keywords: [thread, concurrency, parallel, c++11]
prerequisites: ["cpp.oo.classes", "cpp.modern.lambdas"]
next: ["cpp.threads.mutex", "cpp.threads.atomic"]
related:
  - id: "cpp.threads.mutex"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Threads (C++11)

Threads enable concurrent execution of code.

## Basic Thread Creation

```cpp
#include <thread>

void worker() {
    std::cout << "Worker thread" << std::endl;
}

std::thread t(worker);
t.join();  // Wait for thread to finish
```

## Thread with Lambda

```cpp
std::thread t([]() {
    std::cout << "Lambda thread" << std::endl;
});

t.join();
```

## Thread with Arguments

```cpp
void printMessage(const std::string& msg, int count) {
    for (int i = 0; i < count; i++) {
        std::cout << msg << std::endl;
    }
}

std::thread t(printMessage, "Hello", 3);
t.join();
```

## Thread with Multiple Threads

```cpp
std::thread t1([]() { std::cout << "Thread 1" << std::endl; });
std::thread t2([]() { std::cout << "Thread 2" << std::endl; });

t1.join();
t2.join();
```

## Detached Threads

```cpp
std::thread t([]() {
    std::cout << "Detached thread" << std::endl;
});

t.detach();  // Run independently
```

## Thread ID

```cpp
std::thread t([]() {
    std::cout << "Thread ID: " 
              << std::this_thread::get_id() << std::endl;
});

t.join();
```

## See Also

- [Mutex](cpp.threads.mutex) - Thread synchronization
- [Atomic](cpp.threads.atomic) - Lock-free operations
