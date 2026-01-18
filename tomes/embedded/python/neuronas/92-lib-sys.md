---
id: "py.lib.sys"
title: "System Parameters (sys)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, sys, interpreter]
keywords: [sys, argv, exit, path, stdin]
use_cases: [cli args, interpreter config]
prerequisites: ["python.basics.variables"]
related: ["py.lib.os"]
next_topics: []
---

# System Parameters

The `sys` module provides access to variables used or maintained by the interpreter.

## Command Line Arguments

```python
import sys

# sys.argv[0] is the script name
for arg in sys.argv:
    print(arg)
```

## Standard Streams

```python
sys.stdout.write("Hello\n")
sys.stderr.write("Error!\n")
```

## Exiting

```python
sys.exit(0)  # Success
sys.exit(1)  # Failure
```

## Python Path

`sys.path` is a list of strings that specifies the search path for modules.

```
