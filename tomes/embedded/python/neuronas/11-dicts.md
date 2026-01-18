---
id: "python.datastructures.dicts"
title: "Dictionaries and Dictionary Operations"
category: datastructure
difficulty: novice
tags: [python, dictionaries, maps, key-value]
keywords: [dict, keys, values, items, get, comprehension]
use_cases: [key-value storage, lookup tables, caching]
prerequisites: ["python.basics.types"]
related: ["python.datastructures.lists", "python.patterns.comprehensions"]
next_topics: ["python.datastructures.sets"]
---

# Dictionaries

Dictionaries are unordered collections of key-value pairs, optimized for fast lookups.

## Creating Dictionaries

```python
# Empty dict
empty = {}

# With initial values
person = {
    "name": "Alice",
    "age": 30,
    "city": "NYC"
}

# Using dict constructor
user = dict(name="Bob", age=25)  # {'name': 'Bob', 'age': 25}

# From list of tuples
pairs = [("a", 1), ("b", 2)]
d = dict(pairs)  # {'a': 1, 'b': 2}
```

## Accessing Values

```python
scores = {"math": 95, "english": 88, "history": 92}

scores["math"]        # 95 (direct access)
scores.get("math")    # 95 (safe access, returns None if not found)
scores.get("art", 0)  # 0 (default value if not found)

scores["science"]     # KeyError (raises exception if key missing)
```

## Adding and Updating

```python
user = {"name": "Alice"}

user["age"] = 30        # Add new key
user["name"] = "Carol"   # Update existing key

# Update with another dict
user.update({"city": "NYC", "email": "alice@example.com"})
```

## Removing Items

```python
data = {"a": 1, "b": 2, "c": 3}

del data["b"]     # Remove by key (raises KeyError if missing)
val = data.pop("c")  # Remove and return value (raises KeyError if missing)
val = data.pop("d", 0)  # Remove with default

data.clear()       # Remove all items
```

## Dictionary Methods

```python
scores = {"math": 95, "english": 88, "history": 92}

scores.keys()      # dict_keys(['math', 'english', 'history'])
scores.values()    # dict_values([95, 88, 92])
scores.items()     # dict_items([('math', 95), ('english', 88), ('history', 92)])

"math" in scores       # True (key membership)
scores.get("math")     # 95
scores.setdefault("art", 75)  # 75 (returns existing or adds default)

# Convert to list
list(scores.keys())   # ['math', 'english', 'history']
```

## Dictionary Comprehensions

```python
# Basic comprehension
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# With condition
evens = {x: x**2 for x in range(10) if x % 2 == 0}
# {0: 0, 2: 4, 4: 16, 6: 36, 8: 64}

# From existing dict
prices = {"apple": 1.2, "banana": 0.5}
discounted = {k: v * 0.9 for k, v in prices.items()}
# {'apple': 1.08, 'banana': 0.45}
```

## Nested Dictionaries

```python
users = {
    "alice": {"name": "Alice", "age": 30},
    "bob": {"name": "Bob", "age": 25}
}

users["alice"]["age"]  # 30
```

## Dictionary Ordering

From Python 3.7+, dictionaries preserve insertion order.

```python
d = {}
d["a"] = 1
d["b"] = 2
d["c"] = 3

list(d.keys())  # ['a', 'b', 'c'] (preserves order)
```

## Common Patterns

### Counting occurrences
```python
from collections import Counter

text = "hello world"
counts = Counter(text)  # {'h': 1, 'e': 1, 'l': 3, ...}
```

### Grouping data
```python
from collections import defaultdict

groups = defaultdict(list)
groups["fruits"].append("apple")
groups["fruits"].append("banana")
# groups["fruits"] automatically created as []
```

### Cache/memoization
```python
cache = {}

def expensive_calc(n):
    if n in cache:
        return cache[n]
    result = n * n  # expensive operation
    cache[n] = result
    return result
```

> **Performance**: Dictionary lookups are O(1) on average.
