---
id: "py.async.locks"
title: "Asyncio Locks"
category: async
difficulty: advanced
tags: [python, async, asyncio, synchronization]
keywords: [Lock, acquire, release, mutex]
use_cases: [shared resources, critical sections]
prerequisites: ["python.async.basics"]
related: ["py.concurrency.threading.locks"]
next_topics: []
---

# Asyncio Locks

Async code is single-threaded, but race conditions can still occur when `await` yields control during a critical section.

## Usage

```python
lock = asyncio.Lock()

async with lock:
    # Critical section
    # Safe to await here without other tasks entering
    await asyncio.sleep(0.1)
```
