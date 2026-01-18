---
id: "rust.cargo.profiles"
title: "Cargo Profiles"
category: tooling
difficulty: intermediate
tags: [rust, cargo, optimization, debug]
keywords: [profile, dev, release, opt-level]
use_cases: [performance tuning, binary size]
prerequisites: ["rust.cargo"]
related: ["rust.cargo.workspaces"]
next_topics: []
---

# Cargo Profiles

Profiles allow you to configure compiler settings for different build modes.

## Common Settings

In `Cargo.toml`:

```toml
[profile.dev]
opt-level = 0      # No optimization
debug = true       # Full debug info

[profile.release]
opt-level = 3      # Max optimization
lto = true         # Link Time Optimization
codegen-units = 1  # Slower build, faster binary
strip = true       # Remove symbols (smaller binary)
```
