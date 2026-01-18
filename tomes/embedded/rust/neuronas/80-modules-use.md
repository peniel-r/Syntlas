---
id: "rust.modules.use"
title: "Bringing Paths into Scope"
category: modules
difficulty: beginner
tags: [rust, use, paths, imports]
keywords: [use, as, glob]
use_cases: [shortcuts, dependencies]
prerequisites: ["rust.modules.mod"]
related: ["rust.cargo"]
next_topics: []
---

# Use Keyword

The `use` keyword brings a path into scope.

## Absolute vs Relative

```rust
// Absolute
use crate::front_of_house::hosting;

// Relative
use self::front_of_house::hosting;
```

## Aliasing with `as`

```rust
use std::fmt::Result;
use std::io::Result as IoResult;
```

## Glob Operator

```rust
use std::collections::*;
```
