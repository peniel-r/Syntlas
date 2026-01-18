---
id: "py.lib.gc"
title: "Garbage Collection (gc)"
category: stdlib
difficulty: advanced
tags: [python, stdlib, memory, gc]
keywords: [gc, collect, cycles]
use_cases: [memory leak debugging, manual collection]
prerequisites: ["py.basics.variables"]
related: ["py.lib.weakref"]
next_topics: []
---

# Garbage Collection

Python uses reference counting + a cyclic garbage collector.

## gc Module

Control the cyclic GC.

```python
import gc

gc.collect()        # Force collection
gc.disable()        # Disable automatic GC
gc.get_objects()    # Get all tracked objects
```

## Reference Cycles

Occur when object A refers to B, and B refers to A. Reference counting cannot free them; GC handles this.
