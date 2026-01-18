---
# TIER 1: ESSENTIAL
id: "cpp.stl.string-view"
title: "std::string_view"
tags: [cpp, stl, string-view, modern, intermediate]
links: ["cpp.basic.strings", "cpp.modern.type-inference"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [string-view, non-owning, c++17, string]
prerequisites: ["cpp.basic.strings"]
next: ["cpp.stl.array", "cpp.modern.type-inference"]
related:
  - id: "cpp.basic.strings"
    type: complement
    weight: 90
version:
  minimum: "C++17"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::string_view

`std::string_view` provides a non-owning view of string data.

## Basic Usage

```cpp
#include <string_view>

std::string s = "Hello, World!";
std::string_view sv = s;  // View of string

std::cout << sv << std::endl;  // "Hello, World!"
```

## Creating string_view

```cpp
std::string s = "Hello";
std::string_view sv1 = s;  // From std::string
std::string_view sv2 = "World";  // From C-string
std::string_view sv3(s.data(), 3);  // First 3 characters
```

## Operations

```cpp
std::string s = "Hello, World!";
std::string_view sv = s;

sv.size();      // Length
sv.length();    // Same as size()
sv.empty();     // Check if empty
sv[0];         // Access character
sv.substr(0, 5);  // "Hello"
sv.find("World");  // Find substring
```

## Benefits Over const string&

```cpp
// Old way - creates temporary copies
void printString(const std::string& s);

// New way - no copying
void printView(std::string_view sv);

// Can accept string literals, C-strings, and std::string
printView("Hello");           // No copy!
printView(s);                // No copy!
printView(std::string("World"));  // No copy!
```

## Substring View

```cpp
std::string s = "Hello, World!";
std::string_view sv(s.data(), 5);  // "Hello" view

std::cout << sv << std::endl;
```

## See Also

- [std::string](cpp.basic.strings) - Owning string
- [Type Inference](cpp.modern.type-inference) - auto with string_view
