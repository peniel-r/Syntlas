---
id: "python.stdlib.datetime"
title: "Date and Time Handling"
category: stdlib
difficulty: intermediate
tags: [python, datetime, time, timestamps]
keywords: [datetime, timedelta, strftime, parsing]
use_cases: [timestamps, scheduling, date calculations]
prerequisites: ["python.basics.types"]
related: ["python.stdlib.json"]
next_topics: []
---

# Datetime Module

`datetime` module provides date and time manipulation.

## Creating Dates and Times

```python
from datetime import datetime, date, time, timedelta

# Current date/time
now = datetime.now()        # 2026-01-18 14:30:00
today = date.today()        # 2026-01-18
current_time = time.now()  # 14:30:00

# From components
dt = datetime(2026, 1, 18, 14, 30, 0)
d = date(2026, 1, 18)
t = time(14, 30, 0)

# From ISO string
dt = datetime.fromisoformat("2026-01-18T14:30:00")
```

## String Formatting

```python
from datetime import datetime

dt = datetime(2026, 1, 18, 14, 30, 0)

# Common formats
print(dt.strftime("%Y-%m-%d"))           # 2026-01-18
print(dt.strftime("%H:%M:%S"))           # 14:30:00
print(dt.strftime("%A, %B %d, %Y"))   # Sunday, January 18, 2026
print(dt.strftime("%I:%M %p"))           # 02:30 PM

# RFC 3339 (ISO 8601)
print(dt.isoformat())                    # 2026-01-18T14:30:00
```

## Parsing Dates

```python
from datetime import datetime

# From string
dt = datetime.strptime("2026-01-18 14:30", "%Y-%m-%d %H:%M")

# Multiple formats
formats = ["%Y-%m-%d", "%Y/%m/%d", "%d-%m-%Y"]
for fmt in formats:
    try:
        dt = datetime.strptime(date_string, fmt)
        print(f"Matched: {fmt}")
        break
    except ValueError:
        continue
```

## Date Arithmetic

```python
from datetime import datetime, timedelta

now = datetime.now()

# Add time
tomorrow = now + timedelta(days=1)
next_week = now + timedelta(weeks=1)
in_2_hours = now + timedelta(hours=2)

# Subtract time
yesterday = now - timedelta(days=1)
last_month = now - timedelta(days=30)

# Calculate difference
event1 = datetime(2026, 1, 1)
event2 = datetime(2026, 1, 15)
diff = event2 - event1
print(diff.days)  # 14
```

## Time Zones

```python
from datetime import datetime, timezone, timedelta

# Create timezone
tz = timezone(timedelta(hours=-5))  # EST
dt = datetime.now(tz)

# UTC
utc = datetime.now(timezone.utc)

# Convert between zones
eastern = datetime.now(tz)
utc_time = eastern.astimezone(timezone.utc)
```

## Common Operations

```python
from datetime import datetime, timedelta

# Get components
dt = datetime(2026, 1, 18, 14, 30, 0)
print(dt.year)      # 2026
print(dt.month)     # 1
print(dt.day)       # 18
print(dt.hour)      # 14
print(dt.minute)    # 30
print(dt.weekday())  # 0 (Monday = 0)

# Start/end of day
start_of_day = dt.replace(hour=0, minute=0, second=0, microsecond=0)
end_of_day = dt.replace(hour=23, minute=59, second=59, microsecond=999999)

# First day of month
first_of_month = dt.replace(day=1)
```

## Date Ranges

```python
from datetime import datetime, timedelta

# Date range generator
def date_range(start, end, delta=timedelta(days=1)):
    current = start
    while current <= end:
        yield current
        current += delta

# Usage
for day in date_range(
    datetime(2026, 1, 1),
    datetime(2026, 1, 7)
):
    print(day.strftime("%Y-%m-%d"))
```

## Common Use Cases

### Calculate age
```python
from datetime import datetime, date

def calculate_age(birth_date):
    today = date.today()
    age = today.year - birth_date.year - (
        (today.month, today.day) < (birth_date.month, birth_date.day)
    )
    return age

age = calculate_age(date(1990, 5, 15))
```

### Business days (excluding weekends)
```python
from datetime import datetime, timedelta

def is_business_day(dt):
    return dt.weekday() < 5  # Monday=0 to Friday=4

def add_business_days(start, days):
    current = start
    added = 0
    while added < days:
        current += timedelta(days=1)
        if is_business_day(current):
            added += 1
    return current
```

### Time until event
```python
from datetime import datetime, timedelta

def time_until(event_time):
    now = datetime.now()
    if event_time <= now:
        return timedelta(0)
    delta = event_time - now
    days = delta.days
    hours, remainder = divmod(delta.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    return f"{days}d {hours}h {minutes}m {seconds}s"

event = datetime(2026, 12, 25, 0, 0, 0)
print(f"Christmas is in {time_until(event)}")
```

### Format for logging
```python
from datetime import datetime

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
logger.info(f"[{timestamp}] Operation completed")
```

### Parse flexible date input
```python
from datetime import datetime
import re

def parse_date_flexible(date_str):
    """Try common date formats."""
    formats = [
        "%Y-%m-%d",
        "%Y/%m/%d",
        "%d-%m-%Y",
        "%m/%d/%Y"
    ]

    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    raise ValueError(f"Cannot parse date: {date_str}")
```

### Find next weekday
```python
from datetime import datetime, timedelta

def next_weekday(target_weekday, from_date):
    """Find next occurrence of target weekday (0=Monday)."""
    days_ahead = (target_weekday - from_date.weekday()) % 7
    if days_ahead == 0:
        days_ahead = 7
    return from_date + timedelta(days=days_ahead)

today = datetime.now()
next_monday = next_weekday(0, today)
```

> **Note**: For complex timezone handling, consider the third-party `pytz` or `zoneinfo` (Python 3.9+).
