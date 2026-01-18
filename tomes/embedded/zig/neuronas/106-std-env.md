---
id: "zig.std.env"
title: "Environment Variables"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, env, os]
keywords: [getEnvVarOwned, hasEnvVar]
use_cases: [configuration]
prerequisites: ["zig.std.process"]
related: ["zig.std.process"]
next_topics: []
---

# Environment Variables

```zig
const path = try std.process.getEnvVarOwned(allocator, "PATH");
defer allocator.free(path);
```
