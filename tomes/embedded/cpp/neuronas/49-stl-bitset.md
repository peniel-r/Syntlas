---
id: "cpp.stl.bitset"
title: "std::bitset"
category: stl
difficulty: intermediate
tags: [cpp, stl, bitset, optimization]
keywords: [bitset, bit manipulation, flags]
use_cases: [flags, bit masks, compact storage]
prerequisites: ["cpp.basics.operators"]
related: ["cpp.stl.vector"]
next_topics: []
---

# std::bitset

A fixed-size sequence of bits. Optimized for space.

## Usage

```cpp
#include <bitset>
#include <iostream>

int main() {
    std::bitset<8> bits("10101010");
    
    bits[0] = 0;        // Set bit 0 to 0
    bits.set(1);        // Set bit 1 to 1
    bits.flip();        // Flip all bits
    
    std::cout << bits.to_ulong() << '\n'; // Convert to integer
    std::cout << bits.count() << '\n';    // Count set bits
}
```

```
