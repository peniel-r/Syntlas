---
id: "cpp.util.random"
title: "std::random"
category: util
difficulty: intermediate
tags: [cpp, std, random, rng]
keywords: [random_device, mt19937, uniform_int_distribution]
use_cases: [simulations, games, crypto]
prerequisites: ["cpp.basics.variables"]
related: ["cpp.util.chrono"]
next_topics: []
---

# std::random

Modern C++ random number generation. Avoid `rand()`.

## Components

1. **Engine**: Generates raw bits (e.g., `std::mt19937`).
2. **Distribution**: Maps bits to numbers (e.g., `std::uniform_int_distribution`).

## Usage

```cpp
#include <random>
#include <iostream>

int main() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 6);

    std::cout << dis(gen) << '\n'; // Roll die
}
```

```