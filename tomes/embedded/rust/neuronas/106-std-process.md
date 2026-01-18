---
id: "rust.std.process"
title: "Process (std::process)"
category: stdlib
difficulty: intermediate
tags: [rust, std, process, command]
keywords: [Command, spawn, exit, output]
use_cases: [running external programs, subprocesses]
prerequisites: ["rust.std.io"]
related: ["rust.std.env"]
next_topics: []
---

# Process

Run external commands and manage subprocesses.

## Running a Command

```rust
use std::process::Command;

fn main() {
    let output = Command::new("echo")
        .arg("Hello world")
        .output()
        .expect("Failed to execute command");

    println!("status: {}", output.status);
    println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
}
```

## Exiting

```rust
use std::process;

fn main() {
    process::exit(1);
}
```
