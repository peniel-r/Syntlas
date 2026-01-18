---
id: "zig.types.error-unions"
title: "Error Unions"
category: types
difficulty: intermediate
tags: [zig, types, error, result]
keywords: [!, catch, try, error]
use_cases: [error handling]
prerequisites: ["zig.types.optionals"]
related: ["zig.basics.defer"]
next_topics: []
---

# Error Unions

Type `!T` means "Success value `T` OR an Error".

## Error Set

```zig
const FileError = error{
    NotFound,
    PermissionDenied,
};
```

## Usage

```zig
fn open() FileError!void {
    return error.NotFound;
}

// Handling
open() catch |err| {
    // handle err
};

// Propagating
try open();
```
