---
id: "py.concurrency.multiprocessing"
title: "Multiprocessing"
category: concurrency
difficulty: advanced
tags: [python, concurrency, multiprocessing, parallelism]
keywords: [Process, Pool, cpu-bound]
use_cases: [cpu-bound tasks, parallelism]
prerequisites: ["py.basics.functions"]
related: ["py.concurrency.concurrent-futures"]
next_topics: []
---

# Multiprocessing

Python's GIL (Global Interpreter Lock) limits threads to one CPU core. Use `multiprocessing` for true parallelism (CPU-bound tasks).

## Process

```python
from multiprocessing import Process

def f(name):
    print(f'hello {name}')

if __name__ == '__main__':
    p = Process(target=f, args=('bob',))
    p.start()
    p.join()
```

## Pool

Manages a pool of worker processes.

```python
from multiprocessing import Pool

with Pool(5) as p:
    print(p.map(lambda x: x*x, [1, 2, 3]))
```
