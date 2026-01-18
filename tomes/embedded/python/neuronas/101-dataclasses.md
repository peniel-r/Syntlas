---
id: "python.dataclasses"
title: "Dataclasses for Clean Data Structures"
category: stdlib
difficulty: intermediate
tags: [python, dataclasses, struct, classes]
keywords: [@dataclass, field, frozen, asdict]
use_cases: [data modeling, configs, immutable records]
prerequisites: ["python.classes"]
related: ["python.typing", "python.stdlib.collections"]
next_topics: ["python.stdlib.typing"]
---

# Dataclasses

`dataclasses` provides decorators for creating classes primarily for storing data.

## Basic Dataclass

```python
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str

# Creates __init__, __repr__, __eq__ automatically
user = User(id=1, name="Alice", email="alice@example.com")
print(user)  # User(id=1, name='Alice', email='alice@example.com')
```

## Default Values

```python
from dataclasses import dataclass

@dataclass
class User:
    name: str
    age: int = 0  # Default value
    active: bool = True

user = User(name="Alice")
print(user.age)    # 0 (uses default)
print(user.active)  # True
```

## Field Options

```python
from dataclasses import dataclass, field

@dataclass
class User:
    name: str
    id: int = field(default_factory=int)  # Call int() for new instances
    scores: list = field(default_factory=list)  # Each instance gets new list
    created_at: str = field(default_factory=lambda: datetime.now().isoformat())
    internal_id: int = field(init=False, default=0)  # Not in __init__

user1 = User(name="Alice")
user2 = User(name="Bob")
user1.scores.append(100)  # Only affects user1
```

## Immutability with frozen

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Point:
    x: int
    y: int

point = Point(10, 20)
point.x = 30  # FrozenInstanceError - cannot modify
```

## Inheritance

```python
from dataclasses import dataclass

@dataclass
class Person:
    name: str
    age: int

@dataclass
class Employee(Person):
    employee_id: int
    department: str

emp = Employee("Alice", 30, 12345, "Engineering")
print(emp.name)  # Alice (inherited)
print(emp.employee_id)  # 12345 (own field)
```

## asdict and astuple

```python
from dataclasses import dataclass, asdict, astuple

@dataclass
class User:
    name: str
    age: int
    email: str

user = User("Alice", 30, "alice@example.com")

# Convert to dict
user_dict = asdict(user)
# {'name': 'Alice', 'age': 30, 'email': 'alice@example.com'}

# Convert to tuple
user_tuple = astuple(user)
# ('Alice', 30, 'alice@example.com')
```

## replace - Create New Instance

```python
from dataclasses import dataclass, replace

@dataclass
class User:
    name: str
    age: int
    active: bool = True

user = User("Alice", 30)
updated = replace(user, age=31, active=False)
# User(name='Alice', age=31, active=False)
# Original user unchanged
```

## slots - Performance

```python
from dataclasses import dataclass

@dataclass(slots=True)
class Point:
    x: int
    y: int

# Saves memory by preventing __dict__ creation
```

## kw_only - Keyword-Only Init

```python
from dataclasses import dataclass

@dataclass(kw_only=True)
class Config:
    host: str
    port: int = 8080
    debug: bool = False

# Must use keyword arguments
config = Config(host="localhost", port=5432)
```

## Common Use Cases

### Configuration objects
```python
from dataclasses import dataclass, field, asdict
import json

@dataclass
class Config:
    database_url: str
    max_connections: int = 10
    timeout: int = field(default=30)
    debug: bool = field(default=False)

# Load from JSON
with open("config.json") as f:
    data = json.load(f)
config = Config(**data)

# Save to JSON
with open("config.json", "w") as f:
    json.dump(asdict(config), f, indent=2)
```

### Immutable records
```python
from dataclasses import dataclass

@dataclass(frozen=True, slots=True)
class UserEvent:
    user_id: int
    event_type: str
    timestamp: str

event = UserEvent(1, "login", "2026-01-18T12:00:00")
# event is immutable - safer for concurrent access
```

### API response models
```python
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str

@dataclass
class APIResponse:
    status: int
    message: str
    user: User

# Parse API response
data = json.loads(api_response_text)
response = APIResponse(**data)
```

### Testing with default factories
```python
from dataclasses import dataclass, field

@dataclass
class TestCase:
    name: str
    inputs: list = field(default_factory=list)
    expected: any = None

# Each test gets fresh inputs list
test1 = TestCase("test addition")
test2 = TestCase("test subtraction")
```

### Type-safe data transfer
```python
from dataclasses import dataclass
from typing import Optional

@dataclass
class UserInfo:
    id: int
    name: str
    email: Optional[str] = None
    age: Optional[int] = None

def get_user(user_id: int) -> UserInfo:
    # Returns partial user info
    pass
```

## When to Use Dataclasses vs Namedtuples vs Normal Classes

| Scenario | Recommended |
|----------|-------------|
| Store data, minimal methods | dataclass |
| Need immutability, hashable keys | dataclass (frozen=True) or namedtuple |
| Complex logic, behavior | normal class |
| Performance-critical, fixed schema | dataclass (slots=True) |

> **Performance**: dataclasses with `slots=True` use significantly less memory than regular classes.
