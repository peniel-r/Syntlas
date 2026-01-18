---
id: "python.basics.operators"
title: "Operators and Expressions"
category: language
difficulty: novice
tags: [python, basics, operators, expressions]
keywords: [arithmetic, comparison, logical, bitwise, operator precedence]
use_cases: [calculations, conditions, boolean logic]
prerequisites: ["python.basics.types"]
related: ["python.controlflow.if", "python.controlflow.while"]
next_topics: ["python.basics.strings"]
---

# Operators and Expressions

Python provides various operators for performing computations and comparisons.

## Arithmetic Operators

```python
a = 10
b = 3

a + b   # 13 (addition)
a - b   # 7  (subtraction)
a * b   # 30 (multiplication)
a / b   # 3.333... (division, returns float)
a // b  # 3  (floor division)
a % b   # 1  (modulo/remainder)
a ** b   # 1000 (exponentiation)
```

## Comparison Operators

```python
x = 5

x == 5   # True (equal)
x != 3   # True (not equal)
x < 10   # True (less than)
x > 2    # True (greater than)
x <= 5   # True (less than or equal)
x >= 5   # True (greater than or equal)
```

## Logical Operators

```python
a = True
b = False

a and b   # False (both must be True)
a or b    # True (at least one True)
not a      # False (negation)
```

Short-circuit evaluation:
```python
# If first condition is False, second isn't evaluated
if x != 0 and 1/x > 0:
    pass
```

## Assignment Operators

```python
x = 10
x += 5    # x = x + 5  → 15
x -= 3    # x = x - 3  → 12
x *= 2    # x = x * 2  → 24
x /= 4    # x = x / 4  → 6.0
x //= 2   # x = x // 2 → 3.0
x %= 3    # x = x % 3  → 0.0
x **= 2   # x = x ** 2 → 9.0
```

## Bitwise Operators

```python
a = 5   # binary: 101
b = 3   # binary: 011

a & b     # 1  (AND)
a | b     # 7  (OR)
a ^ b     # 6  (XOR)
~a        # -6 (NOT)
a << 1    # 10 (left shift)
a >> 1    # 2  (right shift)
```

## Operator Precedence

```python
# Higher precedence operators are evaluated first
result = 2 + 3 * 4    # 14 (multiplication before addition)
result = (2 + 3) * 4  # 20 (parentheses change order)
```

Precedence (highest to lowest):
1. Parentheses `()`
2. Exponentiation `**`
3. Unary `+x, -x, ~x`
4. Multiplication, Division, Modulo `*, /, //, %`
5. Addition, Subtraction `+, -`
6. Bit shifts `<<, >>`
7. Bitwise AND `&`
8. Bitwise XOR `^`
9. Bitwise OR `|`
10. Comparisons `in, not in, is, is not, <, <=, >, >=, !=, ==`
11. Boolean NOT `not`
12. Boolean AND `and`
13. Boolean OR `or`

> **Tip**: When in doubt, use parentheses for clarity.
