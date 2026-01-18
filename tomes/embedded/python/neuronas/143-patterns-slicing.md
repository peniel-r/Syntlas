---
id: "py.patterns.slicing"
title: "Slicing"
category: patterns
difficulty: beginner
tags: [python, patterns, slicing, indexing]
keywords: [slice, start:stop:step]
use_cases: [substrings, reversing, skipping]
prerequisites: ["python.datastructures.lists"]
related: ["python.basics.strings"]
next_topics: []
---

# Slicing

Accessing subsets of sequences. Syntax: `[start:stop:step]`.

## Examples

```python
a = [0, 1, 2, 3, 4, 5]

a[1:4]   # [1, 2, 3]
a[:3]    # [0, 1, 2]
a[3:]    # [3, 4, 5]
a[:]     # Copy of a
a[::2]   # [0, 2, 4] (Every second)
a[::-1]  # [5, 4, 3, 2, 1, 0] (Reverse)
```

## Assignment

```python
a[1:3] = [8, 9]  # Replace range
```
