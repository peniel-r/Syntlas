---
# TIER 1: ESSENTIAL
id: "cpp.basic.strings"
title: "Strings"
tags: [cpp, basics, strings, beginner]
links: ["cpp.basic.variables", "cpp.basic.arrays"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [string, std::string, c-string, concatenation]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.stl.vector", "cpp.io.files"]
related:
  - id: "cpp.stl.string-view"
    type: complement
    weight: 85
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Strings

C++ provides both C-style strings and the modern `std::string` class.

## std::string (Preferred)

```cpp
#include <string>

std::string s1 = "Hello";        // Direct initialization
std::string s2("World");        // Constructor
std::string s3(5, 'a');        // "aaaaa"
std::string s4 = s1 + " " + s2; // "Hello World"
```

## String Operations

```cpp
std::string s = "Hello World";

// Length
std::cout << s.length() << std::endl;   // 11
std::cout << s.size() << std::endl;     // 11

// Access
std::cout << s[0] << std::endl;       // 'H'

// Substring
std::cout << s.substr(0, 5) << std::endl; // "Hello"

// Find
size_t pos = s.find("World");          // 6
if (pos != std::string::npos) {
    std::cout << "Found at " << pos << std::endl;
}

// Replace
s.replace(0, 5, "Hi");              // "Hi World"
```

## String Concatenation

```cpp
std::string s1 = "Hello";
std::string s2 = "World";

// + operator
std::string s3 = s1 + " " + s2;  // "Hello World"

// append()
s1.append(" ");        // "Hello "
s1.append(s2);       // "Hello World"
```

## String Comparison

```cpp
std::string s1 = "apple";
std::string s2 = "banana";

if (s1 == s2) { /* ... */ }      // Equal
if (s1 != s2) { /* ... */ }      // Not equal
if (s1 < s2) { /* ... */ }       // Less than (lexicographic)
```

## C-Style Strings (Avoid)

```cpp
char cstr[] = "Hello";             // Null-terminated
std::cout << strlen(cstr) << std::endl; // 5

// Conversion (use with caution)
std::string s = cstr;              // C-string to string
const char* ptr = s.c_str();        // String to C-string
```

## String Streams

```cpp
#include <sstream>

std::stringstream ss;
ss << "Age: " << 30 << ", Score: " << 95.5;
std::string result = ss.str();      // "Age: 30, Score: 95.5"
```

## See Also

- [std::string_view](cpp.stl.string-view) - Non-owning string reference
- [File I/O](cpp.io.files) - Reading/writing strings to files
