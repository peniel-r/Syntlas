---
id: "zig.test.basics"
title: "Testing"
category: test
difficulty: beginner
tags: [zig, test, expect]
keywords: [test, expect, expectEqual]
use_cases: [verification]
prerequisites: ["zig.basics.functions"]
related: ["zig.test.allocator"]
next_topics: ["zig.test.allocator"]
---

# Testing

Tests are first-class citizens.

## Usage

```zig
const std = @import("std");
const expect = std.testing.expect;

test "basic math" {
    try expect(1 + 1 == 2);
}
```

## Running

```bash
zig test main.zig
```
