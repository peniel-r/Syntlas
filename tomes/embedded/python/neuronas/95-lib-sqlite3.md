---
id: "py.lib.sqlite3"
title: "SQLite (sqlite3)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, database, sql]
keywords: [sqlite3, connect, cursor, execute]
use_cases: [local database, embedded storage]
prerequisites: ["py.io.files"]
related: ["py.lib.csv"]
next_topics: []
---

# SQLite3

Built-in interface for SQLite databases.

## Usage

```python
import sqlite3

con = sqlite3.connect('example.db')
cur = con.cursor()

# Create table
cur.execute('''CREATE TABLE stocks (date text, symbol text, price real)''')

# Insert
cur.execute("INSERT INTO stocks VALUES ('2023-01-01', 'RHAT', 100)")
con.commit()

# Select
for row in cur.execute('SELECT * FROM stocks'):
    print(row)

con.close()
```
