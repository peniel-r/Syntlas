---
id: "python.datastructures.sets"
title: "Sets and Set Operations"
category: datastructure
difficulty: novice
tags: [python, sets, unique, membership]
keywords: [union, intersection, difference, symmetric_difference]
use_cases: [removing duplicates, set operations, fast membership]
prerequisites: ["python.basics.types"]
related: ["python.datastructures.lists", "python.datastructures.dicts"]
next_topics: ["python.controlflow.if"]
---

# Sets

Sets are unordered collections of unique elements, optimized for membership tests.

## Creating Sets

```python
# Empty set (note: {} is an empty dict)
empty = set()

# From list (removes duplicates)
from_list = set([1, 2, 2, 3, 3, 3])
# {1, 2, 3}

# From string (unique characters)
from_string = set("hello")
# {'e', 'h', 'l', 'o'}

# Set literal
numbers = {1, 2, 3, 4, 5}
```

## Basic Operations

```python
a = {1, 2, 3}
b = {3, 4, 5}

# Add elements
a.add(4)     # {1, 2, 3, 4}
a.update([5, 6])  # {1, 2, 3, 4, 5, 6}

# Remove elements
a.remove(1)     # {2, 3, 4, 5, 6} (raises KeyError if not found)
a.discard(2)    # {3, 4, 5, 6} (no error if not found)
a.pop()         # Removes and returns arbitrary element

# Check membership
3 in a  # True
10 in a # False

# Length
len(a)  # 4

# Clear
a.clear()  # set()
```

## Set Operations

```python
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}

# Union (all elements)
a | b   # {1, 2, 3, 4, 5, 6}
a.union(b)  # Same

# Intersection (common elements)
a & b   # {3, 4}
a.intersection(b)  # Same

# Difference (elements in a but not in b)
a - b   # {1, 2}
a.difference(b)  # Same

# Symmetric difference (elements in either but not both)
a ^ b   # {1, 2, 5, 6}
a.symmetric_difference(b)  # Same

# Subset check
{1, 2} <= a  # True (is subset)
a >= {1, 2}    # True (is superset)
```

## Set Comprehensions

```python
# Basic comprehension
squares = {x**2 for x in range(5)}
# {0, 1, 4, 9, 16}

# With condition
evens = {x for x in range(10) if x % 2 == 0}
# {0, 2, 4, 6, 8}
```

## frozenset (Immutable Set)

```python
# Create frozen set (hashable, can be dict key or set element)
frozen = frozenset([1, 2, 3])

# Can be nested
nested = set([frozenset([1, 2]), frozenset([3, 4])])

# Cannot modify
frozen.add(4)  # AttributeError
```

## Common Use Cases

### Remove duplicates from list
```python
items = [1, 2, 2, 3, 3, 3, 4]
unique = list(set(items))
# [1, 2, 3, 4] (order not guaranteed)
```

### Fast membership test
```python
# Sets are O(1) for membership, lists are O(n)
large_set = set(range(1000000))
100000 in large_set  # Very fast

large_list = list(range(1000000))
100000 in large_list  # Slower (linear search)
```

### Find common elements
```python
users_a = {"alice", "bob", "charlie"}
users_b = {"bob", "charlie", "david"}

common = users_a & users_b  # {"bob", "charlie"}
```

### Check for unique elements
```python
def has_duplicates(lst):
    return len(lst) != len(set(lst))

has_duplicates([1, 2, 3])  # False
has_duplicates([1, 2, 2, 3])  # True
```

> **Performance**: Set operations (union, intersection, etc.) are O(min(len(a), len(b))).
