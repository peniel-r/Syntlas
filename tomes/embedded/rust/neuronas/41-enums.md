---
id: "rust.patterns.enums"
title: "Enums and Enum Patterns"
category: pattern
difficulty: intermediate
tags: [rust, enum, variants, methods]
keywords: [enum, Option, Result, match]
use_cases: [state representation, type safety, exhaustive matching]
prerequisites: ["rust.patterns.match"]
related: ["rust.patterns.structs"]
next_topics: ["rust.traits"]
---

# Enums and Enum Patterns

Rust's enums provide expressive type-safe alternatives to unions.

## Basic Enums

```rust
enum Color {
    Red,
    Green,
    Blue,
}

fn main() {
    let color = Color::Red;
    match color {
        Color::Red => println!("Red"),
        Color::Green => println!("Green"),
        Color::Blue => println!("Blue"),
    }
}
```

## Enums with Data

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor { r: u8, g: u8, b: u8 },
}

fn main() {
    let msg = Message::Move { x: 10, y: 20 };
    match msg {
        Message::Quit => println!("Quitting"),
        Message::Move { x, y } => println!("Moving to ({}, {})", x, y),
        Message::Write(text) => println!("Writing: {}", text),
        Message::ChangeColor { r, g, b } => {
            println!("Color: rgb({},{},{})", r, g, b);
        }
    }
}
```

## Option<T> - Optional Values

```rust
fn divide(a: i32, b: i32) -> Option<i32> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}

fn main() {
    match divide(10, 2) {
        Some(result) => println!("Result: {}", result),
        None => println!("Cannot divide by zero"),
    }
}
```

## Result<T, E> - Error Handling

```rust
enum MathError {
    DivisionByZero,
    NegativeResult,
}

fn safe_divide(a: i32, b: i32) -> Result<i32, MathError> {
    if b == 0 {
        Err(MathError::DivisionByZero)
    } else if a / b < 0 {
        Err(MathError::NegativeResult)
    } else {
        Ok(a / b)
    }
}

fn main() {
    match safe_divide(10, 2) {
        Ok(result) => println!("Result: {}", result),
        Err(MathError::DivisionByZero) => println!("Division by zero"),
        Err(MathError::NegativeResult) => println!("Negative result"),
    }
}
```

## Enum Methods

```rust
enum Pet {
    Dog(String),
    Cat(String),
}

impl Pet {
    fn speak(&self) -> String {
        match self {
            Pet::Dog(_) => String::from("Woof"),
            Pet::Cat(_) => String::from("Meow"),
        }
    }

    fn name(&self) -> &str {
        match self {
            Pet::Dog(name) => name,
            Pet::Cat(name) => name,
        }
    }
}

fn main() {
    let dog = Pet::Dog(String::from("Buddy"));
    println!("{} says: {}", dog.name(), dog.speak());
}
```

## C-like Enums

```rust
#[repr(i32)]
enum StatusCode {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

fn main() {
    let code = StatusCode::NotFound;
    println!("Code: {}", code as i32);
}
```

## Exhaustive Matching

```rust
enum Direction {
    North,
    South,
    East,
    West,
}

fn is_cardinal(direction: &Direction) -> bool {
    match direction {
        Direction::North | Direction::South => true,
        Direction::East | Direction::West => false,
    }
}
```

## Option Combinators

```rust
fn main() {
    // map
    let opt = Some(5);
    let doubled = opt.map(|n| n * 2);  // Some(10)

    // and_then
    let next = opt.and_then(|n| if n > 0 { Some(n + 1) } else { None });  // Some(6)

    // or_else
    let result = opt.unwrap_or(0);  // 5
    let result = opt.unwrap_or_else(|| 10);  // 5 (since Some)

    // ok_or
    let value: Result<i32, String> = opt.ok_or(String::from("None"));  // Ok(5)

    // filter
    let positive = opt.filter(|n| *n > 0);  // Some(5)
}
```

## Common Patterns

### State representation
```rust
enum Connection {
    Disconnected,
    Connecting,
    Connected(String),
    Error(String),
}

fn update_state(state: Connection, event: &str) -> Connection {
    match (state, event) {
        (Connection::Disconnected, "connect") => Connection::Connecting,
        (Connection::Connecting, "connected") => Connection::Connected(String::from("Server")),
        (Connection::Connected(_), "error") => Connection::Error(String::from(event)),
        (Connection::Error(_), "reconnect") => Connection::Connecting,
        (Connection::Error(_), "disconnect") => Connection::Disconnected,
        _ => state,
    }
}
```

### Result error mapping
```rust
enum AppError {
    Io(String),
    Parse(String),
    Network(String),
}

fn map_io_error(e: std::io::Error) -> AppError {
    AppError::Io(format!("{:?}", e))
}
```

### Pattern matching on slices
```rust
fn parse_command(input: &str) -> Option<(&str, &str)> {
    match input.splitn(2, ' ') {
        Ok(parts) => {
            let cmd = parts.next()?;
            let args = parts.next().unwrap_or("");
            Some((cmd, args))
        }
        Err(_) => None,
    }
}
```

### Enum with methods as trait objects
```rust
enum Shape {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
}

impl Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle { radius } => std::f64::consts::PI * radius * radius,
            Shape::Rectangle { width, height } => width * height,
        }
    }
}
```

### Nested enum matching
```rust
enum Outer {
    Inner(Inner),
}

enum Inner {
    A,
    B(i32),
}

fn process(outer: Outer) -> String {
    match outer {
        Outer::Inner(Inner::A) => String::from("Variant A"),
        Outer::Inner(Inner::B(n)) => format!("Variant B with {}", n),
    }
}
```

> **Note**: Enums in Rust are algebraic data types - much more powerful than C-style enums.
