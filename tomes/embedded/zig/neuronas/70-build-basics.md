---
id: "zig.build.basics"
title: "Build System Basics"
category: build
difficulty: beginner
tags: [zig, build, build.zig]
keywords: [build.zig, std.Build, addExecutable]
use_cases: [compiling projects]
prerequisites: ["zig.basics.functions"]
related: ["zig.build.steps"]
next_topics: ["zig.build.steps"]
---

# Build System

Zig includes a build system written in Zig.

## build.zig

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "my-exe",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
}
```
