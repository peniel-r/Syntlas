---
id: "py.async.queues"
title: "Asyncio Queues"
category: async
difficulty: advanced
tags: [python, async, asyncio, queue]
keywords: [Queue, put, get, producer-consumer]
use_cases: [pipelines, producer-consumer]
prerequisites: ["python.async.basics"]
related: ["py.concurrency.queue"]
next_topics: []
---

# Asyncio Queues

`asyncio.Queue` is designed to be used in `async`/`await` code.

## Producer-Consumer Example

```python
q = asyncio.Queue()

async def producer():
    await q.put(1)
    await q.put(2)

async def consumer():
    while True:
        item = await q.get()
        print(f"Got {item}")
        q.task_done()
```
