---
id: "py.typing.callable"
title: "Callable"
category: typing
difficulty: intermediate
tags: [python, typing, callable, functions]
keywords: [Callable, callback]
use_cases: [callbacks, higher-order functions]
prerequisites: ["py.functions.basics"]
related: ["py.typing.protocol"]
next_topics: []
---

# Callable

Type hint for functions or other callable objects.

## Syntax

`Callable[[Arg1Type, Arg2Type], ReturnType]`

```python
from typing import Callable

def execute(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

execute(lambda x, y: x + y, 1, 2)
```
