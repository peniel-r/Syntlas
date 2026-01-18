---
id: "rust.error"
title: "Error Handling"
category: language
difficulty: intermediate
tags: [rust, error, Result, Option, error-propagation]
keywords: [Result, Option, ?, unwrap, expect]
use_cases: [error recovery, validating inputs, graceful degradation]
prerequisites: ["rust.ownership"]
related: ["rust.error"]
next_topics: []
---

# Error Handling

Rust uses `Result<T, E>` for recoverable errors and `Option<T>` for optional values.

## Result Type

```rust
use std::fs;

fn read_file(path: &str) -> Result<String, std::io::Error> {
    std::fs::read_to_string(path)
}

fn main() {
    match read_file("config.txt") {
        Ok(content) => println!("Config: {}", content),
        Err(e) => eprintln!("Error reading file: {}", e),
    }
}
```

## Option Type

```rust
fn find_user(id: i32) -> Option<String> {
    if id == 1 {
        Some(String::from("Alice"))
    } else {
        None
    }
}

fn main() {
    match find_user(1) {
        Some(name) => println!("Found: {}", name),
        None => println!("User not found"),
    }
}
```

## Error Propagation with ?

```rust
fn parse_number(s: &str) -> Result<i32, std::num::ParseIntError> {
    s.parse()
}

fn process(s: &str) -> Result<String, Box<dyn std::error::Error>> {
    // ? propagates errors up
    let num = parse_number(s)?;  // Returns early if error
    Ok(format!("Number: {}", num))
}

fn main() {
    match process("42") {
        Ok(msg) => println!("{}", msg),
        Err(e) => eprintln!("Error: {}", e),
    }
}
```

## unwrap() and expect()

```rust
// unwrap() - panic on None/Err
let val = Some(42).unwrap();
let val = Ok(42).unwrap();

// expect() - panic with custom message
let val = Some(42).expect("Value should exist");
let val = Ok(42).expect("Should be Ok");

// Prefer match in production code
let val = match Some(42) {
    Some(v) => v,
    None => panic!("Missing value"),
};
```

## Custom Error Types

```rust
use std::fmt;

#[derive(Debug)]
enum AppError {
    NotFound(String),
    ValidationError(String),
    IoError(std::io::Error),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            AppError::NotFound(msg) => write!(f, "Not found: {}", msg),
            AppError::ValidationError(msg) => write!(f, "Invalid: {}", msg),
            AppError::IoError(err) => write!(f, "IO error: {}", err),
        }
    }
}

impl std::error::Error for AppError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            AppError::IoError(err) => Some(err),
            _ => None,
        }
    }
}
```

## Common Error Patterns

### Returning Result

```rust
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err(String::from("Cannot divide by zero"))
    } else {
        Ok(a / b)
    }
}
```

### Chaining Results

```rust
fn read_config() -> Result<String, std::io::Error> {
    std::fs::read_to_string("config.txt")
}

fn validate_config(content: String) -> Result<Config, String> {
    // Validate and return Result
    Config::parse(content)
}

fn load_config() -> Result<Config, String> {
    let content = read_config()?;
    validate_config(content)
}
```

### Converting Option to Result

```rust
fn find_user(id: i32) -> Option<User> {
    // Find user...
    None
}

fn get_user(id: i32) -> Result<User, String> {
    find_user(id).ok_or_else(|| String::from("User not found"))
}
```

### Error Mapping

```rust
use std::fs;
use std::path::Path;

fn read_config(path: &Path) -> Result<String, String> {
    std::fs::read_to_string(path)
        .map_err(|e| format!("Failed to read config: {}", e))
}
```

### Recoverable Errors

```rust
fn process_data(data: &str) -> Result<Vec<&str>, String> {
    let parts: Vec<&str> = data.split_whitespace().collect();

    if parts.is_empty() {
        Err(String::from("No data to process"))
    } else {
        Ok(parts)
    }
}
```

### Multiple Errors

```rust
#[derive(Debug)]
enum ProcessError {
    Io(std::io::Error),
    Parse(String),
}

impl std::error::Error for ProcessError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ProcessError::Io(err) => Some(err),
            ProcessError::Parse(_) => None,
        }
    }
}
```

## Best Practices

1. **Prefer Result over panic** for recoverable errors
2. **Use match or ?** instead of unwrap() in production code
3. **Provide context** in error messages
4. **Create custom error types** for domain-specific errors
5. **Use Option** for truly optional values

> **Note**: The `?` operator makes error handling concise while maintaining safety.
