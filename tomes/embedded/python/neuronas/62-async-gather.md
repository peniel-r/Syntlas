---
id: "py.async.gather"
title: "Asyncio Gather"
category: async
difficulty: advanced
tags: [python, async, asyncio, gather]
keywords: [gather, concurrency, parallelism]
use_cases: [running many tasks, aggregating results]
prerequisites: ["py.async.tasks"]
related: ["py.async.tasks"]
next_topics: []
---

# Asyncio Gather

`asyncio.gather` runs awaitables concurrently and returns their results in order.

## Usage

```python
import asyncio

async def fetch(id):
    await asyncio.sleep(1)
    return f"Data {id}"

async def main():
    # Runs 3 requests concurrently
    results = await asyncio.gather(
        fetch(1),
        fetch(2),
        fetch(3)
    )
    print(results)  # ['Data 1', 'Data 2', 'Data 3']
```

## Exceptions

By default, if one fails, `gather` stops. Use `return_exceptions=True` to keep going.
