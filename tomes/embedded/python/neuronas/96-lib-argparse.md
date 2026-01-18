---
id: "py.lib.argparse"
title: "Argparse (argparse)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, cli, arguments]
keywords: [ArgumentParser, add_argument, parse_args]
use_cases: [cli tools, script configuration]
prerequisites: ["py.lib.sys"]
related: ["py.lib.sys"]
next_topics: []
---

# Argparse

The recommended command-line parsing module.

## Example

```python
import argparse

parser = argparse.ArgumentParser(description='Process numbers.')
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('--sum', dest='accumulate', action='store_const',
                    const=sum, default=max,
                    help='sum the integers (default: find the max)')

args = parser.parse_args()
print(args.accumulate(args.integers))
```
