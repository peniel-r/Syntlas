---
id: "python.typing"
title: "Type Hints and Annotations"
category: language
difficulty: intermediate
tags: [python, typing, type-hints, annotations]
keywords: [typing, List, Dict, Optional, Union, Callable]
use_cases: [code documentation, IDE support, static analysis]
prerequisites: ["python.functions.def", "python.classes"]
related: ["python.functions.def"]
next_topics: ["python.mypy"]
---

# Type Hints

Type hints annotate function signatures and variables with expected types.

## Basic Type Hints

```python
# Function parameters and return type
def add(a: int, b: int) -> int:
    return a + b

def greet(name: str) -> None:
    print(f"Hello, {name}!")

# Variable annotation
count: int = 0
name: str = "Alice"
```

## Built-in Types

```python
# Primitive types
def process(x: int, y: float, z: bool) -> str:
    return f"{x}, {y}, {z}"

# Collections
from typing import List, Dict, Set, Tuple

def process_list(items: List[int]) -> int:
    return sum(items)

def process_dict(data: Dict[str, int]) -> List[str]:
    return list(data.keys())

def process_tuple(point: Tuple[int, int]) -> int:
    return point[0] + point[1]
```

## Optional Types

```python
from typing import Optional

# Value can be str or None
def find_user(user_id: int) -> Optional[str]:
    if user_id == 1:
        return "Alice"
    return None

# Use with is None check
name = find_user(1)
if name is not None:
    print(name)
else:
    print("User not found")
```

## Union Types

```python
from typing import Union

def process(value: Union[int, str]) -> str:
    if isinstance(value, int):
        return f"Number: {value}"
    return f"String: {value}"

# Python 3.10+: use | operator
def process(value: int | str) -> str:
    if isinstance(value, int):
        return f"Number: {value}"
    return f"String: {value}"
```

## Callable Types

```python
from typing import Callable

def apply_function(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

result = apply_function(add, 5, 3)  # 8
```

## Type Aliases

```python
from typing import List, Dict

# Define reusable type alias
UserId = int
UserInfo = Dict[str, Union[str, int, bool]]

def get_user(user_id: UserId) -> UserInfo:
    return {"name": "Alice", "age": 30, "active": True}
```

## Generic Types

```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self):
        self.items: List[T] = []

    def push(self, item: T) -> None:
        self.items.append(item)

    def pop(self) -> T:
        return self.items.pop()

# Type-specific instances
int_stack: Stack[int] = Stack()
str_stack: Stack[str] = Stack()
```

## Protocol (Structural Typing)

```python
from typing import Protocol

class SupportsLen(Protocol):
    def __len__(self) -> int: ...

def get_length(obj: SupportsLen) -> int:
    return len(obj)

get_length([1, 2, 3])  # Works
get_length("hello")  # Works
```

## NewType

```python
from typing import NewType

UserId = NewType('UserId', int)

def process_user(user_id: UserId) -> None:
    print(f"Processing user {user_id}")

# Helps prevent mixing similar types
process_user(UserId(123))  # OK
process_user(123)  # Type checker warns
```

## Literal Types

```python
from typing import Literal

def set_mode(mode: Literal["light", "dark", "auto"]) -> None:
    print(f"Setting mode: {mode}")

set_mode("dark")  # OK
set_mode("blue")  # Type error
```

## TypedDict

```python
from typing import TypedDict

class User(TypedDict):
    name: str
    age: int
    email: str

def process_user(user: User) -> None:
    print(user["name"])

# Alternative syntax
User = TypedDict('User', {'name': str, 'age': int, 'email': str})
```

## Overloads

```python
from typing import overload

@overload
def process(value: int) -> str: ...

@overload
def process(value: str) -> int: ...

def process(value):
    if isinstance(value, int):
        return str(value)
    return len(value)

# Type checker knows both signatures
```

## Common Patterns

### Optional parameters
```python
from typing import Optional

def send_email(
    to: str,
    subject: str,
    body: str,
    cc: Optional[str] = None,
    bcc: Optional[List[str]] = None
) -> None:
    email = {"to": to, "subject": subject, "body": body}
    if cc:
        email["cc"] = cc
    if bcc:
        email["bcc"] = bcc
    send(email)
```

### Union with None (Optional)
```python
from typing import Optional

# Equivalent to Optional[T]
def parse_int(value: Union[str, None]) -> Optional[int]:
    if value is None:
        return None
    return int(value)
```

### Generic collections
```python
from typing import TypeVar, List, Dict

T = TypeVar('T')
K = TypeVar('K')
V = TypeVar('V')

def group_by_key(items: List[T], key: Callable[[T], K]) -> Dict[K, List[T]]:
    result: Dict[K, List[T]] = {}
    for item in items:
        k = key(item)
        if k not in result:
            result[k] = []
        result[k].append(item)
    return result
```

## Type Checking with mypy

```python
# Install mypy: pip install mypy
# Run: mypy file.py

def add(a: int, b: int) -> int:
    return a + b

# Type error:
# result: str = add(1, 2)  # error: Incompatible types
```

> **Best Practice**: Use type hints for public APIs. They improve documentation and catch bugs early.
