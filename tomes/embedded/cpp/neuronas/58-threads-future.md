---
id: "cpp.threads.future"
title: "std::future"
category: concurrency
difficulty: intermediate
tags: [cpp, threads, future, async]
keywords: [future, get, wait]
use_cases: [retrieving async results]
prerequisites: ["cpp.threads.basic"]
related: ["cpp.threads.async", "cpp.threads.promise"]
next_topics: ["cpp.threads.async"]
---

# std::future

`std::future` provides a mechanism to access the result of an asynchronous operation.

## Usage

It is usually created by `std::async`, `std::packaged_task`, or `std::promise`.

```cpp
#include <future>
#include <iostream>

int main() {
    // Future from async
    std::future<int> f = std::async(std::launch::async, []{ return 42; });
    
    // Block and get result
    std::cout << f.get() << '\n';
}
```

```