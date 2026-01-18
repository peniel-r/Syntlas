---
id: "py.oop.slots"
title: "__slots__"
category: oop
difficulty: advanced
tags: [python, oop, slots, memory]
keywords: [__slots__, memory optimization]
use_cases: [memory optimization, restricting attributes]
prerequisites: ["py.oop.classes"]
related: ["py.oop.classes"]
next_topics: []
---

# __slots__

By default, Python objects store attributes in a dictionary (`__dict__`), which consumes significant memory. `__slots__` tells Python to allocate space for a fixed set of attributes, saving memory.

## Usage

```python
class Point:
    __slots__ = ['x', 'y']

    def __init__(self, x, y):
        self.x = x
        self.y = y

p = Point(1, 2)
# p.z = 3  # Error: AttributeError (cannot add new attributes)
```
