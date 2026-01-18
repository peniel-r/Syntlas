---
id: "python.exceptions"
title: "Exception Handling"
category: language
difficulty: intermediate
tags: [python, exceptions, error-handling, try-except]
keywords: [try, except, finally, raise, custom exceptions]
use_cases: [error recovery, graceful degradation, debugging]
prerequisites: ["python.functions.def"]
related: ["python.patterns.decorators"]
next_topics: ["python.stdlib.logging"]
---

# Exception Handling

Python uses try-except blocks to handle errors gracefully.

## Basic Exception Handling

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")
```

## Multiple Exception Types

```python
try:
    result = int("not a number")
except ValueError:
    print("Invalid number format")
except TypeError:
    print("Wrong type")
except Exception as e:
    print(f"Other error: {e}")
```

## try-except-else-finally

```python
try:
    file = open("data.txt", "r")
    content = file.read()
except FileNotFoundError:
    print("File not found")
except PermissionError:
    print("Permission denied")
else:
    # Runs if no exception
    print(f"Read {len(content)} characters")
finally:
    # Always runs
    if 'file' in locals():
        file.close()
        print("File closed")
```

## Catching Multiple Exceptions

```python
try:
    # Operation that may fail
    result = process_data()
except (ValueError, TypeError) as e:
    print(f"Data error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

## Raising Exceptions

```python
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

try:
    result = divide(10, 0)
except ValueError as e:
    print(f"Error: {e}")
```

## Custom Exceptions

```python
class ValidationError(Exception):
    """Custom exception for validation errors"""
    pass

def validate_age(age):
    if age < 0:
        raise ValidationError("Age cannot be negative")
    if age > 120:
        raise ValidationError("Age too high")
    return True

try:
    validate_age(-5)
except ValidationError as e:
    print(f"Validation failed: {e}")
```

## Exception Chaining

```python
try:
    try:
        int("invalid")
    except ValueError as e:
        raise RuntimeError("Processing failed") from e
except RuntimeError as e:
    print(f"Error: {e}")
    print(f"Caused by: {e.__cause__}")
```

## Re-raising Exceptions

```python
try:
    process_data()
except Exception as e:
    log_error(e)
    raise  # Re-raise same exception
```

## Common Patterns

### Validation
```python
def get_user_input(prompt, validator=None):
    while True:
        try:
            value = input(prompt)
            if validator:
                return validator(value)
            return value
        except ValueError as e:
            print(f"Invalid input: {e}. Try again.")

# Usage
def positive_int(value):
    num = int(value)
    if num <= 0:
        raise ValueError("Must be positive")
    return num

age = get_user_input("Enter age: ", positive_int)
```

### Resource cleanup
```python
def process_file(filename):
    file = None
    try:
        file = open(filename, "r")
        data = file.read()
        return process(data)
    except IOError as e:
        print(f"File error: {e}")
        return None
    finally:
        if file:
            file.close()
```

### Retry logic
```python
import time

def fetch_with_retry(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            return fetch_url(url)
        except ConnectionError:
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt
                time.sleep(wait_time)
            else:
                raise
```

### Context manager for exceptions
```python
from contextlib import contextmanager

@contextmanager
def suppress_exceptions(*exception_types):
    try:
        yield
    except exception_types:
        pass

# Suppress multiple exceptions
with suppress_exceptions(ValueError, TypeError):
    int("invalid")  # No error raised
```

## Best Practices

### Specific exceptions
```python
# BAD: Catch all exceptions
try:
    risky_operation()
except:
    pass  # Silences all errors

# GOOD: Catch specific exceptions
try:
    risky_operation()
except (ValueError, KeyError) as e:
    log_error(e)
    raise
```

### Provide context
```python
# GOOD: Include helpful information
try:
    process_user_data(user_data)
except ValidationError as e:
    raise ValidationError(
        f"Invalid data for user {user_data.get('id', 'unknown')}: {e}"
    ) from e
```

### Avoid bare except
```python
# BAD
try:
    something()
except:
    pass

# GOOD
try:
    something()
except Exception as e:
    log_error(e)
    raise
```

> **Note**: Use exceptions for exceptional conditions, not expected control flow. Use return values for normal flow.
