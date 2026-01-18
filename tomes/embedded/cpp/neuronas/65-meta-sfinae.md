---
id: "cpp.meta.sfinae"
title: "SFINAE"
category: metaprogramming
difficulty: expert
tags: [cpp, templates, sfinae, enable_if]
keywords: [Substitution Failure Is Not An Error, enable_if]
use_cases: [function overloading based on type properties]
prerequisites: ["cpp.meta.type-traits"]
related: ["cpp.modern.concepts"]
next_topics: ["cpp.modern.concepts"]
---

# SFINAE

**S**ubstitution **F**ailure **I**s **N**ot **A**n **E**rror. If substituting a template parameter fails, the compiler simply removes that overload from the candidate set instead of halting.

## std::enable_if

Old-school way to constrain templates (replaced by Concepts in C++20).

```cpp
template<typename T, 
         typename = std::enable_if_t<std::is_integral_v<T>>>
void only_ints(T t) {}

// only_ints(10); // OK
// only_ints(3.14); // Error: no matching function
```
