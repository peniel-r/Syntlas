---
id: "py.oop.abc"
title: "Abstract Base Classes"
category: oop
difficulty: advanced
tags: [python, oop, abc, interface]
keywords: [ABC, abstractmethod, interface]
use_cases: [interfaces, enforcing implementation]
prerequisites: ["py.oop.inheritance"]
related: ["py.oop.inheritance"]
next_topics: []
---

# Abstract Base Classes (ABC)

ABCs allow you to define interfaces and enforce that derived classes implement specific methods.

## Usage

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

class Square(Shape):
    def __init__(self, side):
        self.side = side

    def area(self):
        return self.side ** 2

# s = Shape()    # Error: Can't instantiate abstract class
s = Square(5)    # OK
```
