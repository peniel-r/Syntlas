---
id: "rust.std.env"
title: "Environment (std::env)"
category: stdlib
difficulty: beginner
tags: [rust, std, env, variables, args]
keywords: [env::var, env::args, current_dir]
use_cases: [configuration, cli arguments]
prerequisites: ["rust.result", "rust.option"]
related: ["rust.std.fs"]
next_topics: []
---

# Environment Variables and Arguments

The `std::env` module allows inspection and manipulation of the process's environment.

## Command Line Arguments

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    println!("Program name: {}", args[0]);
    if args.len() > 1 {
        println!("First argument: {}", args[1]);
    }
}
```

## Environment Variables

```rust
use std::env;

fn main() {
    // Read variable
    match env::var("HOME") {
        Ok(val) => println!("HOME: {}", val),
        Err(e) => println!("couldn't read HOME: {}", e),
    }

    // Set variable (current process only)
    env::set_var("MY_VAR", "value");
}
```
