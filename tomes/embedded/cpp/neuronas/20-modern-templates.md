---
# TIER 1: ESSENTIAL
id: "cpp.basic.templates"
title: "Templates"
tags: [cpp, templates, generic, intermediate]
links: ["cpp.basic.functions", "cpp.stl.vector"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [template, generic, type-parameter, specialization]
prerequisites: ["cpp.basic.functions"]
next: ["cpp.stl.vector", "cpp.modern.concepts"]
related:
  - id: "cpp.modern.concepts"
    type: complement
    weight: 90
  - id: "cpp.modern.type-inference"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Templates

Templates enable generic programming by allowing functions and classes to work with multiple types.

## Function Templates

```cpp
template<typename T>
T add(T a, T b) {
    return a + b;
}

add(1, 2);        // T = int
add(1.5, 2.5);   // T = double
add("Hello", "World"); // T = const char*
```

## Class Templates

```cpp
template<typename T>
class Box {
private:
    T value;

public:
    Box(T v) : value(v) {}
    
    T getValue() const { return value; }
};

Box<int> intBox(42);
Box<std::string> stringBox("Hello");
```

## Multiple Template Parameters

```cpp
template<typename T, typename U>
class Pair {
private:
    T first;
    U second;

public:
    Pair(T f, U s) : first(f), second(s) {}
    
    T getFirst() const { return first; }
    U getSecond() const { return second; }
};

Pair<int, double> p(42, 3.14);
```

## Template Specialization

```cpp
// General template
template<typename T>
class Printer {
public:
    void print(T value) {
        std::cout << "General: " << value << std::endl;
    }
};

// Specialization for const char*
template<>
class Printer<const char*> {
public:
    void print(const char* value) {
        std::cout << "String: " << value << std::endl;
    }
};

Printer<int> intPrinter;
intPrinter.print(42);  // Uses general

Printer<const char*> stringPrinter;
stringPrinter.print("Hello");  // Uses specialization
```

## Non-Type Template Parameters

```cpp
template<typename T, int SIZE>
class Array {
private:
    T data[SIZE];

public:
    int size() const { return SIZE; }
};

Array<int, 10> arr;  // SIZE = 10
```

## See Also

- [Concepts](cpp.modern.concepts) - Template constraints (C++20)
- [Type Inference](cpp.modern.type-inference) - auto and decltype
