---
id: "py.typing.generics"
title: "Generics"
category: typing
difficulty: intermediate
tags: [python, typing, generics, typevar]
keywords: [TypeVar, Generic, List, Dict]
use_cases: [reusable components, type safety]
prerequisites: ["python.basics.types"]
related: ["py.typing.protocol"]
next_topics: []
---

# Generics

Define functions and classes that work with any type.

## TypeVar

```python
from typing import TypeVar, List

T = TypeVar('T')

def first(items: List[T]) -> T:
    return items[0]
```

## Generic Classes

```python
from typing import Generic

class Stack(Generic[T]):
    def __init__(self):
        self.items: List[T] = []

    def push(self, item: T):
        self.items.append(item)
```
