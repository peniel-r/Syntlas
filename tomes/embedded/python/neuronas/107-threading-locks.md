---
id: "py.concurrency.threading.locks"
title: "Threading Locks"
category: concurrency
difficulty: advanced
tags: [python, concurrency, threading, lock]
keywords: [Lock, RLock, acquire, release]
use_cases: [thread safety, critical sections]
prerequisites: ["python.threading"]
related: ["py.async.locks"]
next_topics: []
---

# Threading Locks

When using threads, shared data must be protected.

## Lock

```python
import threading

lock = threading.Lock()
counter = 0

def increment():
    global counter
    with lock:
        counter += 1
```

## RLock (Reentrant Lock)

A lock that can be acquired multiple times by the same thread.
