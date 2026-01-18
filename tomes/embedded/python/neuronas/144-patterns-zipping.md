---
id: "py.patterns.zipping"
title: "Zip"
category: patterns
difficulty: beginner
tags: [python, patterns, zip, iteration]
keywords: [zip, unzip]
use_cases: [parallel iteration, dict creation]
prerequisites: ["py.control.for"]
related: ["py.patterns.enumerate"]
next_topics: []
---

# Zip

Iterate over multiple iterables in parallel.

## Usage

```python
names = ['Alice', 'Bob']
ages = [30, 25]

for name, age in zip(names, ages):
    print(f"{name} is {age}")
```

## Creating Dict

```python
d = dict(zip(names, ages))
```

## Unzipping

```python
pairs = [(1, 'a'), (2, 'b')]
nums, chars = zip(*pairs)
```
