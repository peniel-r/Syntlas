---
id: "python.patterns.comprehensions"
title: "List, Dict, and Set Comprehensions"
category: pattern
difficulty: intermediate
tags: [python, comprehensions, concise, expressive]
keywords: [list comprehension, dict comprehension, generator expression]
use_cases: [transforming data, filtering, creating collections]
prerequisites: ["python.datastructures.lists", "python.datastructures.dicts", "python.datastructures.sets"]
related: ["python.controlflow.for"]
next_topics: ["python.stdlib.itertools"]
---

# Comprehensions

Comprehensions provide concise syntax for creating collections.

## List Comprehensions

```python
# Basic comprehension
squares = [x**2 for x in range(5)]
# [0, 1, 4, 9, 16]

# With condition (filter)
evens = [x for x in range(10) if x % 2 == 0]
# [0, 2, 4, 6, 8]

# Multiple expressions
pairs = [(x, y) for x in range(3) for y in range(3)]
# [(0, 0), (0, 1), (0, 2), (1, 0), ...]

# With function call
import math
rounded = [round(x) for x in [1.2, 2.8, 3.5]]
# [1, 3, 4]
```

## Dict Comprehensions

```python
# Basic comprehension
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# From existing dict
prices = {"apple": 1.2, "banana": 0.5}
discounted = {k: v * 0.9 for k, v in prices.items()}
# {'apple': 1.08, 'banana': 0.45}

# With condition
positive = {k: v for k, v in prices.items() if v > 1.0}
# {'apple': 1.2}

# Swap keys and values
reversed = {v: k for k, v in prices.items()}
# {1.2: 'apple', 0.5: 'banana'}
```

## Set Comprehensions

```python
# Basic comprehension
squares = {x**2 for x in range(5)}
# {0, 1, 4, 9, 16}

# Remove duplicates from list
numbers = [1, 2, 2, 3, 3, 3, 4]
unique = {x for x in numbers}
# {1, 2, 3, 4}

# With condition
evens_squared = {x**2 for x in range(10) if x % 2 == 0}
# {0, 4, 16, 36, 64}
```

## Generator Expressions

```python
# Generator (lazy evaluation, memory efficient)
squares_gen = (x**2 for x in range(1000000))
# No computation yet

# Consume generator
for square in squares_gen:
    process(square)

# Convert to list
squares_list = list(squares_gen)
```

## Nested Comprehensions

```python
# Flatten 2D list
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [item for row in matrix for item in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Matrix transpose
transpose = [[row[i] for row in matrix] for i in range(len(matrix[0]))]
# [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
```

## Conditional Comprehensions

```python
# Ternary in comprehension
result = [x if x > 0 else 0 for x in [-1, 2, -3, 4]]
# [0, 2, 0, 4]

# Multiple conditions
numbers = list(range(20))
divisible = [x for x in numbers if x % 2 == 0 and x % 3 == 0]
# [0, 6, 12, 18]
```

## Common Use Cases

### Filter and transform
```python
# Get names of users over 25
users = [
    {"name": "Alice", "age": 30},
    {"name": "Bob", "age": 25},
    {"name": "Carol", "age": 28}
]

adults = [u["name"] for u in users if u["age"] >= 25]
# ['Alice', 'Bob', 'Carol']
```

### Create lookup dictionary
```python
# Create ID to name mapping
people = [
    (1, "Alice"),
    (2, "Bob"),
    (3, "Carol")
]

name_by_id = {pid: name for pid, name in people}
# {1: 'Alice', 2: 'Bob', 3: 'Carol'}
```

### Matrix operations
```python
# Identity matrix
n = 3
identity = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
# [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
```

### Extract fields
```python
# Get all email addresses from records
records = [
    {"name": "Alice", "email": "alice@example.com", "age": 30},
    {"name": "Bob", "email": "bob@example.com", "age": 25}
]

emails = [r["email"] for r in records]
# ['alice@example.com', 'bob@example.com']
```

### Count occurrences
```python
text = "hello world hello"
words = text.split()
word_counts = {word: words.count(word) for word in set(words)}
# {'hello': 2, 'world': 1}
```

## Performance Considerations

```python
# List comprehension (fast, creates list)
squares = [x**2 for x in range(10000)]

# Generator expression (memory efficient)
squares_gen = (x**2 for x in range(10000))

# When to use each
# Use list comprehension when:
# - You need random access (list[n])
# - You need to iterate multiple times
# - The result is small

# Use generator expression when:
# - The result is large
# - You only iterate once
# - Memory is a concern
```

## Readability Trade-offs

```python
# Concise but less readable
result = [x if x > 0 else -x for x in numbers if x % 2 == 0]

# More readable (may be better for complex logic)
result = []
for x in numbers:
    if x % 2 == 0:
        result.append(x if x > 0 else -x)
```

> **Best Practice**: Keep comprehensions simple. For complex logic, use regular loops for readability.
