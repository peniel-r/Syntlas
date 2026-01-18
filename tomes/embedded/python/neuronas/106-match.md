---
id: "python.match"
title: "Match Statement (Python 3.10+)"
category: language
difficulty: intermediate
tags: [python, match, pattern-matching, controlflow]
keywords: [match, case, _, guards]
use_cases: [pattern matching, structural decomposition, clean conditionals]
prerequisites: ["python.controlflow.if"]
related: ["python.datastructures.lists"]
next_topics: []
---

# Match Statement

Python 3.10+ introduces structural pattern matching with `match`.

## Basic Match

```python
value = 42

match value:
    case 1:
        print("One")
    case 2:
        print("Two")
    case _:
        print("Something else")
```

## Matching Multiple Values

```python
def describe(value):
    match value:
        case 0 | 1 | 2:
            return "Small"
        case 3 | 4 | 5:
            return "Medium"
        case _:
            return "Large"

describe(3)  # "Medium"
```

## Matching Types

```python
def process(value):
    match value:
        case int():
            return f"Integer: {value}"
        case str():
            return f"String: {value}"
        case list():
            return f"List with {len(value)} items"
        case _:
            return f"Unknown type: {type(value).__name__}"
```

## Matching Structures

```python
def greet(person):
    match person:
        case {"name": name, "age": age}:
            return f"Hello {name}, you are {age}"
        case {"name": name}:
            return f"Hello {name}"
        case _:
            return "Hello, stranger"

greet({"name": "Alice", "age": 30})  # "Hello Alice, you are 30"
```

## Matching Sequences

```python
def analyze(data):
    match data:
        case []:
            return "Empty"
        case [x]:
            return f"Single: {x}"
        case [x, y]:
            return f"Pair: {x}, {y}"
        case [first, *rest, last]:
            return f"First: {first}, Last: {last}, Middle: {rest}"
        case _:
            return "Other"

analyze([1, 2, 3, 4, 5])
# "First: 1, Last: 5, Middle: [2, 3, 4]"
```

## Unpacking with match

```python
point = (10, 20)

match point:
    case (x, y):
        print(f"Point at ({x}, {y})")
```

## Guards - Conditions in Cases

```python
def categorize(value):
    match value:
        case x if x < 0:
            return "Negative"
        case x if x == 0:
            return "Zero"
        case x if x > 0:
            return "Positive"

categorize(5)  # "Positive"
```

## Matching Classes with Patterns

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

def distance(origin, target):
    match (origin, target):
        case (Point(x1=x1, y1=y1), Point(x2=x2, y2=y2)):
            return ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5
        case _:
            raise ValueError("Not both points")

p1 = Point(0, 0)
p2 = Point(3, 4)
print(distance(p1, p2))
```

## Nested Matching

```python
def process_event(event):
    match event:
        case {"type": "message", "content": msg}:
            print(f"Message: {msg}")
        case {"type": "click", "target": {"element": element}}:
            print(f"Clicked on {element}")
        case {"type": "error", "code": code} if code >= 500:
            print(f"Server error: {code}")
        case _:
            print("Unknown event")
```

## match vs if-elif Chains

```python
# OLD: if-elif chains
def http_status(status_code):
    if status_code == 200:
        return "OK"
    elif status_code == 404:
        return "Not Found"
    elif status_code in [301, 302, 303]:
        return "Redirect"
    else:
        return "Other"

# NEW: match statement (Python 3.10+)
def http_status(status_code):
    match status_code:
        case 200:
            return "OK"
        case 404:
            return "Not Found"
        case 301 | 302 | 303:
            return "Redirect"
        case _:
            return "Other"
```

## Common Use Cases

### State machine
```python
def process_state(state, event):
    match state, event:
        case "idle", "start":
            return "running"
        case "running", "stop":
            return "idle"
        case "running", "error":
            return "error"
        case "error", "reset":
            return "idle"
        case _:
            return state
```

### AST traversal
```python
def evaluate(node):
    match node:
        case {"type": "literal", "value": value}:
            return value
        case {"type": "binary", "op": "+", "left": left, "right": right}:
            return evaluate(left) + evaluate(right)
        case {"type": "binary", "op": "*", "left": left, "right": right}:
            return evaluate(left) * evaluate(right)
```

### Command line parsing
```python
def handle_command(args):
    match args:
        case ["start", *services]:
            print(f"Starting: {services}")
        case ["stop", service]:
            print(f"Stopping {service}")
        case ["status"]:
            print("Status check")
        case _:
            print("Usage: start|stop|status")
```

### Config validation
```python
def validate_config(config):
    match config:
        case {"database": {"url": url, "port": port}} if url.startswith("postgres://"):
            return "Valid PostgreSQL config"
        case {"database": {"url": url}} if url.startswith("mysql://"):
            return "Valid MySQL config"
        case _:
            raise ValueError("Invalid config")
```

> **Note**: `match` requires Python 3.10+. Use `if-elif` for older versions.
