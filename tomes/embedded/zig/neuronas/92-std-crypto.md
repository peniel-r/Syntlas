---
id: "zig.std.crypto"
title: "Crypto"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, crypto, hash]
keywords: [crypto, hash, sha256, aes]
use_cases: [hashing, encryption]
prerequisites: ["zig.basics.slices"]
related: ["zig.std.random"]
next_topics: []
---

# Crypto

Zig's crypto library is performant and secure.

## Hashing

```zig
var hash: [std.crypto.hash.sha2.Sha256.digest_length]u8 = undefined;
std.crypto.hash.sha2.Sha256.hash("hello", &hash);
```
