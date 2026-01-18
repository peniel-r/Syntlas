---
id: "py.profiling.cprofile"
title: "Profiling (cProfile)"
category: profiling
difficulty: advanced
tags: [python, profiling, performance]
keywords: [cProfile, profile, run]
use_cases: [optimization, bottleneck detection]
prerequisites: ["py.basics.functions"]
related: ["py.lib.time"]
next_topics: []
---

# cProfile

Deterministic profiling of Python programs.

## CLI Usage

```bash
python -m cProfile myscript.py
```

## Code Usage

```python
import cProfile

def heavy():
    sum([i**2 for i in range(10000)])

cProfile.run('heavy()')
```
