---
id: "py.oop.methods"
title: "Class and Static Methods"
category: oop
difficulty: intermediate
tags: [python, oop, methods, decorators]
keywords: [@classmethod, @staticmethod, cls]
use_cases: [factory methods, utility functions]
prerequisites: ["python.classes", "python.patterns.decorators"]
related: ["python.classes"]
next_topics: []
---

# Class and Static Methods

## @classmethod

Takes the class (`cls`) as the first argument, not the instance. Useful for **factory methods**.

```python
class Date:
    def __init__(self, day, month, year):
        self.day = day
        # ...

    @classmethod
    def from_string(cls, date_str):
        day, month, year = map(int, date_str.split('-'))
        return cls(day, month, year)

d = Date.from_string("10-12-2023")
```

## @staticmethod

Does not take `self` or `cls`. It's just a function inside a class namespace.

```python
class MathUtils:
    @staticmethod
    def add(a, b):
        return a + b
```
