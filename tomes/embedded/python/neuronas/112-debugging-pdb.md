---
id: "py.debugging.pdb"
title: "Debugger (PDB)"
category: debugging
difficulty: intermediate
tags: [python, debugging, pdb, breakpoint]
keywords: [pdb, breakpoint, step, continue]
use_cases: [troubleshooting, inspection]
prerequisites: ["py.basics.functions"]
related: ["py.debugging.traceback"]
next_topics: []
---

# PDB (Python Debugger)

Interactive source code debugger.

## Usage

Insert `breakpoint()` in your code (Python 3.7+).

```python
def bug():
    x = 1
    breakpoint()  # Pauses execution here
    y = 2
```

## Commands

- `n` (next): Execute next line
- `s` (step): Step into function
- `c` (continue): Continue execution
- `p variable`: Print variable
- `q` (quit): Exit
