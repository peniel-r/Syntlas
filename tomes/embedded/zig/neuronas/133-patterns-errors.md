---
id: "zig.patterns.errors"
title: "Error Context"
category: patterns
difficulty: intermediate
tags: [zig, patterns, error, context]
keywords: [errdefer, diagnostics]
use_cases: [rich error reporting]
prerequisites: ["zig.types.error-unions"]
related: ["zig.basics.defer"]
next_topics: []
---

# Error Context

Adding context to errors often involves returning a struct or using diagnostics.

```zig
if (res) |_| {} else |err| {
    std.log.err("Failed operation: {}", .{err});
    return err;
}
```
