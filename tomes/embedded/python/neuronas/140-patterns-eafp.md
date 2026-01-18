---
id: "py.patterns.eafp"
title: "EAFP vs LBYL"
category: patterns
difficulty: intermediate
tags: [python, patterns, idioms, error-handling]
keywords: [EAFP, LBYL, try-except]
use_cases: [pythonic error handling, race conditions]
prerequisites: ["python.exceptions"]
related: ["python.exceptions"]
next_topics: []
---

# EAFP

**E**asier to **A**sk for **F**orgiveness than **P**ermission. This is a common Python coding style.

## LBYL (Look Before You Leap)

```python
if 'key' in my_dict:
    value = my_dict['key']
else:
    value = None
```

## EAFP (Pythonic)

Assumes existence, catches error if missing. Often faster and avoids race conditions.

```python
try:
    value = my_dict['key']
except KeyError:
    value = None
```
