---
id: "python.functions.def"
title: "Function Definitions"
category: language
difficulty: novice
tags: [python, functions, def, parameters]
keywords: [def, return, parameters, arguments, scope]
use_cases: [code organization, reusability, abstraction]
prerequisites: ["python.controlflow.for"]
related: ["py.functions.lambda", "python.patterns.decorators"]
next_topics: ["py.functions.closures"]
---

# Function Definitions

Functions are reusable blocks of code that perform specific tasks.

## Basic Function

```python
def greet():
    print("Hello, World!")

greet()  # Call the function
```

## Parameters and Arguments

```python
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")  # Output: Hello, Alice!
greet("Bob")    # Output: Hello, Bob!
```

## Multiple Parameters

```python
def greet(name, greeting):
    print(f"{greeting}, {name}!")

greet("Alice", "Hi")
# Output: Hi, Alice!

greet(greeting="Hi", name="Alice")  # Keyword arguments
```

## Default Parameters

```python
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")           # Hello, Alice!
greet("Bob", "Hi")      # Hi, Bob!
```

## Return Values

```python
def add(a, b):
    return a + b

result = add(5, 3)
print(result)  # 8

# Return multiple values as tuple
def get_name_age():
    return "Alice", 30

name, age = get_name_age()
# name="Alice", age=30
```

## Variable Arguments

### *args - Positional arguments

```python
def sum_all(*args):
    total = 0
    for num in args:
        total += num
    return total

sum_all(1, 2, 3)       # 6
sum_all(1, 2, 3, 4, 5)  # 15
```

### **kwargs - Keyword arguments

```python
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=30, city="NYC")
# Output:
# name: Alice
# age: 30
# city: NYC
```

## Type Hints (Python 3.5+)

```python
def add(a: int, b: int) -> int:
    return a + b

def greet(name: str) -> None:
    print(f"Hello, {name}!")

# Complex types
from typing import List, Dict, Optional

def process_data(items: List[int]) -> Dict[str, int]:
    return {"count": len(items), "total": sum(items)}

def find_user(user_id: int) -> Optional[Dict[str, str]]:
    # Returns dict or None
    pass
```

## Function Scope

```python
x = "global"

def outer():
    x = "outer"

    def inner():
        x = "inner"
        print(x)  # inner

    inner()
    print(x)  # outer

outer()
print(x)  # global
```

## Docstrings

```python
def calculate_area(width: float, height: float) -> float:
    """
    Calculate the area of a rectangle.

    Args:
        width: The width of the rectangle
        height: The height of the rectangle

    Returns:
        The area of the rectangle

    Example:
        >>> calculate_area(5.0, 3.0)
        15.0
    """
    return width * height
```

## Lambda Functions

```python
# Anonymous function
square = lambda x: x**2
add = lambda a, b: a + b

square(5)  # 25
add(3, 4)  # 7

# Use with sorted
pairs = [(1, 'one'), (3, 'three'), (2, 'two')]
pairs.sort(key=lambda x: x[0])
# [(1, 'one'), (2, 'two'), (3, 'three')]

# Use with filter
numbers = [1, 2, 3, 4, 5, 6]
evens = list(filter(lambda x: x % 2 == 0, numbers))
# [2, 4, 6]

# Use with map
squares = list(map(lambda x: x**2, numbers))
# [1, 4, 9, 16, 25, 36]
```

## Common Patterns

### Default mutable arguments pitfall
```python
# WRONG - creates one list for all calls
def append_to_list(item, items=[]):
    items.append(item)
    return items

# CORRECT - create new list each call
def append_to_list(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### Optional parameters
```python
def send_email(to, subject, body, cc=None, bcc=None):
    email = {
        "to": to,
        "subject": subject,
        "body": body
    }
    if cc:
        email["cc"] = cc
    if bcc:
        email["bcc"] = bcc
    return email
```

### Validation in functions
```python
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Both arguments must be numbers")
    return a / b
```

> **Best Practice**: Keep functions small and focused on a single task.
