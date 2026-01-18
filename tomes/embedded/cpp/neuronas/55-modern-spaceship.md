---
id: "cpp.modern.spaceship"
title: "Three-way Comparison (C++20)"
category: modern
difficulty: intermediate
tags: [cpp, modern, spaceship, operator]
keywords: [<=>, spaceship, strong_ordering]
use_cases: [simplifying comparison operators]
prerequisites: ["cpp.basic.operators"]
related: ["cpp.basic.operators"]
next_topics: []
---

# Three-way Comparison (<=>)

The "spaceship operator" simplifies implementing comparisons (`<`, `<=`, `>`, `>=`).

## Usage

```cpp
#include <compare>

struct Point {
    int x, y;
    
    // Default implementation compares members in order
    auto operator<=>(const Point&) const = default;
};

int main() {
    Point p1{1, 2}, p2{1, 3};
    if (p1 < p2) { // Automatically generated
        // ...
    }
}
```
