---
id: "python.stdlib.functools"
title: "Functools - Higher-Order Functions"
category: stdlib
difficulty: intermediate
tags: [python, functools, partial, reduce, wraps]
keywords: [partial, lru_cache, reduce, cmp_to_key]
use_cases: [function transformation, memoization, comparison]
prerequisites: ["python.functions.def"]
related: ["python.patterns.decorators"]
next_topics: ["py.lib.math"]
---

# Functools

`functools` provides tools for working with functions.

## partial - Fix Arguments

```python
from functools import partial

def power(base, exponent):
    return base ** exponent

# Fix first argument
square = partial(power, exponent=2)
cube = partial(power, exponent=3)

square(5)   # 25 (same as power(5, 2))
cube(5)      # 125 (same as power(5, 3))
```

## lru_cache - Memoization

```python
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# Fast - results cached
print(fibonacci(100))

# Cache statistics
print(fibonacci.cache_info())
# CacheInfo(hits=98, misses=101, maxsize=128, currsize=128)

# Clear cache
fibonacci.cache_clear()
```

## reduce - Reduce to Single Value

```python
from functools import reduce

numbers = [1, 2, 3, 4, 5]

# Sum
total = reduce(lambda x, y: x + y, numbers)
# 15

# Product
product = reduce(lambda x, y: x * y, numbers)
# 120

# With initializer
total_with_init = reduce(lambda x, y: x + y, numbers, 10)
# 25 (10 + 1 + 2 + 3 + 4 + 5)
```

## wraps - Preserve Metadata

```python
from functools import wraps

def my_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@my_decorator
def add(a, b):
    """Add two numbers."""
    return a + b

# Metadata preserved
print(add.__name__)  # 'add'
print(add.__doc__)   # 'Add two numbers.'
```

## cmp_to_key - Custom Sorting (Python 3.2+)

```python
from functools import cmp_to_key

class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

def compare_users(a, b):
    if a.age < b.age:
        return -1
    if a.age > b.age:
        return 1
    return 0

users = [User("Alice", 30), User("Bob", 25), User("Carol", 28)]

# Sort by age using comparator
users.sort(key=cmp_to_key(compare_users))
for user in users:
    print(f"{user.name}: {user.age}")
```

## total_ordering - Rich Comparison

```python
from functools import total_ordering

@total_ordering
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def _lt__(self, other):
        return self.age < other.age

    def _eq__(self, other):
        return self.age == other.age

users = [User("Alice", 30), User("Bob", 25)]
users.sort()  # Works with < and == operators
```

## singledispatch - Type-Based Dispatch

```python
from functools import singledispatch

@singledispatch
def process(value):
    raise NotImplementedError(f"No handler for {type(value)}")

@process.register
def _(value: int):
    print(f"Processing int: {value}")

@process.register
def _(value: str):
    print(f"Processing str: {value}")

@process.register
def _(value: list):
    print(f"Processing list: {value}")

process(42)         # "Processing int: 42"
process("hello")     # "Processing str: hello"
process([1, 2, 3]) # "Processing list: [1, 2, 3]"
```

## update_wrapper - Copy Metadata

```python
from functools import update_wrapper

def debug(func):
    def wrapper(*args, **kwargs):
        print(f"DEBUG: {func.__name__}")
        return func(*args, **kwargs)
    # Copy metadata
    return update_wrapper(wrapper, func)

@debug
def calculate(x, y):
    """Calculate something."""
    return x + y

print(calculate.__name__)  # 'calculate'
```

## Common Use Cases

### Configuration with partial
```python
from functools import partial
import requests

def fetch(url, method, headers=None, timeout=30):
    return requests.request(method, url, headers=headers, timeout=timeout)

# Create specialized fetchers
get = partial(fetch, method="GET")
post = partial(fetch, method="POST")

get("https://api.example.com/data")
post("https://api.example.com/create", json={"name": "Alice"})
```

### Expensive computation cache
```python
from functools import lru_cache

@lru_cache(maxsize=32)
def expensive_computation(x):
    print(f"Computing {x}...")
    import time
    time.sleep(0.1)  # Simulate work
    return x ** 2

# First call - computes
expensive_computation(5)

# Second call - cached (no computation)
expensive_computation(5)
```

### Dynamic decorator with arguments
```python
from functools import wraps

def repeat(times):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            results = []
            for _ in range(times):
                results.append(func(*args, **kwargs))
            return results
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")  # Prints 3 times
```

### Building transformation pipeline
```python
from functools import reduce

def pipeline(data, *functions):
    """Apply functions in sequence."""
    return reduce(lambda d, f: f(d), functions, data)

def uppercase(s):
    return s.upper()

def reverse(s):
    return s[::-1]

def add_exclamation(s):
    return s + "!"

result = pipeline("hello", uppercase, reverse, add_exclamation)
# "!OLLEH"
```

### Custom sorting
```python
from functools import cmp_to_key

def custom_compare(a, b):
    # Custom comparison logic
    if a.priority != b.priority:
        return -1 if a.priority > b.priority else 1
    if a.created_at < b.created_at:
        return -1
    return 1

items = [...]
items.sort(key=cmp_to_key(custom_compare))
```

> **Tip**: Use `lru_cache` for memoization of expensive pure functions.
