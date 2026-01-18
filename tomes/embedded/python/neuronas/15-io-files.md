---
id: "py.io.files"
title: "File I/O"
category: io
difficulty: beginner
tags: [python, io, files, open]
keywords: [open, read, write, with statement]
use_cases: [reading data, writing logs, persistence]
prerequisites: ["python.basics.strings", "python.patterns.context-managers"]
related: ["py.io.bytes", "python.pathlib"]
next_topics: ["py.io.bytes"]
---

# File Input/Output

Reading and writing files is a core capability.

## Opening Files

Use the `open()` function with the `with` statement (context manager) to ensure files are closed properly.

```python
# Reading
with open('data.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# Writing (overwrites)
with open('output.txt', 'w', encoding='utf-8') as f:
    f.write('Hello World')

# Appending
with open('log.txt', 'a', encoding='utf-8') as f:
    f.write('New entry\n')
```

## Modes

- `'r'`: Read (default)
- `'w'`: Write (truncate)
- `'a'`: Append
- `'b'`: Binary mode (e.g., `'rb'`, `'wb'`)
- `'x'`: Exclusive creation (fails if exists)

## Reading Lines

```python
with open('data.txt') as f:
    for line in f:
        print(line.strip())
```

```
