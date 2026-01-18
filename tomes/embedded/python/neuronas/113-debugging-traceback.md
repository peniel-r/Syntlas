---
id: "py.debugging.traceback"
title: "Traceback"
category: debugging
difficulty: intermediate
tags: [python, debugging, traceback, stack]
keywords: [traceback, print_exc, format_exc]
use_cases: [error logging, stack analysis]
prerequisites: ["py.exceptions.basics"]
related: ["py.lib.logging"]
next_topics: []
---

# Traceback

Extract, format, and print stack traces.

## Printing Exception

```python
import traceback

try:
    1 / 0
except ZeroDivisionError:
    traceback.print_exc()
```

## Formatting as String

```python
s = traceback.format_exc()
print(f"Caught error: {s}")
```
