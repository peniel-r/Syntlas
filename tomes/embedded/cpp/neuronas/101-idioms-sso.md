---
id: "cpp.idioms.sso"
title: "Small String Optimization (SSO)"
category: optimizations
difficulty: expert
tags: [cpp, optimization, string, memory]
keywords: [SSO, small string optimization, allocation]
use_cases: [performance tuning]
prerequisites: ["cpp.stl.string"]
related: ["cpp.stl.string"]
next_topics: []
---

# Small String Optimization (SSO)

Most `std::string` implementations avoid heap allocation for short strings (e.g., < 15 or 23 chars) by storing them directly inside the string object buffer.

## Impact

- **Performance**: No `new`/`delete` for short strings.
- **Cache**: Better locality.
- **Size**: `sizeof(std::string)` is typically 24 or 32 bytes to accommodate the buffer.

```cpp
std::string s = "short"; // Stored on stack (inside object)
std::string l = "very very very long string..."; // Heap allocated
```
