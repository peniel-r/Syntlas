---
id: "py.functions.generators"
title: "Generators"
category: functions
difficulty: intermediate
tags: [python, functions, generator, yield]
keywords: [yield, next, iter, lazy evaluation]
use_cases: [memory efficient iteration, pipelines, streams]
prerequisites: ["py.functions.basics", "py.control.for"]
related: ["py.functional.map-filter"]
next_topics: []
---

# Generators

Generators allow you to declare a function that behaves like an iterator. They allow you to make an iterator in a fast, easy, and clean way.

## The `yield` Keyword

When `yield` is used, the function becomes a generator. It saves its state and resumes from there when `next()` is called.

```python
def count_up_to(max):
    count = 1
    while count <= max:
        yield count
        count += 1

counter = count_up_to(5)
for num in counter:
    print(num)
```

## Generator Expressions

Similar to list comprehensions, but with parentheses. Lazy evaluation.

```python
squares = (x*x for x in range(10))
```
