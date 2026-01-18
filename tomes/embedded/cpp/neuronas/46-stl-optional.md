---
# TIER 1: ESSENTIAL
id: "cpp.stl.optional"
title: "std::optional"
tags: [cpp, stl, optional, modern, intermediate]
links: ["cpp.modern.type-inference", "cpp.exceptions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: stdlib
difficulty: intermediate
keywords: [optional, null-safety, c++17, value-or-nothing]
prerequisites: ["cpp.oo.classes"]
next: ["cpp.stl.variant", "cpp.stl.any"]
related:
  - id: "cpp.stl.variant"
    type: similar
    weight: 85
  - id: "cpp.exceptions"
    type: alternative
    weight: 75
version:
  minimum: "C++17"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# std::optional (C++17)

`std::optional` represents a value that may or may not be present.

## Basic Usage

```cpp
#include <optional>

std::optional<int> opt = 42;
std::optional<int> empty;  // No value
```

## Checking and Accessing

```cpp
std::optional<int> opt = 42;

if (opt) {
    std::cout << "Value: " << *opt << std::endl;
}

if (opt.has_value()) {
    std::cout << "Value: " << opt.value() << std::endl;
}

// With default
std::cout << opt.value_or(0) << std::endl;
```

## Returning Optional

```cpp
std::optional<int> divide(int a, int b) {
    if (b == 0) {
        return std::nullopt;  // Return empty
    }
    return a / b;
}

auto result = divide(10, 2);
if (result) {
    std::cout << *result << std::endl;
}
```

## Operations

```cpp
std::optional<int> opt = 42;

opt.reset();  // Clear value
opt = 100;   // Assign new value
opt.emplace(200);  // Construct in place
opt.swap(opt2);  // Swap with another optional
```

## Value_or

```cpp
std::optional<int> opt;

int value = opt.value_or(0);  // Returns 0 if empty
std::cout << value << std::endl;
```

## See Also

- [std::variant](cpp.stl.variant) - Type-safe union
- [std::any](cpp.stl.any) - Type-erased container
