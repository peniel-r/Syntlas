---
id: "zig.build.custom"
title: "Custom Build Steps"
category: build
difficulty: advanced
tags: [zig, build, step]
keywords: [step, make]
use_cases: [code generation]
prerequisites: ["zig.build.steps"]
related: ["zig.build.options"]
next_topics: []
---

# Custom Steps

You can define arbitrary logic in `build.zig`.

```zig
const step = b.step("codegen", "Generate code");
step.makeFn = myMakeFn;

fn myMakeFn(step: *std.Build.Step, prog_node: *std.Progress.Node) anyerror!void {
    _ = step; _ = prog_node;
    // ... logic ...
}
```
