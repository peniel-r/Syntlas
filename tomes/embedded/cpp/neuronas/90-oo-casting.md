---
id: "cpp.oo.casting"
title: "Casting"
category: language
difficulty: intermediate
tags: [cpp, casting, types]
keywords: [static_cast, dynamic_cast, reinterpret_cast, const_cast]
use_cases: [type conversion, polymorphism]
prerequisites: ["cpp.basics.types", "cpp.oo.inheritance"]
related: ["cpp.oo.rtti"]
next_topics: []
---

# Casting

C++ provides specific operators for type conversion. Avoid C-style casts `(int)float`.

## static_cast

Safe, compile-time conversion.

```cpp
float f = 3.14;
int i = static_cast<int>(f);
```

## dynamic_cast

Runtime check for polymorphic types (inheritance). Returns `nullptr` on failure.

```cpp
Base* b = new Derived;
Derived* d = dynamic_cast<Derived*>(b);
if (d) { /* success */ }
```

## const_cast

Removes `const`.

## reinterpret_cast

Unsafe bit-cast.
