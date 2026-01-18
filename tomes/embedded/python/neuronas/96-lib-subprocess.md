---
id: "py.lib.subprocess"
title: "Subprocess (subprocess)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, system, process]
keywords: [run, Popen, pipe, shell]
use_cases: [running external commands]
prerequisites: ["py.lib.sys"]
related: ["py.lib.os"]
next_topics: []
---

# Subprocess

Spawn new processes, connect to their input/output/error pipes, and obtain their return codes.

## run()

The recommended approach.

```python
import subprocess

result = subprocess.run(['ls', '-l'], capture_output=True, text=True)
print(result.stdout)
```

## Popen

For complex interaction.

```python
p = subprocess.Popen(['ping', 'google.com'], stdout=subprocess.PIPE)
```
