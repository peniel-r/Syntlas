---
id: "py.concurrency.concurrent-futures"
title: "Concurrent Futures"
category: concurrency
difficulty: advanced
tags: [python, concurrency, futures, threadpool]
keywords: [ThreadPoolExecutor, ProcessPoolExecutor, submit]
use_cases: [easy threading/multiprocessing, async execution]
prerequisites: ["py.concurrency.multiprocessing"]
related: ["py.concurrency.multiprocessing"]
next_topics: []
---

# Concurrent Futures

The `concurrent.futures` module provides a high-level interface for asynchronously executing callables.

## Executors

- `ThreadPoolExecutor`: For I/O bound tasks.
- `ProcessPoolExecutor`: For CPU bound tasks.

## Usage

```python
from concurrent.futures import ThreadPoolExecutor

def load_url(url):
    return f"Loaded {url}"

with ThreadPoolExecutor(max_workers=5) as executor:
    future = executor.submit(load_url, "http://example.com")
    print(future.result())
```
