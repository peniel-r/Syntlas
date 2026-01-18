---
id: "python.async.patterns"
title: "Async Patterns and Best Practices"
category: async
difficulty: advanced
tags: [python, async, asyncio, patterns]
keywords: [async context manager, async generator, synchronization]
use_cases: [async resource management, async data streams, concurrent access]
prerequisites: ["python.async.basics", "python.patterns.context-managers"]
related: ["python.threading"]
next_topics: []
---

# Async Patterns

Advanced patterns for async/await in Python.

## Async Context Managers

```python
import asyncio

class AsyncTimer:
    def __init__(self, name):
        self.name = name
        self.start = None

    async def __aenter__(self):
        self.start = asyncio.get_event_loop().time()
        print(f"Starting {self.name}")
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        elapsed = asyncio.get_event_loop().time() - self.start
        print(f"{self.name} took {elapsed:.2f}s")
        return False

async def with_async_timer():
    async with AsyncTimer("operation"):
        await asyncio.sleep(1)

asyncio.run(with_async_timer())
```

## Async Generators

```python
import asyncio

async def async_range(start, stop):
    """Async generator that yields values."""
    for i in range(start, stop):
        await asyncio.sleep(0.1)  # Simulate async work
        yield i

async def process_async_generator():
    async for num in async_range(0, 5):
        print(f"Processing {num}")

asyncio.run(process_async_generator())
```

## Async Iterators

```python
import asyncio

class AsyncCounter:
    def __init__(self):
        self.count = 0

    def __aiter__(self):
        return self

    async def __anext__(self):
        await asyncio.sleep(0.1)
        self.count += 1
        if self.count > 5:
            raise StopAsyncIteration
        return self.count

async def consume_async_iterator():
    counter = AsyncCounter()
    async for value in counter:
        print(f"Got: {value}")

asyncio.run(consume_async_iterator())
```

## Async Queue

```python
import asyncio

async def producer(queue):
    for i in range(5):
        await queue.put(f"Item {i}")
        await asyncio.sleep(0.1)
    await queue.put(None)  # Sentinel

async def consumer(queue):
    while True:
        item = await queue.get()
        if item is None:
            break
        print(f"Consumed: {item}")

async def main():
    queue = asyncio.Queue()
    await asyncio.gather(producer(queue), consumer(queue))

asyncio.run(main())
```

## Async Lock

```python
import asyncio

lock = asyncio.Lock()
counter = 0

async def increment(task_name):
    global counter
    async with lock:
        print(f"{task_name} waiting for lock...")
        await asyncio.sleep(0.1)
        counter += 1
        print(f"{task_name}: counter is now {counter}")

async def main():
    tasks = [increment(f"Task {i}") for i in range(5)]
    await asyncio.gather(*tasks)
    print(f"Final counter: {counter}")

asyncio.run(main())
```

## Async Semaphore

```python
import asyncio
import random

semaphore = asyncio.Semaphore(2)  # Max 2 concurrent

async def worker(worker_id):
    async with semaphore:
        print(f"Worker {worker_id} started")
        await asyncio.sleep(random.uniform(0.5, 1.5))
        print(f"Worker {worker_id} finished")

async def main():
    tasks = [worker(i) for i in range(5)]
    await asyncio.gather(*tasks)

asyncio.run(main())
```

## Async Event

```python
import asyncio

event = asyncio.Event()

async def waiter(name):
    print(f"{name} waiting for event...")
    await event.wait()
    print(f"{name} event received!")

async def setter():
    print("Setting event in 2 seconds...")
    await asyncio.sleep(2)
    event.set()

async def main():
    await asyncio.gather(
        waiter("Waiter 1"),
        waiter("Waiter 2"),
        setter()
    )

asyncio.run(main())
```

## Async Batching

```python
import asyncio

async def process_batch(items, batch_size=10):
    """Process items in batches for efficiency."""
    results = []
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        batch_results = await asyncio.gather(
            *[process_item(item) for item in batch]
        )
        results.extend(batch_results)
    return results

async def process_item(item):
    await asyncio.sleep(0.1)
    return item.upper()

async def main():
    items = [f"item{i}" for i in range(30)]
    processed = await process_batch(items)
    print(f"Processed {len(processed)} items")

asyncio.run(main())
```

## Async Timeout Pattern

```python
import asyncio

async def with_timeout(coro, timeout):
    """Async context manager with timeout."""
    try:
        return await asyncio.wait_for(coro, timeout=timeout)
    except asyncio.TimeoutError:
        return None

async def slow_operation():
    await asyncio.sleep(5)
    return "Done"

async def main():
    result = await with_timeout(slow_operation(), timeout=2.0)
    if result is None:
        print("Operation timed out!")
    else:
        print(f"Result: {result}")

asyncio.run(main())
```

## Common Use Cases

### Rate limiting with async
```python
import asyncio

class RateLimiter:
    def __init__(self, rate_limit):
        self.rate_limit = rate_limit
        self.semaphore = asyncio.Semaphore(rate_limit)

    async def __aenter__(self):
        await self.semaphore.acquire()
        return self

    async def __aexit__(self, *args):
        self.semaphore.release()
        return False

async def api_call():
    async with RateLimiter(rate_limit=5):
        await make_http_request()
```

### Connection pool
```python
import asyncio

class ConnectionPool:
    def __init__(self, max_connections):
        self.pool = asyncio.Queue(maxsize=max_connections)
        self.max_connections = max_connections

    async def acquire(self):
        return await self.pool.get()

    def release(self, connection):
        await self.pool.put(connection)
```

### Async retry decorator
```python
import asyncio

import functools

def async_retry(max_attempts=3, delay=1.0):
    def decorator(func):
        @functools.wraps(func)
        async def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    if attempt < max_attempts - 1:
                        print(f"Attempt {attempt + 1} failed: {e}")
                        await asyncio.sleep(delay * (2 ** attempt))
                    else:
                        raise
        return wrapper
    return decorator

@async_retry(max_attempts=3)
async def unstable_api():
    await asyncio.sleep(0.1)
    if random.random() < 0.7:
        raise ConnectionError("Failed")
    return "success"
```

### Async generator for streaming
```python
import asyncio

async def read_lines_stream(filename):
    """Read file line by line asynchronously."""
    with open(filename, 'r') as f:
        async for line in stream_lines(f):
            yield line.strip()

async def stream_lines(file):
    for line in file:
        await asyncio.sleep(0)  # Simulate async work
        yield line

async def process_stream(filename):
    async for line in read_lines_stream(filename):
        print(f"Processing: {line}")
```

> **Performance**: Async is best for I/O-bound operations. Use multiprocessing for CPU-bound tasks.
