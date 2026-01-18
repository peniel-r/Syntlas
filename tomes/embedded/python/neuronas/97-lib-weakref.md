---
id: "py.lib.weakref"
title: "Weak References (weakref)"
category: stdlib
difficulty: advanced
tags: [python, stdlib, memory, weakref]
keywords: [weakref, ref, proxy]
use_cases: [caching, preventing cycles]
prerequisites: ["py.lib.gc"]
related: ["py.lib.gc"]
next_topics: []
---

# Weak References

A weak reference to an object does not keep it alive. If the only references to an object are weak, it gets garbage collected.

## Usage

```python
import weakref

class A: pass
a = A()
r = weakref.ref(a)

print(r())  # <__main__.A object ...>
del a
print(r())  # None
```
