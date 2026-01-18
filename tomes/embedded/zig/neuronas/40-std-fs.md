---
id: "zig.std.fs"
title: "File System"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, fs, file]
keywords: [fs, cwd, openFile, createFile]
use_cases: [file manipulation]
prerequisites: ["zig.std.arraylist"]
related: ["zig.std.io"]
next_topics: ["zig.std.io"]
---

# File System

Access files via `std.fs`.

## Current Working Directory

```zig
var dir = std.fs.cwd();
```

## Opening/Creating

```zig
const file = try dir.createFile("output.txt", .{});
defer file.close();

const open_file = try dir.openFile("input.txt", .{});
defer open_file.close();
```
