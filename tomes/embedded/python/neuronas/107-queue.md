---
id: "py.concurrency.queue"
title: "Thread-Safe Queue"
category: concurrency
difficulty: advanced
tags: [python, concurrency, queue, threads]
keywords: [Queue, put, get, task_done, join]
use_cases: [producer-consumer, thread communication]
prerequisites: ["python.threading"]
related: ["py.async.queues"]
next_topics: []
---

# Thread-Safe Queue

The `queue` module provides a thread-safe FIFO implementation.

## Usage

```python
import queue
import threading

q = queue.Queue()

def worker():
    while True:
        item = q.get()
        print(f'Working on {item}')
        q.task_done()

threading.Thread(target=worker, daemon=True).start()

q.put(1)
q.join()  # Block until all tasks are done
```
