---
id: "zig.std.doublylinkedlist"
title: "DoublyLinkedList"
category: stdlib
difficulty: intermediate
tags: [zig, stdlib, list, linked]
keywords: [DoublyLinkedList, Node, append, pop]
use_cases: [insertion/deletion in middle]
prerequisites: ["zig.memory.management.allocators"]
related: ["zig.std.arraylist"]
next_topics: []
---

# DoublyLinkedList

## Usage

Nodes must be allocated manually (unlike `ArrayList` which handles its buffer).

```zig
const L = std.DoublyLinkedList(i32);
var list = L{};

var node = try allocator.create(L.Node);
node.data = 10;
list.append(node);
```
