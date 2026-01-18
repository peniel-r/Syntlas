---
id: "python.threading"
title: "Threading Basics"
category: concurrency
difficulty: advanced
tags: [python, threading, concurrency, multithreading]
keywords: [Thread, Lock, Semaphore, queue]
use_cases: [background tasks, parallel I/O, responsive UI]
prerequisites: ["python.functions.def"]
related: ["python.async.basics"]
next_topics: []
---

# Threading

Python's `threading` module provides thread-based concurrency.

## Creating Threads

```python
import threading
import time

def worker(name, delay):
    print(f"{name} starting")
    time.sleep(delay)
    print(f"{name} finished")

# Create threads
t1 = threading.Thread(target=worker, args=("Worker 1", 2))
t2 = threading.Thread(target=worker, args=("Worker 2", 3))

# Start threads
t1.start()
t2.start()

# Wait for completion
t1.join()
t2.join()
```

## Thread Subclass

```python
import threading
import time

class WorkerThread(threading.Thread):
    def __init__(self, name):
        super().__init__()
        self.name = name

    def run(self):
        print(f"{self.name} starting")
        time.sleep(1)
        print(f"{self.name} finished")

thread = WorkerThread("Custom Worker")
thread.start()
thread.join()
```

## Thread Safety with Locks

```python
import threading

counter = 0
lock = threading.Lock()

def increment():
    global counter
    for _ in range(10000):
        with lock:
            counter += 1

# Create threads
threads = [threading.Thread(target=increment) for _ in range(4)]

for t in threads:
    t.start()

for t in threads:
    t.join()

print(counter)  # 40000 (correct with lock)
```

## Shared Resources

```python
import threading

class SharedCounter:
    def __init__(self):
        self.value = 0
        self.lock = threading.Lock()

    def increment(self):
        with self.lock:
            self.value += 1

    def get(self):
        with self.lock:
            return self.value

counter = SharedCounter()

threads = [
    threading.Thread(target=counter.increment)
    for _ in range(10)
]

for t in threads:
    t.start()

for t in threads:
    t.join()

print(counter.get())
```

## Thread Communication with Queue

```python
import threading
import queue
import time

def producer(q):
    for i in range(5):
        time.sleep(0.1)
        q.put(f"Item {i}")
    q.put(None)  # Sentinel

def consumer(q):
    while True:
        item = q.get()
        if item is None:
            break
        print(f"Consumed: {item}")

q = queue.Queue()
t1 = threading.Thread(target=producer, args=(q,))
t2 = threading.Thread(target=consumer, args=(q,))

t1.start()
t2.start()

t1.join()
t2.join()
```

## Daemon Threads

```python
import threading
import time

def background_task():
    while True:
        print("Background task running")
        time.sleep(1)

# Daemon thread - exits when main thread exits
thread = threading.Thread(target=background_task, daemon=True)
thread.start()

time.sleep(3)
print("Main thread ending, daemon stops")
```

## Semaphore - Limit Concurrency

```python
import threading
import time

semaphore = threading.Semaphore(3)  # Max 3 threads

def worker(name):
    with semaphore:
        print(f"{name} working")
        time.sleep(2)
        print(f"{name} done")

threads = [threading.Thread(target=worker, args=(f"Worker {i}",)) for i in range(10)]

for t in threads:
    t.start()

for t in threads:
    t.join()
```

## Thread Local Storage

```python
import threading

# Thread-local data (not shared)
thread_local = threading.local()

def process():
    # Each thread gets its own value
    if not hasattr(thread_local, 'value'):
        thread_local.value = 0
    thread_local.value += 1
    print(f"Thread local value: {thread_local.value}")

threads = [threading.Thread(target=process) for _ in range(5)]

for t in threads:
    t.start()

for t in threads:
    t.join()
```

## Event - Thread Signaling

```python
import threading
import time

event = threading.Event()

def waiter():
    print("Waiting for event...")
    event.wait()  # Blocks until set
    print("Event received!")

def setter():
    time.sleep(2)
    print("Setting event...")
    event.set()  # Releases all waiting threads

t1 = threading.Thread(target=waiter)
t2 = threading.Thread(target=setter)

t1.start()
t2.start()

t1.join()
t2.join()
```

## Common Use Cases

### Thread pool pattern
```python
import threading
import queue

class ThreadPool:
    def __init__(self, num_threads):
        self.tasks = queue.Queue()
        self.threads = []

        for _ in range(num_threads):
            t = threading.Thread(target=self._worker)
            t.daemon = True
            t.start()
            self.threads.append(t)

    def _worker(self):
        while True:
            task = self.tasks.get()
            if task is None:
                break
            task()

    def submit(self, func, *args, **kwargs):
        self.tasks.put((func, args, kwargs))

    def shutdown(self):
        for _ in self.threads:
            self.tasks.put(None)
        for t in self.threads:
            t.join()

pool = ThreadPool(4)
pool.submit(task1, arg1, arg2)
pool.submit(task2)
pool.shutdown()
```

### Producer-consumer
```python
import threading
import queue

def producer(queue):
    for i in range(10):
        queue.put(i)

def consumer(queue):
    while True:
        item = queue.get()
        if item is None:
            break
        process(item)

q = queue.Queue(maxsize=5)  # Bounded queue
```

### Caching with locks
```python
import threading

class Cache:
    def __init__(self):
        self.data = {}
        self.lock = threading.Lock()

    def get(self, key):
        with self.lock:
            return self.data.get(key)

    def set(self, key, value):
        with self.lock:
            self.data[key] = value
```

> **Important**: Python uses GIL (Global Interpreter Lock) - threading is best for I/O-bound tasks, not CPU-bound.
