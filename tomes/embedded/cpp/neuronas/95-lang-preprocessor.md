---
id: "cpp.lang.preprocessor"
title: "Preprocessor"
category: language
difficulty: beginner
tags: [cpp, preprocessor, macros]
keywords: [#define, #include, #ifdef, #pragma]
use_cases: [conditional compilation, macros]
prerequisites: ["cpp.basic.syntax"]
related: ["cpp.modern.constexpr"]
next_topics: []
---

# Preprocessor

Directives handled before compilation.

## Macros

```cpp
#define PI 3.14159
#define MAX(a,b) ((a) > (b) ? (a) : (b))
```

## Conditional Compilation

```cpp
#ifdef DEBUG
    std::cout << "Debug mode";
#endif
```

## Pragma

```cpp
#pragma once // Header guard
```
