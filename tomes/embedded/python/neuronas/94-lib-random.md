---
id: "py.lib.random"
title: "Random (random)"
category: stdlib
difficulty: beginner
tags: [python, stdlib, random, probability]
keywords: [random, randint, choice, shuffle]
use_cases: [games, simulations, sampling]
prerequisites: ["py.basics.operators"]
related: ["py.lib.math"]
next_topics: []
---

# Random Module

Generates pseudo-random numbers.

## Integers

```python
import random
n = random.randint(1, 10)  # Inclusive [1, 10]
```

## Sequences

```python
items = ['a', 'b', 'c']
chosen = random.choice(items)
random.shuffle(items)      # In-place
sample = random.sample(items, 2)
```

## Floats

```python
f = random.random()  # [0.0, 1.0)
```
