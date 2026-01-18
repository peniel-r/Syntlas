---
id: "zig.comptime"
title: "Comptime and Compile-Time Evaluation"
category: language
difficulty: intermediate
tags: [zig, comptime, compile-time, type reflection]
keywords: [comptime, @compileError, @typeInfo, @typeInfo, builtin]
use_cases: [type safety, generic programming, compile-time computations]
prerequisites: []
related: ["zig.stdlib.allocators"]
next_topics: ["zig.reflection"]
---

# Comptime and Compile-Time Evaluation

Zig's comptime enables compile-time computation and type-level programming.

## comptime Functions

```zig
const std = @import("std");

// Function executed at compile time
comptime fn factorial(n: u32) u32 {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}

// Compile-time constant
const fact_10 = factorial(10);

pub fn main() !void {
    std.debug.print("10! = {}\n", .{fact_10});  // Computed at compile time
}
```

## comptime Conditionals

```zig
const std = @import("std");

const os = builtin.os.tag;

// Branch at compile time based on OS
const output = comptime switch (os) {
    .linux => "Linux system",
    .windows => "Windows system",
    .macos => "macOS system",
    else => "Unknown OS",
};

pub fn main() !void {
    std.debug.print("Running on: {}\n", .{output});
}
```

## comptime Loops

```zig
const std = @import("std");

// Compile-time loop to generate data
const powers = comptime blk: {
    var result: [10]u32 = undefined;
    for (0..10) |i| {
        result[i] = std.math.pow(u32, 2, @as(u32, i));
    }
    break :blk result;
};
```

## Type Information

```zig
const std = @import("std");

// Get type information at compile time
const TypeInfo = @typeInfo(i32);

pub fn main() !void {
    comptime {
        std.debug.print("Type: {s}\n", .{@typeName(TypeInfo)});
        std.debug.print("Size: {}\n", .{@sizeOf(i32)});
        std.debug.print("Alignment: {}\n", .{@alignOf(i32)});
    }
}
```

## Generic Functions with Comptime

```zig
const std = @import("std");

// Generic with comptime parameter
comptime fn create_array(comptime N: usize) type {
    [N]i32
};

// Use compile-time parameter
const array: create_array(5) = .{ 1, 2, 3, 4, 5 };

pub fn main() !void {
    inline for (array) |value| {
        std.debug.print("Value: {}\n", .{value});
    }
}
```

## Compile-Time Strings

```zig
const std = @import("std");

// String operations at compile time
const greeting = comptime blk: {
    var buf: [100]u8 = undefined;
    const result = std.fmt.bufPrint(&buf, "Hello, {s}!", .{"World"});
    result;
};

pub fn main() !void {
    std.debug.print("{s}\n", .{greeting});
}
```

## Compile-Time Error Handling

```zig
const std = @import("std");

// Enforce constraints at compile time
comptime fn validate_size(comptime size: usize) void {
    if (size > 100) {
        @compileError("Size must be <= 100");
    }
}

// Usage with compile error if constraint violated
const MyArray = validate_size(150);  // Compile error
```

## Inline Functions

```zig
const std = @import("std");

// Force inlining (compile-time decision)
inline fn add(a: i32, b: i32) i32 {
    a + b
}

pub fn main() !void {
    const result = add(5, 3);
    std.debug.print("Result: {}\n", .{result});
}
```

## Common Patterns

### Compile-time type checking

```zig
const std = @import("std");

comptime fn ensure_int(comptime T: type) void {
    if (!@typeInfo(T).Int) {
        @compileError("T must be an integer type");
    }
}

// Enforce type constraint
ensure_int(i32);
// ensure_int(f64);  // Compile error
```

### Compile-time array initialization

```zig
const std = @import("std");

const lookup = comptime blk: {
    var arr: [256]u8 = undefined;
    for (0..256) |i| {
        arr[i] = @truncate(u8, i);
    }
    break :blk arr;
};
```

### Tagged unions with comptime

```zig
const std = @import("std");

const Tag = enum { int, float, string };

const Value = union(Tag) {
    int: i32,
    float: f64,
    string: []const u8,
};

pub fn main() !void {
    const v = Value{ .int = 42 };
    comptime switch (@as(@Tag(Value), v)) {
        .int => std.debug.print("Integer: {}\n", .{v.int}),
        .float => std.debug.print("Float: {}\n", .{v.float}),
        .string => std.debug.print("String: {s}\n", .{v.string}),
    }
}
```

### Compile-time hash generation

```zig
const std = @import("std");

comptime fn hash_string(s: []const u8) u32 {
    var hash: u32 = 5381;
    for (s) |byte| {
        hash = ((hash << 5) + hash) + byte;
    }
    hash
}

const MY_STRING_HASH = hash_string("constant");
```

### Generic type traits with comptime

```zig
const std = @import("std");

comptime fn is_signed(comptime T: type) bool {
    const info = @typeInfo(T);
    return switch (info.Int.signedness) {
        .signed => true,
        .unsigned => false,
        else => false,
    };
}

comptime fn max_value(comptime T: type) T {
    if (is_signed(T)) {
        std.math.maxInt(T);
    } else {
        std.math.maxInt(T);
    }
}
```

### Build configuration at compile time

```zig
const std = @import("std");

const config = comptime blk: {
    const is_debug = builtin.mode == .Debug;
    const optimize = if (is_debug) "Debug" else "Release";
    break :blk .{ .is_debug, .optimize };
};

pub fn main() !void {
    std.debug.print("Debug mode: {}\n", .{config.is_debug});
    std.debug.print("Optimize: {}\n", .{config.optimize});
}
```

> **Note**: comptime code runs during compilation - errors and conditions are caught at build time.
