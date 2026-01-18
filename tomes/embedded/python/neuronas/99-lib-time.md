---
id: "py.lib.time"
title: "Time (time)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, time]
keywords: [time, sleep, perf_counter, time]
use_cases: [benchmarking, delays]
prerequisites: ["python.basics.variables"]
related: ["python.stdlib.datetime"]
next_topics: []
---

# Time Module

Low-level time access.

## Functions

```python
import time

time.time()             # Unix timestamp (seconds)
time.sleep(1)           # Pause for 1 second

# High resolution timer for benchmarking
start = time.perf_counter()
# ... code ...
end = time.perf_counter()
print(f"Elapsed: {end - start}")
```
