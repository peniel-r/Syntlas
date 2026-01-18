---
id: "python.patterns.decorators"
title: "Decorators"
category: pattern
difficulty: intermediate
tags: [python, decorators, meta-programming, functions]
keywords: [@, wrapper, functools, closure]
use_cases: [logging, timing, validation, caching]
prerequisites: ["python.functions.def"]
related: ["python.functions.lambda", "python.context-managers"]
next_topics: ["python.patterns.context-managers"]
---

# Decorators

Decorators modify or wrap functions to add behavior.

## Basic Decorator

```python
def my_decorator(func):
    def wrapper():
        print("Before function call")
        result = func()
        print("After function call")
        return result
    return wrapper

@my_decorator
def greet():
    print("Hello!")

greet()
# Output:
# Before function call
# Hello!
# After function call
```

## Decorator with Arguments

```python
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")
# Output: Hello, Alice! (3 times)
```

## Preserving Function Metadata

```python
import functools

def my_decorator(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@my_decorator
def add(a, b):
    """Add two numbers."""
    return a + b

# Original name and docstring preserved
print(add.__name__)  # 'add'
print(add.__doc__)   # 'Add two numbers.'
```

## Common Use Cases

### Timing decorator

```python
import time
import functools

def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f}s")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)
    return "done"

slow_function()
```

### Logging decorator

```python
import functools

def log_calls(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with {args}, {kwargs}")
        result = func(*args, **kwargs)
        print(f"{func.__name__} returned {result}")
        return result
    return wrapper

@log_calls
def add(a, b):
    return a + b

add(5, 3)
```

### Retry decorator

```python
import functools
import time

def retry(max_attempts=3, delay=1):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    print(f"Attempt {attempt + 1} failed: {e}")
                    if attempt < max_attempts - 1:
                        time.sleep(delay)
            raise last_exception
        return wrapper
    return decorator

@retry(max_attempts=3)
def unstable_api_call():
    # Simulated unstable API
    import random
    if random.random() < 0.7:
        raise ConnectionError("Failed")
    return "success"

unstable_api_call()
```

### Memoization (cache)

```python
import functools

@functools.lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# Cached results - much faster for repeated calls
print(fibonacci(100))
print(fibonacci.cache_info())  # Cache statistics
```

### Validation decorator

```python
import functools

def validate_types(**type_map):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for arg_name, expected_type in type_map.items():
                if arg_name in kwargs:
                    value = kwargs[arg_name]
                    if not isinstance(value, expected_type):
                        raise TypeError(
                            f"{arg_name} must be {expected_type.__name__}"
                        )
            return func(*args, **kwargs)
        return wrapper
    return decorator

@validate_types(age=int, name=str)
def create_user(name, age):
    return {"name": name, "age": age}

create_user("Alice", 30)  # OK
create_user("Alice", "30")  # TypeError
```

## Class-Based Decorators

```python
class CountCalls:
    def __init__(self, func):
        self.func = func
        self.count = 0

    def __call__(self, *args, **kwargs):
        self.count += 1
        print(f"Call #{self.count} to {self.func.__name__}")
        return self.func(*args, **kwargs)

@CountCalls
def greet():
    print("Hello!")

greet()
greet()
```

## Stacking Decorators

```python
import functools

@timer
@log_calls
def process_data(data):
    time.sleep(1)
    return data.upper()

# Both decorators applied: logs then times
process_data("hello")
```

## Property decorators

```python
class Person:
    def __init__(self, first_name, last_name):
        self._first_name = first_name
        self._last_name = last_name

    @property
    def full_name(self):
        """Computed property"""
        return f"{self._first_name} {self._last_name}"

    @full_name.setter
    def full_name(self, value):
        parts = value.split()
        self._first_name = parts[0]
        self._last_name = " ".join(parts[1:])

person = Person("Alice", "Smith")
print(person.full_name)  # Alice Smith

person.full_name = "Bob Jones"
print(person._first_name)  # Bob
```

> **Best Practice**: Use `@functools.wraps` to preserve function metadata in custom decorators.
