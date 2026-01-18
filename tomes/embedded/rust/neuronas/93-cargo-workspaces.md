---
id: "rust.cargo.workspaces"
title: "Cargo Workspaces"
category: tooling
difficulty: intermediate
tags: [rust, cargo, monorepo, workspace]
keywords: [workspace, members, virtual manifest]
use_cases: [large projects, monorepos, shared dependencies]
prerequisites: ["rust.cargo"]
related: ["rust.cargo.profiles"]
next_topics: []
---

# Cargo Workspaces

Workspaces allow you to manage multiple related packages that share the same `Cargo.lock` and output directory.

## Root Cargo.toml

A virtual manifest at the root.

```toml
[workspace]
members = [
    "crates/api",
    "crates/core",
    "crates/cli",
]
```

## Shared Dependencies

You can define shared dependencies in the workspace `Cargo.toml`.

```toml
[workspace.dependencies]
serde = "1.0"
```

Then in member crates:

```toml
[dependencies]
serde = { workspace = true }
```
