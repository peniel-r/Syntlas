---
id: "python.datastructures.tuples"
title: "Tuples and Named Tuples"
category: datastructure
difficulty: novice
tags: [python, tuples, immutability, sequences]
keywords: [tuple, namedtuple, unpacking, slicing]
use_cases: [returning multiple values, fixed sequences, immutable data]
prerequisites: ["python.basics.types"]
related: ["python.datastructures.lists", "python.stdlib.typing"]
next_topics: ["python.datastructures.sets"]
---

# Tuples

Tuples are ordered, immutable sequences that can hold any type.

## Creating Tuples

```python
# Empty tuple
empty = ()

# Single element (trailing comma required)
single = (42,)

# Multiple elements
coords = (10, 20, 30)

# Without parentheses (implicit tuple)
implicit = 1, 2, 3  # (1, 2, 3)

# From list or other sequence
from_list = tuple([1, 2, 3])  # (1, 2, 3)
```

## Tuple Operations

```python
point = (10, 20)

# Accessing elements
point[0]   # 10
point[-1]  # 20

# Slicing (returns tuple)
point[0:1]  # (10,)

# Concatenation
more = point + (30, 40)  # (10, 20, 30, 40)

# Repetition
repeated = (1, 2) * 3  # (1, 2, 1, 2, 1, 2)

# Length
len(point)  # 2

# Membership
10 in point  # True
```

## Tuple Unpacking

```python
# Basic unpacking
x, y, z = (1, 2, 3)
# x=1, y=2, z=3

# Swap values
a, b = (10, 20)
a, b = b, a
# a=20, b=10

# Extended unpacking (Python 3.5+)
first, *rest = (1, 2, 3, 4, 5)
# first=1, rest=[2, 3, 4, 5]

*first, last = (1, 2, 3, 4, 5)
# first=[1, 2, 3, 4], last=5
```

## Named Tuples

```python
from collections import namedtuple

Point = namedtuple('Point', ['x', 'y', 'z'])
p = Point(10, 20, 30)

# Access by name
p.x   # 10
p.y   # 20

# Access by index (like regular tuple)
p[0]  # 10

# Unpacking
x, y, z = p

# _make, _asdict, _replace
p2 = Point._make([40, 50, 60])
d = p._asdict()  # {'x': 10, 'y': 20, 'z': 30}
p3 = p._replace(x=100)  # Point(x=100, y=20, z=30)
```

## When to Use Tuples vs Lists

| Scenario | Use |
|----------|------|
| Fixed-size sequence | Tuple |
| Need immutability (hashable keys) | Tuple |
| Mutable, dynamic collection | List |
| Return multiple values from function | Tuple |

```python
# Good: Tuple as dict key (hashable)
cache = {}
cache[(10, 20)] = "value"  # Works

# Bad: List as dict key (not hashable)
cache[[10, 20]] = "value"  # TypeError
```

## Common Patterns

### Returning multiple values
```python
def get_stats(numbers):
    return min(numbers), max(numbers), sum(numbers)

minimum, maximum, total = get_stats([1, 2, 3, 4, 5])
```

### Database rows
```python
Row = namedtuple('Row', ['id', 'name', 'score'])
rows = [
    Row(1, 'Alice', 95),
    Row(2, 'Bob', 88)
]
```

### Coordinate systems
```python
coord2d = (x, y)
coord3d = (x, y, z)
rgba = (255, 128, 0, 128)  # Color with alpha
```

> **Note**: Tuples are immutable - once created, their contents cannot change.
