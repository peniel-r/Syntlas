---
id: "py.lib.calendar"
title: "Calendar (calendar)"
category: stdlib
difficulty: beginner
tags: [python, stdlib, calendar, dates]
keywords: [calendar, month, weekday]
use_cases: [date calculations, printing calendars]
prerequisites: ["python.stdlib.datetime"]
related: ["python.stdlib.datetime"]
next_topics: []
---

# Calendar Module

Functions to output calendars and handle date calculations.

## Text Calendar

```python
import calendar

c = calendar.TextCalendar(calendar.SUNDAY)
c.prmonth(2023, 12)
```

## Functions

```python
calendar.isleap(2024)   # True
calendar.weekday(2023, 12, 25) # 0 (Monday)
```
