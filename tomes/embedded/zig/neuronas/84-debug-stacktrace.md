---
id: "zig.debug.stacktrace"
title: "Stack Traces"
category: debug
difficulty: intermediate
tags: [zig, debug, stacktrace, error]
keywords: [Error Return Trace, return address]
use_cases: [debugging errors]
prerequisites: ["zig.types.error-unions"]
related: ["zig.debug.log"]
next_topics: []
---

# Stack Traces

Zig provides error return traces automatically when an error bubbles up from `main`.

## Inspection

Use `std.debug.dumpCurrentStackTrace(null)` to print manually.
