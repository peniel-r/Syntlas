---
id: "py.typing.annotated"
title: "Annotated"
category: typing
difficulty: advanced
tags: [python, typing, metadata]
keywords: [Annotated, metadata]
use_cases: [validation, serialization frameworks]
prerequisites: ["python.basics.types"]
related: ["py.typing.generics"]
next_topics: []
---

# Annotated

Attaches metadata to type hints. Ignored by static type checkers but used by runtime tools (like Pydantic or FastAPI).

```python
from typing import Annotated

# "Age must be between 0 and 120"
Age = Annotated[int, "0-120"]

def set_age(a: Age):
    pass
```
