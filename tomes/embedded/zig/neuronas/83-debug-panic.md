---
id: "zig.debug.panic"
title: "Panic"
category: debug
difficulty: intermediate
tags: [zig, debug, panic, crash]
keywords: [@panic, unreachable]
use_cases: [fatal errors]
prerequisites: ["zig.basics.functions"]
related: ["zig.debug.stacktrace"]
next_topics: ["zig.debug.stacktrace"]
---

# Panic

Terminates the program.

## Usage

```zig
if (something_bad) {
    @panic("Something went wrong");
}
```

## Unreachable

Hints to optimizer that code path is impossible. If reached in Debug/ReleaseSafe, it panics.

```zig
unreachable;
```
