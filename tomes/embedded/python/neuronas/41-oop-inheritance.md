---
id: "py.oop.inheritance"
title: "Inheritance"
category: oop
difficulty: intermediate
tags: [python, oop, class, inheritance]
keywords: [extends, super, override, subclass]
use_cases: [code reuse, polymorphism]
prerequisites: ["py.oop.classes"]
related: ["py.oop.super", "py.oop.abc"]
next_topics: ["py.oop.super"]
---

# Inheritance

Inheritance allows a class (child) to derive attributes and methods from another class (parent).

## Basic Inheritance

```python
class Animal:
    def speak(self):
        print("...")

class Dog(Animal):  # Dog inherits from Animal
    def speak(self): # Method overriding
        print("Woof!")

d = Dog()
d.speak()  # Woof!
```

## Multiple Inheritance

Python supports multiple inheritance.

```python
class Flying:
    def fly(self): print("Flying")

class Swimming:
    def swim(self): print("Swimming")

class Duck(Flying, Swimming):
    pass
```
