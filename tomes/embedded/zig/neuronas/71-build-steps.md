---
id: "zig.build.steps"
title: "Build Steps"
category: build
difficulty: intermediate
tags: [zig, build, steps]
keywords: [step, run, install]
use_cases: [custom commands]
prerequisites: ["zig.build.basics"]
related: ["zig.build.modules"]
next_topics: ["zig.build.modules"]
---

# Build Steps

Commands you run (`zig build run`, `zig build test`).

## Creating Steps

```zig
const run_cmd = b.addRunArtifact(exe);
const run_step = b.step("run", "Run the app");
run_step.dependOn(&run_cmd.step);
```
