---
# TIER 1: ESSENTIAL
id: "cpp.oo.inheritance"
title: "Inheritance"
tags: [cpp, oop, inheritance, intermediate]
links: ["cpp.oo.classes", "cpp.oo.polymorphism"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [inheritance, base-class, derived-class, override]
prerequisites: ["cpp.oo.classes"]
next: ["cpp.oo.polymorphism", "cpp.oo.polymorphism"]
related:
  - id: "cpp.oo.inheritance"
    type: alternative
    weight: 75
  - id: "cpp.oo.polymorphism"
    type: complement
    weight: 95
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Inheritance

Inheritance allows classes to derive from other classes, reusing and extending functionality.

## Basic Inheritance

```cpp
class Animal {
public:
    void eat() {
        std::cout << "Animal eats" << std::endl;
    }
};

// Dog inherits from Animal
class Dog : public Animal {
public:
    void bark() {
        std::cout << "Dog barks" << std::endl;
    }
};

Dog myDog;
myDog.eat();   // Inherited from Animal
myDog.bark();  // Dog's own method
```

## Access Specifiers in Inheritance

```cpp
class Base {
public:     int pub;
protected:  int prot;
private:    int priv;
};

// Public inheritance
class PublicDerived : public Base {
    // pub is public
    // prot is protected
    // priv is inaccessible
};

// Protected inheritance
class ProtectedDerived : protected Base {
    // pub becomes protected
    // prot remains protected
};

// Private inheritance
class PrivateDerived : private Base {
    // pub becomes private
    // prot becomes private
};
```

## Multiple Inheritance

```cpp
class Flyer {
public:
    void fly() { std::cout << "Flying" << std::endl; }
};

class Swimmer {
public:
    void swim() { std::cout << "Swimming" << std::endl; }
};

// Duck inherits from both
class Duck : public Flyer, public Swimmer {
public:
    void quack() { std::cout << "Quacking" << std::endl; }
};

Duck duck;
duck.fly();
duck.swim();
duck.quack();
```

## Diamond Problem

```cpp
class Animal { /* ... */ };
class Mammal : public Animal { /* ... */ };
class Bird : public Animal { /* ... */ };

// Bat inherits from both Mammal and Bird
// Solution: virtual inheritance
class Bat : public virtual Mammal, public virtual Bird { /* ... */ };
```

## See Also

- [Polymorphism](cpp.oo.polymorphism) - Virtual functions and runtime behavior
- [Composition](cpp.oo.inheritance) - Has-a relationship
