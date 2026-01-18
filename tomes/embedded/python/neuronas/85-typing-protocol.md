---
id: "py.typing.protocol"
title: "Protocol (Structural Typing)"
category: typing
difficulty: advanced
tags: [python, typing, protocol, duck-typing]
keywords: [Protocol, structural subtyping, interface]
use_cases: [interfaces, loose coupling]
prerequisites: ["py.oop.abc"]
related: ["py.oop.abc"]
next_topics: []
---

# Protocol

Support for structural subtyping (static duck typing). If it looks like a duck, it passes the type check.

```python
from typing import Protocol

class Flyer(Protocol):
    def fly(self) -> None:
        ...

class Bird:
    def fly(self):
        print("Flap")

def take_off(obj: Flyer):
    obj.fly()

take_off(Bird())  # OK, even though Bird doesn't inherit from Flyer
```
