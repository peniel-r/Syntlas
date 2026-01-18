---
id: "py.lib.tempfile"
title: "Tempfile (tempfile)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, io, temp]
keywords: [TemporaryFile, NamedTemporaryFile, mkdtemp]
use_cases: [temporary storage, testing]
prerequisites: ["py.io.files"]
related: ["py.lib.os"]
next_topics: []
---

# Tempfile

Generate temporary files and directories.

## Usage

```python
import tempfile

# Automatically deleted on close
with tempfile.TemporaryFile() as fp:
    fp.write(b'Hello world!')
    fp.seek(0)
    print(fp.read())

# Named temp file
with tempfile.NamedTemporaryFile(delete=True) as fp:
    print(fp.name)
```
