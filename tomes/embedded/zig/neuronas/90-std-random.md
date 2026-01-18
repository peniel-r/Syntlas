---
id: "zig.std.random"
title: "Random Numbers"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, random, rng]
keywords: [Random, DefaultPrng, int, boolean]
use_cases: [games, simulation, crypto]
prerequisites: ["zig.basics.values"]
related: ["zig.std.crypto"]
next_topics: []
---

# Random

## Pseudo-Random

```zig
var prng = std.rand.DefaultPrng.init(blk: {
    var seed: u64 = undefined;
    try std.os.getrandom(std.mem.asBytes(&seed));
    break :blk seed;
});
const rand = prng.random();

const n = rand.int(i32);
const b = rand.boolean();
```
