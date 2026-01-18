---
id: "zig.strings"
title: "String Manipulation"
category: stdlib
difficulty: intermediate
tags: [zig, string, std.mem, std.fmt]
keywords: [strings, allocation, formatting, comparison]
use_cases: [text processing, string building, i18n]
prerequisites: []
related: ["zig.stdlib.collections"]
next_topics: ["zig.stdlib.io"]
---

# String Manipulation

Zig provides both UTF-8 aware and byte-level string operations.

## Creating Strings

```zig
const std = @import("std");

// String literals
const greeting = "Hello, World!";
const multi_line = 
    \\Line 1
    \\Line 2
;

// C string (null-terminated)
const c_string: [*:0]const u8 = "C string\x00";
```

## String Allocation

```zig
const std = @import("std");

fn allocate_string(allocator: std.mem.Allocator) !void {
    // With allocator
    const s1 = try std.fmt.allocPrint(allocator, "Value: {}", .{10});
    defer allocator.free(s1);

    // To owned from slice
    const s2 = try allocator.dupe(u8, "hello");
    defer allocator.free(s2);
}
```

## String Slicing

```zig
const std = @import("std");

fn slicing_example() !void {
    const text = "Hello, World!";

    // Bytes slicing (dangerous for UTF-8)
    const bytes = text[0..5];  // "Hello"

    // Codepoint slicing (UTF-8 aware)
    const iter = (try std.unicode.Utf8View.init(text)).iterator();
    const first_word = try iter.sliceTo(5);
    defer first_word.deinit();
}
```

## String Comparison

```zig
const std = @import("std");

fn comparison_example() !void {
    const s1 = "hello";
    const s2 = "HELLO";

    // ASCII comparison
    const eq = std.mem.eql(u8, s1, s2);
    const less = std.mem.order(u8, s1, s2) == .lt;

    // Case-insensitive
    const eq_ignore = std.ascii.eqlIgnoreCase(s1, s2);
}
```

## String Formatting

```zig
const std = @import("std");

fn formatting_example() !void {
    const name = "Alice";
    const age = 30;

    // format! macro (compile-time)
    const message = std.fmt.comptimePrint(
        "Hello, {s}! You are {d} years old.",
        .{name, age}
    );

    std.debug.print("{s}\n", .{message});

    // allocPrint (runtime)
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    const message2 = try std.fmt.allocPrint(
        &gpa.allocator,
        "Value: {}",
        .{42}
    );
    defer gpa.allocator().free(message2);
}
```

## String Concatenation

```zig
const std = @import("std");

fn concatenation_example(allocator: std.mem.Allocator) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    var list = std.ArrayList(u8).init(gpa.allocator());
    defer list.deinit();

    try list.appendSlice("Hello");
    try list.appendSlice(" ");
    try list.appendSlice("World");

    const result = try list.toOwnedSlice();
    defer gpa.allocator().free(result);

    std.debug.print("{s}\n", .{result});
}
```

## String Length

```zig
const std = @import("std");

fn length_example() !void {
    const text = "Hello";

    // Byte length
    const byte_len = text.len;  // 5

    // UTF-8 codepoint count
    var utf8_iter = try std.unicode.Utf8View.init(text);
    defer utf8_iter.deinit();

    const codepoint_len: usize = blk: {
        var count: usize = 0;
        while (utf8_iter.nextCodepoint()) |cp| {
            count += 1;
        }
        break :blk count;
    };

    std.debug.print("Bytes: {}, Codepoints: {}\n", .{byte_len, codepoint_len});
}
```

## String Searching

```zig
const std = @import("std");

fn search_example() !void {
    const text = "Hello, World!";

    // Index of substring (bytes)
    const idx1 = std.mem.indexOf(u8, text, "World");
    const idx2 = std.mem.indexOfScalar(u8, text, ',');

    // Contains check
    const contains = std.mem.indexOf(u8, text, "Hello") != null;

    // Last index
    const last_idx = std.mem.lastIndexOf(u8, text, "l");
}
```

## String to Number Conversion

```zig
const std = @import("std");

fn parse_example() !void {
    const text = "42";

    // Parse integers
    const int_value = try std.fmt.parseInt(i32, text, 10);

    // Parse floats
    const float_value = try std.fmt.parseFloat(f64, text);

    std.debug.print("Int: {}, Float: {}\n", .{int_value, float_value});
}
```

## Common Patterns

### Build string from parts

```zig
const std = @import("std");

fn build_string(allocator: std.mem.Allocator, parts: []const []const u8) ![]const u8 {
    var list = std.ArrayList([]const u8).init(allocator);
    defer list.deinit();

    for (parts) |part| {
        try list.append(part);
    }

    return try list.toOwnedSlice();
}
```

### Split by delimiter

```zig
const std = @import("std");

fn split_example() !void {
    const text = "apple,banana,cherry";

    var iter = std.mem.splitScalar(u8, text, ',');
    defer iter.deinit();

    var parts = std.ArrayList([]const u8).init(std.heap.page_allocator);
    defer parts.deinit();

    while (iter.next()) |part| {
        try parts.append(part);
    }

    std.debug.print("Parts: {any}\n", .{parts.items});
}
```

### Trim whitespace

```zig
const std = @import("std");

fn trim_example() !void {
    const text = "   hello world   ";

    const trimmed = std.mem.trim(u8, text, " \t\n\r");
    const trimmed_left = std.mem.trimLeft(u8, text, " \t");
    const trimmed_right = std.mem.trimRight(u8, text, " \t");

    std.debug.print("Trimmed: '{s}'\n", .{trimmed});
}
```

### Replace substrings

```zig
const std = @import("std");

fn replace_example(allocator: std.mem.Allocator) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    const original = "hello world";
    const result = try std.mem.replaceOwned(u8, &gpa.allocator, original, "world", "Zig");
    defer gpa.allocator().free(result);

    std.debug.print("Replaced: {s}\n", .{result});
}
```

### Case conversion

```zig
const std = @import("std");

fn case_example() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{});
    defer _ = gpa.deinit();

    const text = "Hello, World!";

    // To uppercase (ASCII only)
    const upper = try std.ascii.allocUpperString(&gpa.allocator, text);
    defer gpa.allocator().free(upper);

    // To lowercase
    const lower = try std.ascii.allocLowerString(&gpa.allocator, text);
    defer gpa.allocator().free(lower);

    std.debug.print("Upper: {s}, Lower: {s}\n", .{upper, lower});
}
```

> **Note**: For UTF-8 aware string operations, use `std.unicode` module. Byte operations are faster but require UTF-8 safety.
