---
id: "python.basics.types"
title: "Built-in Data Types"
category: language
difficulty: novice
tags: [python, basics, types, primitive]
keywords: [int, float, str, bool, type conversion, casting]
use_cases: [data storage, type checking, type conversion]
prerequisites: ["python.basics.variables"]
related: ["python.datastructures.lists", "python.datastructures.dicts"]
next_topics: ["python.basics.operators"]
---

# Built-in Data Types

Python has several built-in data types organized by their purpose.

## Numeric Types

### int
Whole numbers of arbitrary precision.

```python
x = 42
big_number = 10**100  # Python handles big integers
```

### float
Floating-point numbers.

```python
pi = 3.14159
scientific = 1.23e-4  # 0.000123
```

### complex
Complex numbers with real and imaginary parts.

```python
z = 3 + 4j
```

## Sequence Types

### str
Immutable sequences of Unicode characters.

```python
text = "Hello, World!"
multiline = """Multiple
lines"""
```

### bytes
Immutable sequence of bytes.

```python
data = b"raw bytes"
```

## Boolean Type

### bool
True or False values.

```python
is_active = True
has_errors = False
```

## None Type

### NoneType
Represents absence of a value.

```python
result = None
if result is None:
    print("No result found")
```

## Type Checking

```python
x = 42
print(type(x))  # <class 'int'>

is_string = isinstance(x, str)  # False
is_number = isinstance(x, (int, float))  # True
```

## Type Conversion

```python
int("42")        # 42
str(123)         # "123"
float("3.14")    # 3.14
bool(1)           # True
bool(0)           # False
list("abc")       # ['a', 'b', 'c']
```

> **Note**: Python's `int` can grow arbitrarily large, avoiding overflow issues.
