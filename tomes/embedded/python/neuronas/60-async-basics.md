---
id: "python.async.basics"
title: "Async/Await Basics"
category: async
difficulty: intermediate
tags: [python, async, await, asyncio, concurrency]
keywords: [coroutine, event loop, async def]
use_cases: [concurrent I/O, network requests, responsive UI]
prerequisites: ["python.functions.def", "python.controlflow.for"]
related: ["python.async.context-managers", "python.async.patterns"]
next_topics: ["python.async.tasks"]
---

# Async/Await Basics

Async/await enables asynchronous, concurrent code execution without blocking.

## async def

Mark a function as a coroutine.

```python
import asyncio

async def greet():
    print("Hello")
    await asyncio.sleep(1)  # Non-blocking sleep
    print("World!")

# Coroutines must be awaited or scheduled
await greet()  # In async context
```

## await

Pause execution until awaited coroutine completes.

```python
import asyncio

async def fetch_data():
    print("Fetching...")
    await asyncio.sleep(2)  # Simulate I/O
    print("Data received!")
    return {"data": "result"}

async def main():
    result = await fetch_data()
    print(result)

asyncio.run(main())
```

## Event Loop

The event loop manages and schedules coroutines.

```python
import asyncio

async def task1():
    print("Task 1 started")
    await asyncio.sleep(1)
    print("Task 1 completed")

async def task2():
    print("Task 2 started")
    await asyncio.sleep(1)
    print("Task 2 completed")

async def main():
    # Run tasks concurrently
    await asyncio.gather(task1(), task2())

asyncio.run(main())

# Output:
# Task 1 started
# Task 2 started
# Task 2 completed
# Task 1 completed
```

## Creating Tasks

Schedule coroutines for concurrent execution.

```python
import asyncio

async def worker(name, delay):
    print(f"{name} started")
    await asyncio.sleep(delay)
    print(f"{name} finished")

async def main():
    # Create tasks (fire and forget)
    task1 = asyncio.create_task(worker("Worker 1", 2))
    task2 = asyncio.create_task(worker("Worker 2", 1))
    task3 = asyncio.create_task(worker("Worker 3", 3))

    # Wait for all tasks
    await task1
    await task2
    await task3

asyncio.run(main())
```

## asyncio.sleep

Non-blocking delay.

```python
import asyncio

async def countdown():
    for i in range(5, 0, -1):
        print(f"{i}...")
        await asyncio.sleep(1)
    print("Liftoff!")

asyncio.run(countdown())
```

## Return Values

```python
import asyncio

async def compute():
    await asyncio.sleep(1)
    return 42

async def main():
    result = await compute()
    print(f"Result: {result}")

asyncio.run(main())
```

## Gathering Multiple Coroutines

```python
import asyncio

async def fetch_url(url):
    print(f"Fetching {url}")
    await asyncio.sleep(1)  # Simulate network delay
    return f"Data from {url}"

async def main():
    urls = [
        "https://api1.com",
        "https://api2.com",
        "https://api3.com"
    ]

    # Run concurrently, collect results
    results = await asyncio.gather(
        fetch_url(urls[0]),
        fetch_url(urls[1]),
        fetch_url(urls[2])
    )

    for result in results:
        print(result)

asyncio.run(main())
```

## Handling Exceptions

```python
import asyncio

async def may_fail():
    await asyncio.sleep(1)
    raise ValueError("Something went wrong")

async def main():
    try:
        await may_fail()
    except ValueError as e:
        print(f"Caught error: {e}")

asyncio.run(main())
```

## Common Patterns

### Timeout
```python
import asyncio

async def long_operation():
    await asyncio.sleep(10)

async def main():
    try:
        await asyncio.wait_for(long_operation(), timeout=2.0)
    except asyncio.TimeoutError:
        print("Operation timed out!")

asyncio.run(main())
```

### Wait for first completion
```python
import asyncio

async def task1():
    await asyncio.sleep(3)
    return "Task 1"

async def task2():
    await asyncio.sleep(1)
    return "Task 2"

async def main():
    done, pending = await asyncio.wait(
        [task1(), task2()],
        return_when=asyncio.FIRST_COMPLETED
    )
    for task in done:
        print(f"Completed: {task.result()}")

asyncio.run(main())
```

### Retry with backoff
```python
import asyncio

async def fetch_with_retry(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            return await fetch_data(url)
        except Exception:
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                await asyncio.sleep(wait_time)
            else:
                raise

async def fetch_data(url):
    # Simulated fetch
    await asyncio.sleep(0.1)
    return f"Data from {url}"
```

> **Note**: Async only helps with I/O-bound operations, not CPU-bound tasks. Use multiprocessing for CPU-bound work.
