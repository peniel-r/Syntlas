---
id: "zig.best-practices"
title: "Zig Best Practices"
category: pattern
difficulty: advanced
tags: [zig, best-practices, idioms, conventions]
keywords: [error handling, allocators, comptime, testing]
use_cases: [writing idiomatic code, memory safety, performance optimization]
prerequisites: []
related: ["zig.error", "zig.comptime"]
next_topics: []
---

# Zig Best Practices

Follow these guidelines to write clean, safe, and idiomatic Zig code.

## Naming Conventions

```zig
// Variables and functions: snake_case
const user_name = "Alice";
fn calculate_total(items: []const i32) i32 {
    // ...
}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRIES: u32 = 3;
const DEFAULT_TIMEOUT: u64 = 30000;

// Types: PascalCase
const FileHandle = struct {
    file: std.fs.File,
};
```

## Error Handling

### Use explicit error types

```zig
const ParseError = error{
    InvalidFormat,
    OutOfRange,
};

// GOOD - specific error
fn parse_data(text: []const u8) ParseError!i32 {
    // ...
}

// AVOID - generic error
const GenericError = error{ Generic };
fn parse_bad(text: []const u8) GenericError!i32 {
    // ...
}
```

### Handle errors at call site

```zig
fn process_file(path: []const u8) !void {
    // GOOD - specific error handling
    const content = try std.fs.cwd().readFileAlloc(
        std.heap.page_allocator,
        path,
    ) catch |err| {
        std.debug.print("Error reading file: {}\n", .{err});
        return;
    };

    process_content(content);
}
```

### Use Option for truly optional values

```zig
fn find_item(items: []const ?Item) ?Item {
    for (items) |item| {
        if (item != null and item.*.id == 42) {
            return item.*;
        }
    }
    
    return null;
}
```

## Memory Management

### Use ArenaAllocator for temporary allocations

```zig
const std = @import("std");

fn process_with_arena() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // All allocations share same lifetime
    const data1 = try arena.allocator().alloc(u8, 100);
    const data2 = try arena.allocator().alloc(u8, 200);

    // Freed together when arena.deinit() is called
}
```

### Use const for read-only data

```zig
// GOOD - const allows compiler optimizations
const DEFAULT_CONFIG = Config{
    .max_connections = 10,
    .timeout = 30,
};

// AVOID - var for immutable data
var default_config_var = Config{
    .max_connections = 10,
    .timeout = 30,
};
```

### Use allocators explicitly

```zig
// GOOD - explicit allocator
fn process(allocator: std.mem.Allocator) !void {
    const data = try allocator.alloc(u8, 100);
    defer allocator.free(data);
}

// AVOID - implicit page allocator
fn process_bad() !void {
    const data = try std.heap.page_allocator.alloc(u8, 100);
}
```

## Comptime Best Practices

### Use comptime for constants

```zig
// GOOD - compute at compile time
const PI: f64 = 3.141592653589793;
const MAX_SIZE: usize = 100;

// AVOID - runtime computation for constants
fn get_max_size() usize {
    return 100;  // Could be comptime constant
}
```

### Use inline for performance-critical code

```zig
// Force inlining for small hot functions
inline fn add_fast(a: i32, b: i32) i32 {
    return a + b;
}
```

### Use comptime for type validation

```zig
// Validate types at compile time
comptime fn ensure_int(comptime T: type) void {
    if (!@typeInfo(T).Int) {
        @compileError("T must be an integer type");
    }
}

const IntOrString = ensure_int(i32);
```

## Code Organization

### Use clear module structure

```zig
// Module file structure
const std = @import("std");

pub fn api_function() !void {
    // Public API functions
}

fn internal_helper() void {
    // Internal helper functions
}
```

### Group related functionality

```zig
const std = @import("std");

pub const string_ops = struct {
    pub fn concatenate(...) void { },
    pub fn split(...) void { },
};

pub const file_ops = struct {
    pub fn read(...) void { },
    pub fn write(...) void { },
};
```

## Performance

### Prefer pass-by-value for small structs

```zig
const Point = struct {
    x: i32,
    y: i32,
};

// GOOD - pass small structs by value
fn distance(p1: Point, p2: Point) i32 {
    const dx = p1.x - p2.x;
    const dy = p1.y - p2.y;
    return @sqrt(f64, @floatFromInt(i32, dx*dx + dy*dy));
}
```

### Use slice instead of pointers where possible

```zig
fn process_data(data: []const u8) usize {
    // GOOD - use slice (safer, clearer)
    var total: usize = 0;
    for (data) |byte| {
        total += byte;
    }
    
    return total;
}

// AVOID - manual pointer arithmetic
fn process_data_bad(data: [*]const u8, len: usize) usize {
    var total: usize = 0;
    var i: usize = 0;
    while (i < len) : (i += 1) {
        total += data[i];
    }
    
    return total;
}
```

### Minimize allocations in loops

```zig
const std = @import("std");

fn process_with_minimal_allocs(items: []const i32) !i32 {
    var list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer list.deinit();

    // Allocate once, reuse
    try list.ensureTotalCapacity(items.len);

    for (items) |item| {
        list.append(item) catch unreachable;
    }

    return try fold_sum(list.items);
}
```

## Testing

### Write testable code

```zig
const std = @import("std");

// PURE - no I/O, easy to test
fn pure_add(a: i32, b: i32) i32 {
    return a + b;
}

// Testable (explicit inputs/outputs)
fn process_data(input: []const u8) ![]const u8 {
    var result = std.ArrayList(u8).init(std.heap.page_allocator);
    defer result.deinit();

    for (input) |byte| {
        try result.append(transform(byte));
    }

    return try result.toOwnedSlice();
}

fn transform(byte: u8) u8 {
    return if (byte >= 'a' and byte <= 'z') 
        byte - 32 
    else 
        byte;
}
```

### Use zig test

```zig
test "pure_add" {
    const result = pure_add(2, 3);
    try std.testing.expectEqual(@as(i32, 5), result);
}

test "process_data" {
    const input = "ABC";
    const result = try process_data(input);
    try std.testing.expectEqualSlices(u8, "abc", result);
}
```

## Documentation

### Document public APIs

```zig
/// Adds two numbers together.
///
/// # Arguments
/// * `a` - First addend
/// * `b` - Second addend
///
/// # Returns
/// Sum of `a` and `b`
///
/// # Examples
/// ```
/// const result = add(2, 3);
/// std.debug.print("{d}\n", .{result}); // 5
/// ```
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}
```

### Document error cases

```zig
const ParseError = error{
    /// Input string is empty or whitespace
    EmptyInput,

    /// Integer overflow would occur
    Overflow,
};

/// Parses an integer from a string.
///
/// # Errors
/// Returns `ParseError` if:
/// * String is empty (`EmptyInput`)
/// * Value exceeds i32 max (`Overflow`)
pub fn parse_int(text: []const u8) ParseError!i32 {
    // ...
}
```

## Common Patterns

### Use defer for cleanup

```zig
const std = @import("std");

fn resource_example() !void {
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();  // Always runs

    var data = try file.readToEndAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(data);  // Always runs

    // Process data...
}
```

### Use inline for small hot functions

```zig
inline fn hot_path(x: i32) i32 {
    return x * 2;
}
```

### Use comptime for constant expressions

```zig
const TABLE_SIZE = comptime blk: {
    const values = [_]f32{0} ** 65536;
    &values.len
};

comptime fn table_size() usize {
    return TABLE_SIZE;
}
```

> **Reference**: [Zig Style Guide](https://ziglang.org/documentation/master/style/)
