---
id: "py.lib.csv"
title: "CSV (csv)"
category: stdlib
difficulty: intermediate
tags: [python, stdlib, csv, data]
keywords: [csv, reader, writer, DictReader]
use_cases: [data import/export, spreadsheets]
prerequisites: ["py.io.files"]
related: ["python.stdlib.json"]
next_topics: []
---

# CSV Module

Read and write Comma Separated Values files.

## Reading

```python
import csv

with open('data.csv', newline='') as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```

## Writing

```python
with open('output.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Name', 'Age'])
    writer.writerow(['Alice', 30])
```
