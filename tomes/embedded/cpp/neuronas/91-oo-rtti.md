---
id: "cpp.oo.rtti"
title: "RTTI"
category: language
difficulty: intermediate
tags: [cpp, types, rtti, reflection]
keywords: [typeid, type_info]
use_cases: [logging types, dynamic_cast]
prerequisites: ["cpp.oo.classes"]
related: ["cpp.oo.casting"]
next_topics: []
---

# RTTI

**R**un-**T**ime **T**ype **I**nformation.

## typeid

Operator that returns `std::type_info`.

```cpp
#include <typeinfo>
#include <iostream>

Base* b = new Derived;
std::cout << typeid(*b).name() << '\n'; // Prints Derived (implementation defined)

if (typeid(*b) == typeid(Derived)) {
    // ...
}
```

```