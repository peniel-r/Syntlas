---
# TIER 1: ESSENTIAL
id: "cpp.oo.classes"
title: "Classes"
tags: [cpp, oop, classes, intermediate]
links: ["cpp.basic.functions", "cpp.oo.constructors"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [class, object, member, access-specifier]
prerequisites: ["cpp.basic.functions", "cpp.basic.pointers"]
next: ["cpp.oo.inheritance", "cpp.oo.polymorphism"]
related:
  - id: "cpp.oo.structs"
    type: similar
    weight: 85
  - id: "cpp.oo.constructors"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Classes

Classes define user-defined types with data and behavior.

## Basic Class Definition

```cpp
class Person {
private:
    std::string name;
    int age;

public:
    // Constructor
    Person(const std::string& n, int a) : name(n), age(a) {}
    
    // Member function
    void display() {
        std::cout << name << " is " << age << " years old" << std::endl;
    }
    
    // Getter
    std::string getName() const { return name; }
    
    // Setter
    void setAge(int a) { age = a; }
};
```

## Access Specifiers

```cpp
class Example {
public:     // Accessible from anywhere
    int pub;
    
protected:  // Accessible from class and derived classes
    int prot;
    
private:    // Accessible only within class
    int priv;
};
```

## Using the Class

```cpp
Person alice("Alice", 25);
alice.display();

// Calling member functions
std::cout << alice.getName() << std::endl;
alice.setAge(26);
```

## Member Initialization List

```cpp
class Point {
private:
    int x, y;

public:
    // Efficient initialization
    Point(int px, int py) : x(px), y(py) {}
    
    // Default values
    Point() : x(0), y(0) {}
};
```

## Const Member Functions

```cpp
class Rectangle {
private:
    double width, height;

public:
    // Cannot modify member variables
    double area() const {
        return width * height;
    }
};
```

## Static Members

```cpp
class Counter {
private:
    static int count;  // Shared by all instances

public:
    Counter() { count++; }
    
    static int getCount() {  // Static member function
        return count;
    }
};

int Counter::count = 0;  // Definition

Counter c1, c2, c3;
std::cout << Counter::getCount() << std::endl;  // 3
```

## See Also

- [Constructors](cpp.oo.constructors) - Object initialization
- [Inheritance](cpp.oo.inheritance) - Code reuse
