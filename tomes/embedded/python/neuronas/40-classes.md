---
id: "python.classes"
title: "Classes and Object-Oriented Programming"
category: language
difficulty: intermediate
tags: [python, classes, oop, objects]
keywords: [class, __init__, self, inheritance, methods]
use_cases: [modeling entities, code organization, encapsulation]
prerequisites: ["python.functions.def"]
related: ["python.patterns.decorators", "python.functions.scope"]
next_topics: ["python.classes.methods"]
---

# Classes and OOP

Classes are blueprints for creating objects with attributes and methods.

## Basic Class Definition

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def bark(self):
        print(f"{self.name} says: Woof!")

    def birthday(self):
        self.age += 1

# Create instances
dog1 = Dog("Buddy", 3)
dog2 = Dog("Max", 5)

dog1.bark()  # Buddy says: Woof!
dog1.birthday()
print(dog1.age)  # 4
```

## Class vs Instance Attributes

```python
class Dog:
    species = "Canis familiaris"  # Class attribute

    def __init__(self, name):
        self.name = name  # Instance attribute

dog = Dog("Buddy")
print(dog.species)  # Canis familiaris (shared)
print(dog.name)     # Buddy (instance-specific)
```

## Methods

```python
class Calculator:
    def __init__(self):
        self.history = []

    def add(self, a, b):
        result = a + b
        self.history.append(f"{a} + {b} = {result}")
        return result

    def show_history(self):
        for entry in self.history:
            print(entry)

calc = Calculator()
calc.add(5, 3)
calc.show_history()
```

## Inheritance

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

dog = Dog("Buddy")
cat = Cat("Whiskers")
print(dog.speak())  # Woof!
print(cat.speak())  # Meow!
```

## Method Overriding and super()

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        return "Some sound"

class Dog(Animal):
    def __init__(self, name, breed):
        # Call parent __init__
        super().__init__(name)
        self.breed = breed

    def speak(self):
        # Override parent method
        return "Woof!"

dog = Dog("Buddy", "Golden Retriever")
print(dog.name)   # Buddy
print(dog.breed)  # Golden Retriever
print(dog.speak()) # Woof!
```

## Multiple Inheritance

```python
class Flyable:
    def fly(self):
        return "Flying"

class Swimmable:
    def swim(self):
        return "Swimming"

class Duck(Flyable, Swimmable):
    def quack(self):
        return "Quacking"

duck = Duck()
print(duck.fly())    # Flying
print(duck.swim())   # Swimming
print(duck.quack())  # Quacking
```

## Property Decorators

```python
class Person:
    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def age(self):
        """Getter"""
        return self._age

    @age.setter
    def age(self, value):
        """Setter with validation"""
        if value < 0:
            raise ValueError("Age cannot be negative")
        self._age = value

    @property
    def name(self):
        return self._name

person = Person("Alice", 30)
print(person.age)  # 30 (calls getter)

person.age = -5  # Raises ValueError
```

## Class Methods and Static Methods

```python
class MathUtils:
    @classmethod
    def from_string(cls, value):
        """Class method - has access to cls"""
        return cls(int(value))

    @staticmethod
    def is_even(num):
        """Static method - no self or cls"""
        return num % 2 == 0

# Class method
num = MathUtils.from_string("42")
print(num)  # 42

# Static method
print(MathUtils.is_even(4))  # True
```

## Magic Methods (Dunder Methods)

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        """String representation"""
        return f"Point({self.x}, {self.y})"

    def __repr__(self):
        """Developer representation"""
        return f"Point(x={self.x}, y={self.y})"

    def __add__(self, other):
        """Operator overloading: +"""
        return Point(self.x + other.x, self.y + other.y)

    def __eq__(self, other):
        """Equality comparison: =="""
        return self.x == other.x and self.y == other.y

p1 = Point(1, 2)
p2 = Point(3, 4)
print(p1)           # Point(1, 2)
print(str(p1))       # Point(1, 2)
print(repr(p1))      # Point(x=1, y=2)
print(p1 + p2)       # Point(4, 6)
print(p1 == p2)       # False
```

## Abstract Base Classes

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        """Must be implemented by subclasses"""
        pass

    @abstractmethod
    def perimeter(self):
        """Must be implemented by subclasses"""
        pass

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)

# Shape() would raise TypeError - cannot instantiate abstract class
rect = Rectangle(5, 3)
print(rect.area())  # 15
```

## Common Patterns

### Data class pattern
```python
class User:
    def __init__(self, id, name, email):
        self.id = id
        self.name = name
        self.email = email

# Use dataclasses instead (Python 3.7+)
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str
```

### Singleton pattern
```python
class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

s1 = Singleton()
s2 = Singleton()
print(s1 is s2)  # True - same instance
```

> **Note**: Python supports multiple inheritance, which can lead to complexity. Use composition when possible.
