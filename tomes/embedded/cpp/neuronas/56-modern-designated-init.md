---
id: "cpp.modern.designated-init"
title: "Designated Initializers (C++20)"
category: modern
difficulty: beginner
tags: [cpp, modern, initialization, structs]
keywords: [initialization, struct]
use_cases: [readable initialization, named arguments]
prerequisites: ["cpp.oo.classes"]
related: ["cpp.oo.constructors"]
next_topics: []
---

# Designated Initializers

Initialize struct members by name.

## Usage

```cpp
struct Point {
    int x;
    int y;
    int z = 0;
};

int main() {
    // Initialize x and y, z uses default
    Point p{.x = 10, .y = 20};
    
    // Order must match declaration order!
    // Point p2{.y = 20, .x = 10}; // Error
}
```
