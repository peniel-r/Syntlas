---
id: "cpp.threads.jthread"
title: "std::jthread (C++20)"
category: concurrency
difficulty: intermediate
tags: [cpp, threads, jthread, raii]
keywords: [jthread, joinable, stop_token]
use_cases: [safe threads, cooperative interruption]
prerequisites: ["cpp.threads.basic"]
related: ["cpp.threads.basic"]
next_topics: []
---

# std::jthread

`std::jthread` (joining thread) is an improvement over `std::thread` that automatically joins on destruction.

## Improvements

1. **Auto-join**: No need to manually call `join()`. If `jthread` goes out of scope, it joins (unlike `thread` which terminates).
2. **Stop Token**: Built-in support for requesting a stop.

```cpp
#include <thread>
#include <iostream>

void worker(std::stop_token st) {
    while (!st.stop_requested()) {
        // Work...
    }
}

int main() {
    std::jthread t(worker);
    // Auto-joins at end of scope
}
```
