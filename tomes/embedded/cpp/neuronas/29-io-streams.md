---
# TIER 1: ESSENTIAL
id: "cpp.io.streams"
title: "I/O Streams"
tags: [cpp, io, streams, beginner]
links: ["cpp.basic.variables", "cpp.io.files"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: beginner
keywords: [iostream, cin, cout, cerr]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.io.files", "cpp.basic.strings"]
related:
  - id: "cpp.io.files"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# I/O Streams

C++ streams provide formatted input and output.

## Output (cout)

```cpp
#include <iostream>

std::cout << "Hello, World!" << std::endl;
std::cout << "Age: " << 25 << std::endl;
std::cout << "Value: " << 3.14159 << std::endl;
```

## Input (cin)

```cpp
int age;
std::cout << "Enter age: ";
std::cin >> age;

std::string name;
std::cout << "Enter name: ";
std::cin >> name;

// Read full line
std::string line;
std::getline(std::cin, line);
```

## Error Streams

```cpp
std::cerr << "Error message" << std::endl;  // Unbuffered
std::clog << "Log message" << std::endl;   // Buffered
```

## Manipulators

```cpp
#include <iomanip>

std::cout << std::setw(10) << "Hello" << std::endl;  // Width
std::cout << std::setprecision(3) << 3.14159 << std::endl;  // 3.14
std::cout << std::fixed << 3.14159 << std::endl;  // Fixed notation
std::cout << std::scientific << 1000.0 << std::endl;  // 1.000e+03
```

## Stream States

```cpp
std::ifstream file("data.txt");
if (file.good()) {
    // Stream is good
}
if (file.eof()) {
    // End of file
}
if (file.fail()) {
    // Last operation failed
}
```

## See Also

- [File I/O](cpp.io.files) - File operations
- [String Streams](cpp.basic.strings) - In-memory I/O
