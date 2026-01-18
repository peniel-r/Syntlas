---
# TIER 1: ESSENTIAL
id: "cpp.exceptions"
title: "Exception Handling"
tags: [cpp, exceptions, error-handling, intermediate]
links: ["cpp.basic.functions", "cpp.oo.classes"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [try, catch, throw, exception]
prerequisites: ["cpp.basic.functions"]
next: ["cpp.io.files", "cpp.best-practices"]
related:
  - id: "cpp.best-practices"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Exception Handling

Exceptions provide a structured way to handle errors.

## Basic Try-Catch

```cpp
try {
    int divisor = 0;
    if (divisor == 0) {
        throw std::runtime_error("Division by zero");
    }
    int result = 10 / divisor;
} catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
}
```

## Throwing Different Types

```cpp
try {
    throw 42;  // Throw int
} catch (int e) {
    std::cout << "Caught int: " << e << std::endl;
}

try {
    throw std::string("Error message");
} catch (const std::string& e) {
    std::cout << "Caught string: " << e << std::endl;
}
```

## Multiple Catch Blocks

```cpp
try {
    // Code that might throw
} catch (const std::runtime_error& e) {
    std::cerr << "Runtime error: " << e.what() << std::endl;
} catch (const std::logic_error& e) {
    std::cerr << "Logic error: " << e.what() << std::endl;
} catch (...) {
    std::cerr << "Unknown exception" << std::endl;
}
```

## Standard Exceptions

```cpp
#include <stdexcept>

throw std::runtime_error("Runtime error");
throw std::logic_error("Logic error");
throw std::invalid_argument("Invalid argument");
throw std::out_of_range("Out of range");
throw std::length_error("Length error");
```

## Custom Exceptions

```cpp
class MyException : public std::exception {
public:
    const char* what() const noexcept override {
        return "My custom exception";
    }
};

throw MyException();
```

## noexcept Specification

```cpp
// Function promises not to throw
void safeFunction() noexcept {
    // Code that won't throw
}

// Conditional noexcept
void conditionalNoexcept(int x) noexcept(noexcept(x > 0)) {
    // ...
}
```

## See Also

- [Error Codes](cpp.best-practices) - Alternative error handling
- [RAII](cpp.modern.rule-of-five) - Resource management
