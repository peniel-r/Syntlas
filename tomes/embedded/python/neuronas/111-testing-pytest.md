---
id: "py.testing.pytest"
title: "Pytest"
category: testing
difficulty: intermediate
tags: [python, testing, pytest, ecosystem]
keywords: [pytest, fixture, assert]
use_cases: [modern testing, fixtures]
prerequisites: ["python.functions.def"]
related: ["py.testing.unittest"]
next_topics: []
---

# Pytest

Popular third-party testing framework. simpler than `unittest`.

## Usage

Uses standard `assert` statements.

```python
# test_sample.py
def func(x):
    return x + 1

def test_answer():
    assert func(3) == 4
```

## Fixtures

Dependency injection for tests.

```python
import pytest

@pytest.fixture
def data():
    return {"a": 1}

def test_data(data):
    assert data["a"] == 1
```
