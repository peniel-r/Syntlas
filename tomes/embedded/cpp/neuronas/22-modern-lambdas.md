---
# TIER 1: ESSENTIAL
id: "cpp.modern.lambdas"
title: "Lambda Expressions"
tags: [cpp, modern, lambdas, intermediate]
links: ["cpp.basic.functions", "cpp.stl.algorithm"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: intermediate
keywords: [lambda, closure, capture, function-object]
prerequisites: ["cpp.basic.functions"]
next: ["cpp.modern.concepts", "cpp.stl.algorithm"]
related:
  - id: "cpp.modern.type-inference"
    type: complement
    weight: 85
  - id: "cpp.stl.algorithm"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Lambda Expressions

Lambdas are anonymous functions that can capture variables from their surrounding scope.

## Basic Lambda

```cpp
auto add = [](int a, int b) {
    return a + b;
};

int result = add(3, 5);  // 8
```

## Lambda Captures

```cpp
int multiplier = 2;

// Capture by value
auto multiply = [multiplier](int x) {
    return x * multiplier;  // Uses captured value
};

// Capture by reference
auto multiply2 = [&multiplier](int x) {
    return x * multiplier;  // Uses reference
};

// Capture all by value
auto lambda1 = [=](int x) {
    return x + multiplier;
};

// Capture all by reference
auto lambda2 = [&](int x) {
    return x + multiplier;
};

// Mixed capture
auto lambda3 = [&, multiplier](int x) {
    return x + multiplier;  // multiplier by value, rest by reference
};
```

## Lambda with STL Algorithms

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Count even numbers
int count = std::count_if(v.begin(), v.end(), [](int x) {
    return x % 2 == 0;
});

// Transform
std::transform(v.begin(), v.end(), v.begin(), [](int x) {
    return x * 2;
});

// For each
std::for_each(v.begin(), v.end(), [](int x) {
    std::cout << x << " ";
});
```

## Lambda Return Type (C++11)

```cpp
// Trailing return type
auto divide = [](int a, int b) -> double {
    return static_cast<double>(a) / b;
};
```

## Generic Lambdas (C++14)

```cpp
auto generic = [](auto x) {
    return x * 2;
};

generic(5);      // int: 10
generic(3.14);   // double: 6.28
```

## Mutable Lambdas

```cpp
int counter = 0;

// Mutable allows modifying captured variables
auto increment = [counter]() mutable {
    counter++;
    std::cout << counter << std::endl;
};
```

## See Also

- [STL Algorithms](cpp.stl.algorithm) - Using lambdas with algorithms
- [Type Inference](cpp.modern.type-inference) - auto in lambdas
