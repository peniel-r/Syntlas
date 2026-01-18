---
id: "cpp.threads.promise"
title: "std::promise"
category: concurrency
difficulty: advanced
tags: [cpp, threads, promise, future]
keywords: [promise, set_value, get_future]
use_cases: [setting async results manually]
prerequisites: ["cpp.threads.future"]
related: ["cpp.threads.future"]
next_topics: []
---

# std::promise

`std::promise` provides a way to set a value (or exception) that will be read through a `std::future`.

## Usage

```cpp
#include <future>
#include <thread>
#include <iostream>

void worker(std::promise<int> p) {
    p.set_value(42);
}

int main() {
    std::promise<int> p;
    std::future<int> f = p.get_future();
    
    std::thread t(worker, std::move(p));
    
    std::cout << f.get() << '\n';
    t.join();
}
```

```