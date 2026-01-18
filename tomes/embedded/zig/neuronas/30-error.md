---
id: "zig.error"
title: "Error Handling"
category: language
difficulty: intermediate
tags: [zig, error, error union, error return, try]
keywords: [error, !anyerror!, catch, errdefer, unreachable]
use_cases: [error recovery, resource cleanup, invalid states]
prerequisites: []
related: ["zig.best-practices"]
next_topics: []
---

# Error Handling

Zig uses error unions and `try-catch` for error handling.

## Error Sets

```zig
const std = @import("std");

// Define error types
const ParseError = error{
    InvalidFormat,
    OutOfRange,
    MissingField,
};

fn parse_value(text: []const u8) ParseError!i32 {
    const trimmed = std.mem.trim(u8, text, " \t\n\r");
    
    if (trimmed.len == 0) {
        return error.InvalidFormat;
    }
    
    const value = std.fmt.parseInt(i32, trimmed, 10) catch {
        _ => return error.InvalidFormat,
    };
    
    if (value < 0 or value > 100) {
        return error.OutOfRange;
    }
    
    return value;
}
```

## Basic Error Handling

```zig
const std = @import("std");

fn might_fail() !void {
    // Function that returns error union
    const value: i32 = try risky_operation();
    
    std.debug.print("Success: {}\n", .{value});
}

fn risky_operation() !i32 {
    return 42;
}
```

## try-catch Blocks

```zig
const std = @import("std");

fn try_catch_example() !void {
    const result = try might_fail() catch |err| {
        std.debug.print("Caught error: {}\n", .{err});
        42  // Fallback value
    };
    
    std.debug.print("Result: {}\n", .{result});
}
```

## errdefer - Cleanup on Error

```zig
const std = @import("std");

fn cleanup_example() !void {
    var buffer: [100]u8 = undefined;
    
    // Cleanup always runs, even if error occurs
    errdefer std.heap.page_allocator.free(buffer);
    
    if (true) {
        return error.Failure;
    }
}
```

## anyerror! - Combined Error Types

```zig
const std = @import("std");

// Combine multiple error sets
const FileSystemError = error{
    NotFound,
    PermissionDenied,
};

const NetworkError = error{
    ConnectionFailed,
    Timeout,
};

const AppError = error{
    FileSystemError,
    NetworkError,
    InvalidInput,
};

fn app_operation() AppError!void {
    // Can return any of the combined errors
    try open_file() catch |err| {
        return error.FileSystemError.FileNotFound;
    };
}
```

## Error Propagation

```zig
const std = @import("std");

fn propagate_errors() !void {
    // Try operation that may fail
    const result = try inner_operation() catch |err| {
        // Log and re-throw
        std.debug.print("Error in inner: {}\n", .{err});
        return error.InnerFailed;  // Custom error
    };
    
    std.debug.print("Result: {}\n", .{result});
}

fn inner_operation() !i32 {
    return 42;
}
```

## Option for Optional Values

```zig
const std = @import("std");

fn find_value(items: []const ?i32) ?i32 {
    for (items) |item| {
        if (item != null and item.* > 10) {
            return item.*;
        }
    }
    
    return null;
}

fn option_example() !void {
    const items = [_]?i32{ 5, 15, 3, 25, null, 8 };
    
    const found = find_value(&items);
    
    if (found) |value| {
        std.debug.print("Found: {}\n", .{value});
    } else {
        std.debug.print("Not found\n", .{});
    }
}
```

## Error Union Inference

```zig
const std = @import("std");

// Compiler infers error set
fn auto_error() !void {
    const value: i32 = try parse("42") catch |err| {
        // Error type automatically inferred
        return 0;
    };
}
```

## Common Patterns

### Validation with Errors

```zig
const std = @import("std");

const ValidationError = error{
    EmptyInput,
    InvalidLength,
    InvalidCharacter,
};

fn validate_email(email: []const u8) ValidationError!void {
    if (email.len == 0) {
        return error.EmptyInput;
    }
    
    if (email.len > 100 or email.len < 5) {
        return error.InvalidLength;
    }
    
    // Check for @ character
    if (std.mem.indexOfScalar(u8, email, '@') == null) {
        return error.InvalidCharacter;
    }
}
```

### Resource Allocation with Errors

```zig
const std = @import("std");

const ResourceError = error{
    OutOfMemory,
    AllocationFailed,
};

fn allocate_resource(allocator: std.mem.Allocator) ResourceError![]u8 {
    const buffer = try allocator.alloc(u8, 1000) catch |err| {
        return error.OutOfMemory;
    };
    
    return buffer;
}
```

### Fallback Values

```zig
const std = @import("std");

fn safe_parse(text: []const u8) i32 {
    // Parse with fallback
    const value = std.fmt.parseInt(i32, text, 10) catch 0;
    return value;
}
```

### Error Wrapping

```zig
const std = @import("std");

const InnerError = error{
    ParseFailed,
};

const OuterError = error{
    InnerError,
    ValidationFailed,
};

fn wrapped_operation() OuterError!void {
    try inner_operation() catch |inner_err| {
        // Wrap inner error in outer error
        std.debug.print("Wrapped error: {}\n", .{inner_err});
        return error.InnerError;
    };
}

fn inner_operation() InnerError!void {
    return error.ParseFailed;
}
```

### Multiple Error Returns

```zig
const std = @import("std");

const ProcessError = error{
    Step1Failed,
    Step2Failed,
    Step3Failed,
};

fn multi_step_process() ProcessError!void {
    try step1() catch |err| {
        std.debug.print("Step 1 failed: {}\n", .{err});
        return error.Step1Failed;
    };
    
    try step2() catch |err| {
        std.debug.print("Step 2 failed: {}\n", .{err});
        return error.Step2Failed;
    };
    
    try step3() catch |err| {
        std.debug.print("Step 3 failed: {}\n", .{err});
        return error.Step3Failed;
    };
}

fn step1() !void { }
fn step2() !void { }
fn step3() !void { }
```

### Unreachable - Impossible States

```zig
const std = @import("std");

fn handle_exhaustive(switch: u8) !void {
    // unreachable marks code path as impossible
    switch (switch) {
        0 => std.debug.print("Case 0\n", .{}),
        1 => std.debug.print("Case 1\n", .{}),
        2 => std.debug.print("Case 2\n", .{}),
        else => unreachable,  // Compiler error if reached
    }
}
```

### Compile-Time Error Checks

```zig
const std = @import("std");

// Enforce compile-time constraints
comptime fn validate_size(comptime size: usize) void {
    if (size > 100) {
        @compileError("Size must be <= 100");
    }
}

const MyArray = validate_size(50);  // OK
const TooLargeArray = validate_size(150);  // Compile error
```

> **Note**: Use `errdefer` for cleanup that must happen regardless of success/failure. Use `Option` for values that may not exist.
