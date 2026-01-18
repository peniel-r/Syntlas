---
id: "py.async.tasks"
title: "Asyncio Tasks"
category: async
difficulty: advanced
tags: [python, async, asyncio, tasks]
keywords: [create_task, Task, await]
use_cases: [concurrent execution, background jobs]
prerequisites: ["python.async.basics"]
related: ["py.async.gather"]
next_topics: ["py.async.gather"]
---

# Asyncio Tasks

Tasks are used to schedule coroutines concurrently.

## Creating Tasks

`asyncio.create_task()` wraps the coroutine and schedules its execution on the event loop.

```python
import asyncio

async def worker(name):
    await asyncio.sleep(1)
    print(f"{name} done")

async def main():
    # Schedule both to run "at the same time"
    t1 = asyncio.create_task(worker("A"))
    t2 = asyncio.create_task(worker("B"))

    await t1
    await t2

asyncio.run(main())
```
