---
id: "py.async.runners"
title: "Asyncio Runners"
category: async
difficulty: advanced
tags: [python, async, asyncio, run]
keywords: [run, Runner, event loop]
use_cases: [entry point, testing]
prerequisites: ["python.async.basics"]
related: ["python.async.basics"]
next_topics: []
---

# Asyncio Runners

`asyncio.run()` is the standard entry point for async programs (Python 3.7+).

## Behavior

1. Creates a new event loop.
2. Runs the passed coroutine.
3. Closes the loop.
4. Cancels pending tasks.

```python
if __name__ == "__main__":
    asyncio.run(main())
```

## asyncio.Runner (Python 3.11+)

Context manager for more control (keeping loop alive).

```python
with asyncio.Runner() as runner:
    runner.run(main())
```
