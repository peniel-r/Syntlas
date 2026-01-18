---
id: "py.lib.os"
title: "OS Interaction (os)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, os, system]
keywords: [os, environ, getcwd, mkdir]
use_cases: [file management, environment variables]
prerequisites: ["python.basics.variables"]
related: ["py.lib.sys", "py.lib.shutil"]
next_topics: ["py.lib.sys"]
---

# OS Interaction

The `os` module provides portable functionality to use operating system dependent functionality.

## Environment Variables

```python
import os

user = os.environ.get('USER', 'guest')
os.environ['MY_VAR'] = 'value'
```

## Filesystem Operations

Prefer `pathlib` for path manipulation, but `os` is used for low-level ops.

```python
cwd = os.getcwd()           # Get current directory
os.mkdir('new_dir')         # Make directory
os.listdir('.')             # List directory
os.remove('file.txt')       # Delete file
os.rmdir('empty_dir')       # Delete empty directory
os.rename('old', 'new')     # Rename
```
