---
# TIER 1: ESSENTIAL
id: "cpp.oo.constructors"
title: "Constructors and Destructors"
tags: [cpp, oop, constructors, intermediate]
links: ["cpp.oo.classes", "cpp.oo.copy"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [constructor, destructor, initialization, member-list]
prerequisites: ["cpp.oo.classes"]
next: ["cpp.oo.inheritance", "cpp.modern.move-semantics"]
related:
  - id: "cpp.oo.copy"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Constructors and Destructors

Constructors initialize objects; destructors clean up resources.

## Default Constructor

```cpp
class Point {
private:
    int x, y;

public:
    Point() : x(0), y(0) {}  // Default constructor
    
    Point(int px, int py) : x(px), y(py) {}  // Parameterized
};

Point p1;        // Uses default
Point p2(10, 20);  // Uses parameterized
```

## Parameterized Constructor

```cpp
class Person {
private:
    std::string name;
    int age;

public:
    Person(const std::string& n, int a) 
        : name(n), age(a) {}
};

Person alice("Alice", 25);
```

## Copy Constructor

```cpp
class Person {
public:
    // Copy constructor
    Person(const Person& other) 
        : name(other.name), age(other.age) {
        std::cout << "Copy constructor" << std::endl;
    }
};

Person p1("Alice", 25);
Person p2 = p1;  // Copy constructor called
```

## Move Constructor (C++11)

```cpp
class Person {
public:
    // Move constructor
    Person(Person&& other) noexcept
        : name(std::move(other.name)), age(other.age) {
        std::cout << "Move constructor" << std::endl;
    }
};

Person p1("Alice", 25);
Person p2 = std::move(p1);  // Move constructor called
```

## Delegating Constructor (C++11)

```cpp
class Person {
private:
    std::string name;
    int age;

public:
    // Full constructor
    Person(const std::string& n, int a) 
        : name(n), age(a) {}
    
    // Delegates to full constructor
    Person(const std::string& n) : Person(n, 0) {}
};
```

## Destructor

```cpp
class Resource {
private:
    int* data;

public:
    Resource(int size) {
        data = new int[size];
    }
    
    // Destructor - always called when object is destroyed
    ~Resource() {
        delete[] data;
        std::cout << "Resource cleaned up" << std::endl;
    }
};
```

## See Also

- [Copy and Move](cpp.oo.copy) - Deep copy vs move semantics
- [Rule of Five](cpp.modern.rule-of-five) - Complete resource management
