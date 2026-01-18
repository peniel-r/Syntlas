---
id: "py.async.timeouts"
title: "Asyncio Timeouts"
category: async
difficulty: advanced
tags: [python, async, asyncio, timeout]
keywords: [wait_for, timeout, TimeoutError]
use_cases: [cancelling slow tasks, slas]
prerequisites: ["python.async.basics"]
related: ["py.async.tasks"]
next_topics: []
---

# Asyncio Timeouts

Use `asyncio.wait_for` to set a time limit on an awaitable.

## Usage

```python
try:
    await asyncio.wait_for(long_running_task(), timeout=1.0)
except asyncio.TimeoutError:
    print("Task took too long!")
```
