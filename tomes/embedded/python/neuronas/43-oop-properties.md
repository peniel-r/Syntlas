---
id: "py.oop.properties"
title: "Properties"
category: oop
difficulty: intermediate
tags: [python, oop, property, getter]
keywords: [@property, setter, deleter, encapsulation]
use_cases: [computed attributes, validation, encapsulation]
prerequisites: ["py.oop.classes", "py.patterns.decorators"]
related: ["py.patterns.decorators"]
next_topics: []
---

# Properties

Properties allow you to define methods that behave like attributes.

## The @property Decorator

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value < 0:
            raise ValueError("Radius cannot be negative")
        self._radius = value

    @property
    def area(self):
        return 3.14159 * self._radius ** 2

c = Circle(5)
c.radius = 10      # Calls setter
print(c.area)      # Calls getter (computed)
# c.area = 50      # Error: AttributeError (no setter)
```
