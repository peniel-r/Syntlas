---
# TIER 1: ESSENTIAL
id: "cpp.basic.controlflow"
title: "Control Flow"
tags: [cpp, basics, controlflow, beginner]
links: ["cpp.basic.operators", "cpp.basic.loops"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [if, switch, else, break, continue]
prerequisites: ["cpp.basic.operators"]
next: ["cpp.basic.loops", "cpp.stl.vector"]
related:
  - id: "cpp.basic.exceptions"
    type: complement
    weight: 70
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Control Flow

Control flow statements determine the order in which code is executed based on conditions.

## If-Else Statements

```cpp
int age = 18;

if (age >= 18) {
    std::cout << "Adult" << std::endl;
} else if (age >= 13) {
    std::cout << "Teenager" << std::endl;
} else {
    std::cout << "Child" << std::endl;
}

// One-line if
if (age >= 18) std::cout << "Adult";
```

## Ternary Operator

```cpp
int x = 10;
int max = (x > 5) ? x : 5;  // max = 10

std::string status = (x % 2 == 0) ? "even" : "odd";
```

## Switch Statement

```cpp
char grade = 'B';

switch (grade) {
    case 'A':
        std::cout << "Excellent!" << std::endl;
        break;
    case 'B':
        std::cout << "Good!" << std::endl;
        break;
    case 'C':
        std::cout << "Average" << std::endl;
        break;
    default:
        std::cout << "Invalid grade" << std::endl;
}

// Fall-through (C++17: [[fallthrough]] attribute)
switch (x) {
    case 1:
        // Do something
        [[fallthrough]];  // Explicit fall-through
    case 2:
        // Do something else
        break;
}
```

## Break and Continue

```cpp
for (int i = 0; i < 10; i++) {
    if (i == 3) continue;   // Skip iteration 3
    if (i == 7) break;      // Exit loop at 7
    std::cout << i << " ";
}
// Output: 0 1 2 4 5 6
```

## C++17 Structured Bindings with If

```cpp
std::map<int, std::string> m = {{1, "one"}, {2, "two"}};

if (auto it = m.find(2); it != m.end()) {
    std::cout << it->second << std::endl;  // "two"
}
```

## See Also

- [Loops](cpp.basic.loops) - Iteration constructs
- [Exceptions](cpp.basic.exceptions) - Error handling
