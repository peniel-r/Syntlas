---
# TIER 1: ESSENTIAL
id: "cpp.basic.syntax"
title: "Basic C++ Syntax"
tags: [cpp, basics, syntax, beginner]
links: ["cpp.basic.variables", "cpp.basic.functions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [main, include, namespace, std, cout]
prerequisites: []
next: ["cpp.basic.variables", "cpp.basic.functions"]
related:
  - id: "cpp.stl.iostream"
    type: complement
    weight: 90
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Basic C++ Syntax

Learn the fundamental structure of a C++ program including includes, main function, and basic I/O.

## Basic Program Structure

```cpp
#include <iostream>  // Include standard library

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

## Components Explained

### Include Directives
- `#include <header>` - Include standard library headers
- Use angle brackets `< >` for standard headers
- Use quotes `" "` for your own headers

### Main Function
- `int main()` - Entry point of every C++ program
- Returns 0 for success, non-zero for error
- Can also be `int main(int argc, char* argv[])` for command-line arguments

### Standard Output
- `std::cout` - Standard output stream
- `<<` - Stream insertion operator
- `std::endl` - Newline and flush buffer

## Using Namespaces

```cpp
#include <iostream>

// Avoid using namespace std; in header files
using namespace std;  // Common in simple programs

int main() {
    cout << "Hello, World!" << endl;  // No std:: prefix needed
    return 0;
}
```

## See Also

- [Variables and Types](cpp.basic.variables) - Data types and declarations
- [Functions](cpp.basic.functions) - Function definition and calling
