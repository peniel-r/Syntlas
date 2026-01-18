---
id: "python.basics.strings"
title: "String Operations"
category: language
difficulty: novice
tags: [python, strings, text, formatting]
keywords: [concatenation, slicing, methods, f-strings]
use_cases: [text processing, string manipulation, formatting output]
prerequisites: ["python.basics.types"]
related: ["python.datastructures.lists"]
next_topics: ["python.controlflow.if"]
---

# String Operations

Strings in Python are immutable sequences of Unicode characters.

## String Creation

```python
s1 = 'single quotes'
s2 = "double quotes"
s3 = '''triple single
quotes for multiline'''
s4 = """triple double
quotes for multiline"""
```

## String Concatenation

```python
first = "Hello"
last = "World"
full = first + " " + last  # "Hello World"

# Using join for multiple strings (more efficient)
words = ["Hello", "beautiful", "world"]
sentence = " ".join(words)  # "Hello beautiful world"
```

## String Slicing

```python
text = "Hello, World!"

text[0]      # 'H' (first character)
text[-1]     # '!' (last character)
text[0:5]    # 'Hello' (slice from 0 to 4)
text[:5]      # 'Hello' (from start to 4)
text[7:]      # 'World' (from 7 to end)
text[::2]     # 'Hlo ol' (every 2nd character)
text[::-1]    # '!dlroW ,olleH' (reverse)
```

## Common String Methods

```python
text = "Hello, World!"

text.lower()      # 'hello, world!'
text.upper()      # 'HELLO, WORLD!'
text.title()      # 'Hello, World!'
text.strip()      # 'Hello, World!' (removes whitespace)
text.replace("World", "Python")  # 'Hello, Python!'

text.startswith("Hello")  # True
text.endswith("!")       # True
"Hello" in text         # True

text.split(",")   # ['Hello', ' World!']
text.split()     # ['Hello,', 'World!'] (splits on whitespace)

text.find("World")     # 7 (index, -1 if not found)
text.count("l")        # 3 (count occurrences)
```

## String Formatting

### f-strings (Python 3.6+, recommended)

```python
name = "Alice"
age = 30
message = f"Hello, {name}. You are {age} years old."
# 'Hello, Alice. You are 30 years old.'

# Expressions in f-strings
x = 10
result = f"x squared is {x**2}"  # 'x squared is 100'

# Formatting options
pi = 3.14159
print(f"Pi: {pi:.2f}")     # 'Pi: 3.14'
print(f"{pi:>10.2f}")        # '      3.14' (right aligned)
```

### format() method

```python
message = "Hello, {}. You are {}.".format("Bob", 25)
# 'Hello, Bob. You are 25.'

# Named placeholders
message = "Name: {name}, Age: {age}".format(name="Carol", age=28)
# 'Name: Carol, Age: 28'

# Positional arguments
print("{0} {1} {0}".format("spam", "eggs"))  # 'spam eggs spam'
```

### %-formatting (legacy)

```python
name = "Alice"
age = 30
message = "Name: %s, Age: %d" % (name, age)
# 'Name: Alice, Age: 30'
```

## Escape Sequences

```python
text = "Line 1\nLine 2"     # newline
path = "C:\\path\\to\\file"  # backslash
quote = 'He said "Hello"'    # double quote inside single
```

> **Best Practice**: Use f-strings for string formatting - they're readable and performant.
