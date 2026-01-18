---
id: "py.functional.map-filter"
title: "Map, Filter, Reduce"
category: functional
difficulty: intermediate
tags: [python, functional, map, filter, reduce]
keywords: [map, filter, reduce, functools]
use_cases: [data transformation, filtering]
prerequisites: ["py.functions.lambda", "py.functions.generators"]
related: ["py.control.comprehensions"]
next_topics: []
---

# Map, Filter, Reduce

Functional programming primitives.

## Map

Applies a function to all items.

```python
nums = [1, 2, 3]
squared = map(lambda x: x**2, nums)  # Returns iterator
```

## Filter

Keeps items where function returns True.

```python
evens = filter(lambda x: x % 2 == 0, nums)
```

## Reduce

Applies a rolling computation. (Needs import)

```python
from functools import reduce
total = reduce(lambda x, y: x + y, nums)  # 6
```
