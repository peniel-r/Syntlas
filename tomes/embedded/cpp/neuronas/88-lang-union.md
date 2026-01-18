---
id: "cpp.lang.union"
title: "union"
category: language
difficulty: intermediate
tags: [cpp, types, union, memory]
keywords: [union, variant]
use_cases: [low-level memory overlap, c compatibility]
prerequisites: ["cpp.oo.classes"]
related: ["cpp.stl.variant"]
next_topics: []
---

# union

All members share the same memory location. Size is size of largest member.

```cpp
union Data {
    int i;
    float f;
    char str[20];
};

Data data;
data.i = 10;
data.f = 220.5; // data.i is now corrupted
```

> **Note**: Prefer `std::variant` for type safety.
