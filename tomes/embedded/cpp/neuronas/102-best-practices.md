---
id: "cpp.best-practices"
title: "C++ Best Practices"
category: guide
difficulty: beginner
tags: [cpp, best-practices, guide]
keywords: [idioms, safety, modern cpp]
use_cases: [writing clean code]
prerequisites: ["cpp.basic.syntax"]
related: ["cpp.modern.type-inference"]
next_topics: []
---

# Best Practices

## 1. Use Smart Pointers
Never use `new`/`delete` manually. Use `std::make_unique` or `std::make_shared`.

## 2. Use Standard Containers
Prefer `std::vector` over C-style arrays (`int arr[]`).

## 3. Use `const`
Mark variables and methods `const` whenever possible.

## 4. Prefer `nullptr`
Use `nullptr` instead of `NULL` or `0`.

## 5. Use `auto`
Use `auto` to avoid type repetition, but don't overuse it if type clarity is lost.

## 6. RAII
Manage resources using RAII classes (constructors/destructors).

## 7. Algorithms over Loops
Prefer `std::find`, `std::sort`, etc., over raw `for` loops.
