---
id: "rust.std.process.stdio"
title: "Standard IO Piping"
category: stdlib
difficulty: intermediate
tags: [rust, std, process, pipe]
keywords: [Stdio, piped, inherit, null]
use_cases: [piping output, silencing output]
prerequisites: ["rust.std.process"]
related: ["rust.std.process"]
next_topics: []
---

# Stdio

Control input/output streams of child processes.

## Stdio::piped

Capture output.

```rust
use std::process::{Command, Stdio};

let output = Command::new("echo")
    .arg("hello")
    .stdout(Stdio::piped())
    .output()
    .expect("Failed");
```

## Stdio::null

Ignore output.

```rust
Command::new("cat")
    .stdout(Stdio::null())
    .spawn();
```
