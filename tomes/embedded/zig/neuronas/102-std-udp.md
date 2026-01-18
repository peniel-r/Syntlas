---
id: "zig.std.udp"
title: "UDP Sockets"
category: stdlib
difficulty: advanced
tags: [zig, stdlib, net, udp]
keywords: [bind, sendTo, recvFrom]
use_cases: [games, streaming]
prerequisites: ["zig.std.net"]
related: ["zig.std.net"]
next_topics: []
---

# UDP Sockets

Datagram sockets.

```zig
const sock = try std.posix.socket(std.posix.AF.INET, std.posix.SOCK.DGRAM, 0);
```

(Note: pure `std.net` UDP wrappers are evolving, often `std.posix` is used for control).
