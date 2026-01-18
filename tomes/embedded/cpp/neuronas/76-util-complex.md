---
id: "cpp.util.complex"
title: "std::complex"
category: util
difficulty: intermediate
tags: [cpp, std, math, complex]
keywords: [complex, real, imag]
use_cases: [scientific computing]
prerequisites: ["cpp.basic.variables"]
related: ["cpp.basic.variables"]
next_topics: []
---

# std::complex

Complex numbers.

## Usage

```cpp
#include <complex>
#include <iostream>

int main() {
    std::complex<double> z1(1.0, 2.0); // 1 + 2i
    std::complex<double> z2(3.0, 4.0);
    
    auto sum = z1 + z2;
    auto prod = z1 * z2;
    
    std::cout << std::abs(z1) << '\n'; // Magnitude
}
```

```
