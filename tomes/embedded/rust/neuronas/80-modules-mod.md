---
id: "rust.modules.mod"
title: "Modules"
category: modules
difficulty: beginner
tags: [rust, modules, organization, scope]
keywords: [mod, pub, file hierarchy]
use_cases: [code organization, privacy boundaries]
prerequisites: ["rust.functions"]
related: ["rust.modules.use", "rust.modules.visibility"]
next_topics: ["rust.modules.use"]
---

# Modules

Modules let you organize code within a crate for readability and easy reuse.

## Inline Modules

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}
    }
}
```

## File Modules

**src/lib.rs**:
```rust
mod front_of_house;
```

**src/front_of_house.rs**:
```rust
pub mod hosting;
```

**src/front_of_house/hosting.rs**:
```rust
pub fn add_to_waitlist() {}
```
