---
id: "python.patterns.context-managers"
title: "Context Managers"
category: pattern
difficulty: intermediate
tags: [python, context-managers, with, resources]
keywords: [__enter__, __exit__, contextlib]
use_cases: [resource cleanup, file handling, locks]
prerequisites: ["python.classes"]
related: ["py.io.files"]
next_topics: ["py.io.files"]
---

# Context Managers

Context managers manage resources and ensure proper cleanup.

## Basic with Statement

```python
# File handling - automatic close
with open("file.txt", "r") as f:
    content = f.read()
# File automatically closed here

# Lock handling - automatic release
import threading

lock = threading.Lock()

with lock:
    # Critical section
    shared_resource += 1
# Lock automatically released here
```

## Custom Context Manager

```python
class Timer:
    def __init__(self, name):
        self.name = name

    def __enter__(self):
        self.start = time.time()
        print(f"Starting {self.name}")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        elapsed = time.time() - self.start
        print(f"Finished {self.name} in {elapsed:.2f}s")
        # Return False to propagate exceptions
        # Return True to suppress exceptions
        return False

import time

with Timer("operation"):
    time.sleep(1)
```

## Exception Handling in Context Managers

```python
class SafeOperation:
    def __enter__(self):
        print("Starting operation")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is None:
            print("Operation succeeded")
        else:
            print(f"Operation failed: {exc_val}")
            # Return True to suppress exception
            # Return False to propagate exception
            return True

with SafeOperation():
    raise ValueError("Something went wrong")
# Exception is suppressed
print("Continuing...")
```

## contextlib.contextmanager

Decorator for creating simple context managers with generators.

```python
from contextlib import contextmanager

@contextmanager
def timer(name):
    start = time.time()
    print(f"Starting {name}")
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f}s")

with timer("operation"):
    time.sleep(1)
```

## contextlib.closing

Ensure objects with `close()` method are properly closed.

```python
from contextlib import closing

from urllib.request import urlopen

with closing(urlopen("https://example.com")) as page:
    content = page.read()
# Automatically closed
```

## contextlib.suppress

Suppress specific exceptions.

```python
from contextlib import suppress

# Suppress FileNotFoundError
with suppress(FileNotFoundError):
    os.remove("nonexistent.txt")

# Suppress multiple exceptions
with suppress(ValueError, TypeError):
    int("not a number")
```

## contextlib.redirect_stdout/stderr

Redirect output streams.

```python
from contextlib import redirect_stdout
import io

output = io.StringIO()

with redirect_stdout(output):
    print("This goes to StringIO")

result = output.getvalue()
print(result)  # "This goes to StringIO\n"
```

## Common Patterns

### Database connection
```python
class DatabaseConnection:
    def __init__(self, db_url):
        self.db_url = db_url
        self.connection = None

    def __enter__(self):
        self.connection = self.connect()
        return self.connection

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type:
            self.connection.rollback()
        else:
            self.connection.commit()
        self.connection.close()
        return False

with DatabaseConnection("postgres://...") as conn:
    result = conn.execute("SELECT * FROM users")
```

### Temporary directory
```python
import tempfile
import os

with tempfile.TemporaryDirectory() as temp_dir:
    temp_file = os.path.join(temp_dir, "data.txt")
    with open(temp_file, "w") as f:
        f.write("Temporary data")
# Directory automatically deleted
```

### Transaction rollback
```python
class Transaction:
    def __init__(self, db):
        self.db = db

    def __enter__(self):
        self.db.begin_transaction()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type:
            self.db.rollback()
            print("Transaction rolled back")
        else:
            self.db.commit()
            print("Transaction committed")
        return False

with Transaction(db):
    db.execute("INSERT INTO users ...")
    db.execute("UPDATE accounts ...")
```

### Change working directory
```python
from contextlib import contextmanager
import os

@contextmanager
def change_directory(path):
    original = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(original)

with change_directory("/tmp"):
    print(os.getcwd())
# Back to original directory
```

## Nested Context Managers

```python
# Multiple with statements
with open("input.txt", "r") as infile, \
     open("output.txt", "w") as outfile:
    content = infile.read()
    outfile.write(content.upper())

# Using ExitStack for dynamic number of contexts
from contextlib import ExitStack

files = ["file1.txt", "file2.txt", "file3.txt"]

with ExitStack() as stack:
    handles = [stack.enter_context(open(f, "r")) for f in files]
    # All files automatically closed
```

> **Best Practice**: Use context managers for any resource that needs cleanup (files, locks, connections, etc.).
