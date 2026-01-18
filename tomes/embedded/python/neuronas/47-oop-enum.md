---
id: "py.oop.enum"
title: "Enumerations (Enum)"
category: oop
difficulty: intermediate
tags: [python, oop, enum, constants]
keywords: [Enum, auto, IntEnum]
use_cases: [constants, state machines, options]
prerequisites: ["python.classes"]
related: ["python.classes"]
next_topics: []
---

# Enumerations

The `enum` module provides a way to define symbolic names (members) bound to unique, constant values.

## Basic Enum

```python
from enum import Enum, auto

class Color(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3
    # AUTO = auto()

print(Color.RED)        # Color.RED
print(Color.RED.name)   # RED
print(Color.RED.value)  # 1
```

## Comparison

Enums are compared by identity.

```python
if c is Color.RED:
    pass
```
