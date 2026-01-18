---
id: "py.oop.magic-methods"
title: "Magic Methods (Dunder)"
category: oop
difficulty: intermediate
tags: [python, oop, dunder, overloading]
keywords: [__init__, __str__, __repr__, __len__, __add__]
use_cases: [operator overloading, string representation, custom collections]
prerequisites: ["python.classes"]
related: ["python.classes"]
next_topics: []
---

# Magic Methods

Magic methods (or "dunder" methods, for **d**ouble **under**score) let you customize class behavior for built-in operations.

## Common Methods

- `__init__`: Constructor
- `__str__`: User-friendly string (`print()`)
- `__repr__`: Developer string (debugging)
- `__len__`: Length (`len()`)
- `__getitem__`: Indexing (`obj[key]`)
- `__add__`: Addition (`+`)

## Example

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)  # Vector(4, 6)
```
