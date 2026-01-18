---
id: "rust.cargo.dependencies"
title: "Cargo Dependencies"
category: tooling
difficulty: beginner
tags: [rust, cargo, dependencies, versioning]
keywords: [dependencies, version, git, path]
use_cases: [managing libraries]
prerequisites: ["rust.cargo"]
related: ["rust.cargo.features"]
next_topics: []
---

# Dependencies

Specifying dependencies in `Cargo.toml`.

## Sources

```toml
[dependencies]
# Crates.io
serde = "1.0.1"

# Git repository
rand = { git = "https://github.com/rust-random/rand.git" }

# Local path
my-lib = { path = "../my-lib" }
```

## Versioning (SemVer)

- `^1.2.3`: Allow compatible updates (>=1.2.3, <2.0.0). Default.
- `~1.2.3`: Allow patch updates (>=1.2.3, <1.3.0).
- `=1.2.3`: Exact version.
