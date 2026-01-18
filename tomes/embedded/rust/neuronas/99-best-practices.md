---
id: "rust.best-practices"
title: "Best Practices"
category: guide
difficulty: beginner
tags: [rust, guide, idioms, clean code]
keywords: [idioms, clippy, fmt]
use_cases: [code quality, maintainability]
prerequisites: ["rust.intro"]
related: ["rust.tooling"]
next_topics: []
---

# Best Practices

## Tooling

1. **rustfmt**: Always format your code.
2. **clippy**: Use `cargo clippy` to catch common mistakes.

## Idioms

### Use Option/Result
Don't use sentinel values (like -1 for error). Use `Option` or `Result`.

### Iterators over Loops
Prefer iterators for transforming collections. They are often faster (no bounds checks) and cleaner.

### Newtype Pattern
Use newtypes (`struct Id(u32)`) to enforce type safety.

### Default impl
Implement `Default` instead of a `new()` method with no arguments.

### Builder Pattern
Use builders for complex constructors.
