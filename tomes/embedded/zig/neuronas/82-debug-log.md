---
id: "zig.debug.log"
title: "Logging"
category: debug
difficulty: beginner
tags: [zig, debug, log]
keywords: [log, info, warn, err]
use_cases: [output, diagnostics]
prerequisites: ["zig.basics.functions"]
related: ["zig.debug.panic"]
next_topics: ["zig.debug.panic"]
---

# Logging

`std.log` provides scoped logging.

## Usage

```zig
std.log.info("Hello {}", .{name});
std.log.err("Failed to open file", .{});
```

## Scopes

You can define `pub const std_options` to configure logging per scope.
