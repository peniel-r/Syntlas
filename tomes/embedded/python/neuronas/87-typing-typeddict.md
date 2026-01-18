---
id: "py.typing.typeddict"
title: "TypedDict"
category: typing
difficulty: intermediate
tags: [python, typing, dict, struct]
keywords: [TypedDict, JSON]
use_cases: [json structures, dict validation]
prerequisites: ["py.basics.dicts"]
related: ["py.lib.dataclasses"]
next_topics: []
---

# TypedDict

Type hint for dictionaries with fixed keys and value types.

```python
from typing import TypedDict

class User(TypedDict):
    name: str
    age: int

u: User = {"name": "Alice", "age": 30}
# u: User = {"name": "Bob"}  # Type checker error (missing age)
```
