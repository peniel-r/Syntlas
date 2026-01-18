---
id: "py.patterns.unpacking"
title: "Unpacking"
category: patterns
difficulty: beginner
tags: [python, patterns, unpacking, tuple]
keywords: [unpacking, tuple unpacking, star operator]
use_cases: [swapping variables, returning multiple values]
prerequisites: ["python.datastructures.tuples"]
related: ["py.functions.args-kwargs"]
next_topics: []
---

# Unpacking

Assigning elements of an iterable to multiple variables.

## Basic

```python
x, y = (1, 2)
```

## Swapping

```python
a, b = b, a
```

## Extended Unpacking (*)

```python
first, *middle, last = [1, 2, 3, 4, 5]
print(middle)  # [2, 3, 4]
```

## Ignored Values (_)

```python
_, filename = "/path/to/file.txt".rsplit('/', 1)
```
