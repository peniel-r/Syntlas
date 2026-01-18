---
id: "py.oop.super"
title: "Super()"
category: oop
difficulty: intermediate
tags: [python, oop, super, mro]
keywords: [super, __init__, method resolution order]
use_cases: [accessing parent methods, cooperative inheritance]
prerequisites: ["py.oop.inheritance"]
related: ["py.oop.inheritance"]
next_topics: []
---

# Super()

`super()` gives you access to methods in a superclass (parent class).

## Usage in __init__

It is commonly used to call the parent's constructor.

```python
class Base:
    def __init__(self, name):
        self.name = name

class Derived(Base):
    def __init__(self, name, age):
        super().__init__(name)  # Initialize Parent
        self.age = age
```

## Method Resolution Order (MRO)

`super()` follows the MRO, which is important in multiple inheritance to ensure every class in the hierarchy is initialized exactly once.
