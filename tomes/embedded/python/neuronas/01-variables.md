---
id: "python.basics.variables"
title: "Variables and Assignment"
category: language
difficulty: novice
tags: [python, basics, variables, assignment]
keywords: [assignment, binding, naming, convention]
use_cases: [storing data, naming conventions, basic operations]
prerequisites: []
related: ["python.basics.types"]
next_topics: ["python.basics.operators", "python.datastructures.lists"]
---

# Variables and Assignment

In Python, variables are created by assigning values to them. Python uses dynamic typing.

## Basic Assignment

```python
x = 10
name = "Alice"
is_valid = True
price = 19.99
```

## Naming Conventions

- `snake_case` for variables and functions
- `PascalCase` for classes
- `UPPER_CASE` for constants

```python
user_name = "bob"
MAX_RETRIES = 3
class UserProfile:
    pass
```

## Multiple Assignment

```python
# Tuple unpacking
a, b, c = 1, 2, 3

# Swap values
a, b = b, a
```

## Dynamic Typing

Variables can change type:

```python
x = 42        # int
x = "hello"   # str
x = [1, 2, 3] # list
```

> **Best Practice**: Avoid changing variable types unintentionally. Use type hints for clarity.
