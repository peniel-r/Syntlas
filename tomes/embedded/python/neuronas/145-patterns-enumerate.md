---
id: "py.patterns.enumerate"
title: "Enumerate"
category: patterns
difficulty: beginner
tags: [python, patterns, enumerate, iteration]
keywords: [enumerate, index]
use_cases: [looping with index]
prerequisites: ["python.controlflow.for"]
related: ["py.patterns.zipping"]
next_topics: []
---

# Enumerate

Loop over an iterable and get the index automatically.

## Usage

```python
# Bad
i = 0
for item in items:
    print(i, item)
    i += 1

# Good
for i, item in enumerate(items):
    print(i, item)

# Start index
for i, item in enumerate(items, start=1):
    print(i, item)
```
