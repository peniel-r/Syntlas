---
id: "python.best-practices"
title: "Python Best Practices"
category: pattern
difficulty: intermediate
tags: [python, best-practices, code-style, conventions]
keywords: [pep8, readability, maintainability, performance]
use_cases: [writing better code, code reviews, learning]
prerequisites: ["python.functions.def", "python.classes"]
related: ["python.typing", "python.patterns.comprehensions"]
next_topics: []
---

# Python Best Practices

Follow these guidelines to write clean, maintainable Python code.

## Code Style (PEP 8)

```python
# Use snake_case for variables and functions
user_name = "Alice"
def calculate_total(): pass

# Use PascalCase for classes
class UserProfile: pass

# Use UPPER_CASE for constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30

# 4 spaces indentation (no tabs)
def function():
    if condition:
        do_something()

# Maximum line length: 79 characters (soft), 99 (hard)
```

## Variable Naming

```python
# GOOD: Descriptive names
user_age = 25
total_amount = calculate_total(items)

# BAD: Short or cryptic names
x = 25
a = calculate_total(i)
```

## Function Design

```python
# Keep functions small and focused
# BAD
def process_user_data(data):
    # 50 lines doing everything
    pass

# GOOD
def validate_user(data):
    """Validate user data structure."""
    pass

def sanitize_user(data):
    """Remove sensitive data."""
    pass

def save_user(data):
    """Save user to database."""
    pass

# Single responsibility
result = save_user(sanitize_user(validate_user(raw_data)))
```

## Docstrings

```python
def calculate_area(width: float, height: float) -> float:
    """
    Calculate rectangle area.

    Args:
        width: Rectangle width in meters
        height: Rectangle height in meters

    Returns:
        Area in square meters

    Raises:
        ValueError: If dimensions are negative

    Example:
        >>> calculate_area(5.0, 3.0)
        15.0
    """
    if width < 0 or height < 0:
        raise ValueError("Dimensions must be positive")
    return width * height
```

## Error Handling

```python
# Handle specific exceptions
# BAD
try:
    process()
except:
    pass  # Swallows all errors

# GOOD
try:
    process()
except ValueError as e:
    log_error(f"Invalid value: {e}")
    raise
except ConnectionError as e:
    log_error(f"Connection failed: {e}")
    raise
```

## Type Hints

```python
# Add type hints for public functions
from typing import List, Optional

def get_users(min_age: int = 0) -> List[dict]:
    """Get users older than min_age."""
    pass

def find_user(user_id: int) -> Optional[dict]:
    """Find user by ID or return None."""
    pass
```

## List Comprehensions vs Loops

```python
# Use comprehensions for simple transformations
# GOOD
squares = [x**2 for x in range(100)]

# Use loops for complex logic
# GOOD (more readable than complex comprehension)
result = []
for item in data:
    if complex_condition(item):
        processed = transform(item)
        if another_condition(processed):
            result.append(processed)
```

## String Formatting

```python
# Prefer f-strings (Python 3.6+)
name = "Alice"
age = 30

# GOOD
message = f"Hello, {name}. You are {age} years old."

# AVOID (older styles)
message = "Hello, {}. You are {} years old.".format(name, age)
message = "Hello, %s. You are %d years old." % (name, age)
```

## Context Managers

```python
# Use context managers for resources
# GOOD
with open("file.txt", "r") as f:
    data = f.read()

# AVOID
f = open("file.txt", "r")
data = f.read()
f.close()
```

## Constants and Configuration

```python
# Use constants instead of magic numbers
# BAD
def calculate_circle_area(radius):
    return 3.14159 * radius ** 2

# GOOD
import math

PI = math.pi

def calculate_circle_area(radius):
    return PI * radius ** 2
```

## Avoid Global State

```python
# BAD: Global variable
counter = 0

def increment():
    global counter
    counter += 1

# GOOD: Pass state explicitly
def increment(counter: int) -> int:
    return counter + 1

counter = 0
counter = increment(counter)
```

## DRY (Don't Repeat Yourself)

```python
# BAD: Repeated logic
if user_role == "admin":
    print("Access granted")
elif user_role == "moderator":
    print("Access granted")

# GOOD: Extract common logic
def has_access(role: str) -> bool:
    return role in ["admin", "moderator"]

if has_access(user_role):
    print("Access granted")
```

## Early Returns

```python
# BAD: Deep nesting
def process(user):
    if user:
        if user.is_active:
            if user.has_permission:
                if user.is_verified:
                    return True

# GOOD: Early returns
def process(user):
    if not user:
        return False
    if not user.is_active:
        return False
    if not user.has_permission:
        return False
    if not user.is_verified:
        return False
    return True
```

## Enumerations

```python
from enum import Enum

class Status(Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"

def process_status(status: Status):
    if status == Status.APPROVED:
        print("Approved!")
```

## Performance Considerations

```python
# Use sets for membership tests
# BAD
if item in large_list:  # O(n)
    pass

# GOOD
if item in large_set:  # O(1)
    pass

# Use generators for large data
# BAD
numbers = [x**2 for x in range(1000000)]  # Memory heavy

# GOOD
numbers = (x**2 for x in range(1000000))  # Lazy evaluation
```

## Testing

```python
import unittest

class TestMath(unittest.TestCase):
    def test_addition(self):
        self.assertEqual(add(2, 3), 5)

    def test_division_by_zero(self):
        with self.assertRaises(ZeroDivisionError):
            divide(10, 0)

if __name__ == "__main__":
    unittest.main()
```

## Security

```python
# Avoid eval() and exec()
# BAD - security risk
result = eval(user_input)  # User can execute arbitrary code

# GOOD - use safer alternatives
import ast
result = ast.literal_eval(user_input)  # Safe for literals only

# Avoid SQL injection
# BAD
query = f"SELECT * FROM users WHERE name = '{user_input}'"

# GOOD - use parameterized queries
query = "SELECT * FROM users WHERE name = %s"
cursor.execute(query, (user_input,))
```

## Virtual Environments

```bash
# Create virtual environment
python -m venv myenv

# Activate (Linux/Mac)
source myenv/bin/activate

# Activate (Windows)
myenv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

> **Key Resource**: [PEP 8 Style Guide](https://peps.python.org/pep-0008/)
