---
id: "rust.patterns.match"
title: "Pattern Matching"
category: pattern
difficulty: intermediate
tags: [rust, match, patterns, destructuring]
keywords: [match, Option, Result, guards, ranges]
use_cases: [control flow, data extraction, state machines]
prerequisites: ["rust.ownership"]
related: ["rust.error"]
next_topics: ["rust.patterns.enums"]
---

# Pattern Matching

Rust's `match` expressions provide powerful pattern matching.

## Basic Matching

```rust
let value = 5;

match value {
    1 => println!("One"),
    2 => println!("Two"),
    _ => println!("Something else"),
}
```

## Matching Ranges

```rust
let value = 7;

match value {
    0..=10 => println!("Single digit"),
    10..=99 => println!("Two digits"),
    100.. => println!("Many digits"),
}
```

## Matching Options

```rust
fn get_user(id: i32) -> Option<String> {
    if id == 1 {
        Some(String::from("Alice"))
    } else {
        None
    }
}

fn main() {
    let name = match get_user(1) {
        Some(n) => n,
        None => String::from("Unknown"),
    };
    println!("{}", name);
}
```

## Matching Results

```rust
fn parse_number(s: &str) -> Result<i32, std::num::ParseIntError> {
    s.parse()
}

fn main() {
    match parse_number("42") {
        Ok(n) => println!("Number: {}", n),
        Err(e) => println!("Error: {}", e),
    }
}
```

## Destructuring Structs

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 10, y: 20 };

    match p {
        Point { x, y } => println!("({}, {})", x, y),
    }
}
```

## Destructuring Enums

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

fn main() {
    let msg = Message::Move { x: 10, y: 20 };

    match msg {
        Message::Quit => println!("Quitting"),
        Message::Move { x, y } => println!("Moving to ({}, {})", x, y),
        Message::Write(text) => println!("Writing: {}", text),
    }
}
```

## Destructuring Tuples

```rust
fn main() {
    let tuple = (1, "hello", 3.14);

    match tuple {
        (a, b, c) => println!("{} {} {}", a, b, c),
    }
}
```

## Destructuring Arrays/Slices

```rust
fn main() {
    let arr = [1, 2, 3, 4, 5];

    match arr {
        [first, ..] => println!("First: {}", first),
        [.., last] => println!("Last: {}", last),
        [a, b, c] => println!("Three: {} {} {}", a, b, c),
        _ => println!("Other"),
    }
}
```

## Or Patterns

```rust
fn main() {
    let value = Some(5);

    match value {
        Some(3) | Some(5) => println!("3 or 5"),
        Some(7) => println!("Seven"),
        None => println!("None"),
    }
}
```

## Guards

```rust
fn main() {
    let x = 15;
    let y = 10;

    match x {
        n if n % 2 == 0 => println!("{} is even", x),
        n if n % 2 != 0 => println!("{} is odd", x),
        _ => println!("Unexpected"),
    }
}
```

## Matching References

```rust
fn main() {
    let s = String::from("hello");
    let r = &s;

    match r {
        "hello" => println!("Matched"),
        _ => println!("No match"),
    }
}
```

## Nested Matching

```rust
enum State {
    Active(i32),
    Idle,
    Error(String),
}

fn main() {
    let state = State::Active(42);

    match state {
        State::Active(n) if n > 0 => println!("Active with {}", n),
        State::Idle => println!("Idle"),
        State::Error(msg) => println!("Error: {}", msg),
    }
}
```

## @ Patterns - Wildcards

```rust
fn process_result(result: Result<i32, String>) {
    match result {
        Ok(value) => println!("Success: {}", value),
        Err(_) => println!("Failed"),  // Ignore error value
    }
}

fn main() {
    process_result(Ok(42));
    process_result(Err(String::from("error")));
}
```

## Common Patterns

### Extracting data from Result
```rust
fn get_user(id: i32) -> Result<String, String> {
    if id == 1 {
        Ok(String::from("Alice"))
    } else {
        Err(String::from("Not found"))
    }
}

fn main() {
    match get_user(1) {
        Ok(name) => println!("Found: {}", name),
        Err(e) => println!("Error: {}", e),
    }
}
```

### State machine
```rust
enum State {
    Start,
    Running(i32),
    Paused,
    Finished,
}

fn transition(state: State) -> State {
    match state {
        State::Start => State::Running(0),
        State::Running(n) => State::Running(n + 1),
        State::Running(_) => State::Paused,
        State::Paused => State::Finished,
        State::Finished => State::Finished,
    }
}
```

### Option chaining
```rust
fn process_optional(opt: Option<i32>) -> i32 {
    match opt {
        Some(n) => n * 2,
        None => 0,
    }
}
```

### Pattern matching for validation
```rust
fn validate(value: i32) -> bool {
    match value {
        0..=100 => true,  // 0-100 inclusive
        101..=200 => true,  // 101-200 inclusive
        _ => false,
    }
}
```

### Multiple conditions with Or
```rust
fn classify(value: i32) -> &'static str {
    match value {
        1 | 2 | 3 => "Small",
        4 | 5 | 6 => "Medium",
        _ => "Large",
    }
}
```

> **Tip**: Use match exhaustiveness checking - compiler warns if not all cases are covered.
