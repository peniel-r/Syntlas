---
id: "python.pathlib"
title: "Pathlib - Object-Oriented Paths"
category: stdlib
difficulty: intermediate
tags: [python, pathlib, file-system, paths]
keywords: [Path, file operations, directory traversal]
use_cases: [file handling, path manipulation, cross-platform code]
prerequisites: ["python.basics.strings"]
related: ["python.stdlib.io"]
next_topics: []
---

# Pathlib

`pathlib` provides an object-oriented interface for filesystem paths.

## Creating Paths

```python
from pathlib import Path

# Current directory
current = Path.cwd()

# Home directory
home = Path.home()

# Specific path
file_path = Path("/home/user/documents/file.txt")

# Join paths
config_dir = Path.home() / "config" / "app.json"
```

## Path Properties

```python
path = Path("/home/user/documents/report.pdf")

print(path.name)           # report.pdf
print(path.stem)           # report
print(path.suffix)         # .pdf
print(path.parent)          # /home/user/documents
print(path.anchor)         # / (root)
```

## Path Methods

```python
path = Path("/home/user/documents")

# Resolve to absolute path
abs_path = path.resolve()
# /home/user/documents

# Check existence
print(path.exists())      # True
print(path.is_dir())       # True
print(path.is_file())      # False

# Check type
file_path = Path("data.txt")
print(file_path.is_file())   # True

# Get stat
print(path.stat().st_size)  # File size in bytes
```

## Reading and Writing Files

```python
from pathlib import Path

file_path = Path("data.txt")

# Write
file_path.write_text("Hello, World!")

# Read
content = file_path.read_text()
print(content)

# Write bytes
file_path.write_bytes(b"Binary data")

# Read bytes
data = file_path.read_bytes()
```

## Directory Operations

```python
from pathlib import Path

# Create directory
dir_path = Path("new_directory")
dir_path.mkdir(exist_ok=True)

# Create nested directories
nested = Path("a/b/c/d")
nested.mkdir(parents=True, exist_ok=True)

# List contents
items = list(Path.cwd().iterdir())
for item in items:
    print(item.name)

# Glob patterns
py_files = list(Path.cwd().glob("*.py"))
md_files = list(Path.cwd().rglob("*.md"))  # Recursive
```

## File Operations

```python
from pathlib import Path

# Copy
source = Path("source.txt")
dest = Path("destination.txt")
source.replace(dest)  # Overwrites if exists

# Rename
old_name = Path("old.txt")
new_name = Path("new.txt")
old_name.rename(new_name)

# Delete
file_path = Path("to_delete.txt")
file_path.unlink()  # Deletes file

# Remove directory (must be empty)
dir_path = Path("empty_dir")
dir_path.rmdir()  # Deletes empty directory

# Remove tree (non-empty)
import shutil
tree_path = Path("non_empty_dir")
shutil.rmtree(tree_path)  # Deletes recursively
```

## Iterating Directory Tree

```python
from pathlib import Path

root = Path("/home/user")

# Walk directory tree
for path in root.rglob("*.txt"):
    print(f"File: {path}")

# Or iterate manually
for item in root.iterdir():
    if item.is_dir():
        print(f"Directory: {item}")
    elif item.is_file():
        print(f"File: {item}")
```

## Parts of Path

```python
from pathlib import PurePath

path = PurePath("/usr/local/bin/python")

parts = path.parts
# ('/', 'usr', 'local', 'bin', 'python')

parents = path.parents
# [PurePosixPath('/usr/local/bin'), PurePosixPath('/usr/local'), ...]
```

## Path vs os.path

```python
# OLD: os.path
import os.path

file_path = os.path.join("dir", "subdir", "file.txt")
if os.path.exists(file_path):
    with open(file_path) as f:
        content = f.read()

# NEW: pathlib (recommended)
from pathlib import Path

file_path = Path("dir") / "subdir" / "file.txt"
if file_path.exists():
    content = file_path.read_text()
```

## Common Patterns

### Safe file operations
```python
from pathlib import Path

def safe_write(path: Path, content: str):
    """Write to temp file then rename for atomicity."""
    temp_path = path.with_suffix(".tmp")
    temp_path.write_text(content)
    temp_path.replace(path)

safe_write(Path("important.txt"), "Critical data")
```

### Find files recursively
```python
from pathlib import Path

def find_files(root: Path, pattern: str):
    """Find all files matching pattern."""
    return list(root.rglob(pattern))

python_files = find_files(Path.cwd(), "*.py")
```

### Cleanup old files
```python
from pathlib import Path
from datetime import datetime, timedelta

def cleanup_old_files(directory: Path, days: int, pattern: str):
    """Delete files older than N days."""
    cutoff = datetime.now() - timedelta(days=days)
    for path in directory.glob(pattern):
        if path.is_file():
            mtime = datetime.fromtimestamp(path.stat().st_mtime)
            if mtime < cutoff:
                path.unlink()

cleanup_old_files(Path("/tmp/logs"), days=7, pattern="*.log")
```

### Create unique filename
```python
from pathlib import Path

def unique_filename(directory: Path, base: str, ext: str) -> Path:
    """Generate unique filename."""
    path = directory / f"{base}.{ext}"
    counter = 1
    while path.exists():
        path = directory / f"{base}_{counter}.{ext}"
        counter += 1
    return path

filename = unique_filename(Path("/tmp"), "report", "txt")
```

### Backup file before overwrite
```python
from pathlib import Path

def backup_and_write(path: Path, content: str):
    """Create backup before writing."""
    if path.exists():
        backup = path.with_suffix(f"{path.suffix}.bak")
        path.replace(backup)
    path.write_text(content)

backup_and_write(Path("config.json"), new_config)
```

> **Advantage**: Pathlib works cross-platform (handles `/` on Unix, `\` on Windows automatically).
