---
id: "rust.cargo.publishing"
title: "Publishing to Crates.io"
category: tooling
difficulty: intermediate
tags: [rust, cargo, publishing, crates.io]
keywords: [cargo publish, cargo login, cargo package]
use_cases: [sharing code]
prerequisites: ["rust.cargo"]
related: ["rust.documentation"]
next_topics: []
---

# Publishing

Sharing your crate with the world.

## Preparation

1.  Ensure `Cargo.toml` has metadata (authors, description, license).
2.  Login: `cargo login <token>`
3.  Dry run: `cargo publish --dry-run`

## Publishing

```bash
cargo publish
```

Once published, a version cannot be overwritten, only yanked (`cargo yank`).
