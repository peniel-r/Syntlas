---
# TIER 1: ESSENTIAL
id: "cpp.oo.polymorphism"
title: "Polymorphism"
tags: [cpp, oop, polymorphism, intermediate]
links: ["cpp.oo.inheritance", "cpp.oo.polymorphism"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [polymorphism, virtual, override, runtime]
prerequisites: ["cpp.oo.inheritance"]
next: ["cpp.oo.interfaces", "cpp.oo.abstract"]
related:
  - id: "cpp.oo.polymorphism"
    type: complement
    weight: 95
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Polymorphism

Polymorphism allows objects of different types to be treated as objects of a common base type.

## Virtual Functions

```cpp
class Animal {
public:
    // Virtual function - enables runtime polymorphism
    virtual void makeSound() {
        std::cout << "Some sound" << std::endl;
    }
    
    // Virtual destructor - important for inheritance
    virtual ~Animal() {}
};

class Dog : public Animal {
public:
    void makeSound() override {  // C++11 override
        std::cout << "Woof" << std::endl;
    }
};

class Cat : public Animal {
public:
    void makeSound() override {
        std::cout << "Meow" << std::endl;
    }
};

// Runtime polymorphism
Animal* animals[] = {new Dog(), new Cat()};
for (auto animal : animals) {
    animal->makeSound();  // Calls appropriate function
}
```

## Pure Virtual Functions (Abstract Classes)

```cpp
class Shape {
public:
    // Pure virtual - makes class abstract
    virtual double area() = 0;
    
    virtual ~Shape() {}
};

class Circle : public Shape {
private:
    double radius;

public:
    Circle(double r) : radius(r) {}
    
    double area() override {
        return 3.14159 * radius * radius;
    }
};

// Shape s;  // Error: cannot instantiate abstract class
Circle c(5.0);  // OK
```

## Final Keyword (C++11)

```cpp
class Base {
public:
    // Cannot be overridden
    virtual void finalMethod() final {
        std::cout << "Cannot override" << std::endl;
    }
};

class Derived : public Base {
    // void finalMethod() override;  // Error: method is final
};
```

## Dynamic Cast

```cpp
// Base to derived (safe downcast)
Animal* animal = new Dog();
Dog* dog = dynamic_cast<Dog*>(animal);

if (dog != nullptr) {
    std::cout << "Successfully cast to Dog" << std::endl;
}
```

## See Also

- [Virtual Functions](cpp.oo.polymorphism) - Deep dive into virtual behavior
- [Interfaces](cpp.oo.interfaces) - Pure virtual base classes
