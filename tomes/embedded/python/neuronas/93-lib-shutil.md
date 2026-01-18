---
id: "py.lib.shutil"
title: "High-level File Operations (shutil)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, shutil, copy]
keywords: [copy, move, rmtree, make_archive]
use_cases: [copying files, recursive delete, archiving]
prerequisites: ["py.lib.os"]
related: ["py.lib.os"]
next_topics: []
---

# Shutil

The `shutil` module offers a number of high-level operations on files and collections of files.

## Copying and Moving

```python
import shutil

shutil.copy('source.txt', 'dest.txt')       # Copy file data
shutil.copy2('source.txt', 'dest.txt')      # Copy data + metadata
shutil.move('source.txt', 'new_dir/')       # Move file
```

## Directory Operations

```python
shutil.copytree('src_dir', 'dst_dir')       # Recursive copy
shutil.rmtree('dir_to_delete')              # Recursive delete (dangerous!)
```

## Archiving

```python
shutil.make_archive('archive', 'zip', 'root_dir')
```
