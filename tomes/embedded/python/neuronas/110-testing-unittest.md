---
id: "py.testing.unittest"
title: "Unittest"
category: testing
difficulty: intermediate
tags: [python, testing, stdlib]
keywords: [unittest, TestCase, assertEqual]
use_cases: [unit testing, test suites]
prerequisites: ["py.oop.classes"]
related: ["py.testing.pytest"]
next_topics: ["py.testing.pytest"]
---

# Unittest

Python's built-in testing framework (xUnit style).

```python
import unittest

def add(a, b):
    return a + b

class TestMath(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(1, 2), 3)

if __name__ == '__main__':
    unittest.main()
```
