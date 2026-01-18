---
id: "zig.test.allocator"
title: "Test Allocator"
category: test
difficulty: intermediate
tags: [zig, test, memory, leak]
keywords: [testing.allocator, leak detection]
use_cases: [checking memory safety]
prerequisites: ["zig.test.basics"]
related: ["zig.memory.management.gpa"]
next_topics: []
---

# Test Allocator

`std.testing.allocator` detects memory leaks automatically at the end of a test block.

```zig
test "memory" {
    const ptr = try std.testing.allocator.create(i32);
    // defer std.testing.allocator.destroy(ptr); // if missing -> fail
}
```
