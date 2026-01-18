---
id: "py.packaging.venv"
title: "Virtual Environments (venv)"
category: packaging
difficulty: beginner
tags: [python, packaging, venv, isolation]
keywords: [venv, activate, environment]
use_cases: [dependency isolation, project setup]
prerequisites: ["py.packaging.pip"]
related: ["py.packaging.pip"]
next_topics: []
---

# Virtual Environments

Isolate project dependencies to avoid conflicts.

## Creating

```bash
python -m venv .venv
```

## Activating

- **Windows**: `.venv\Scripts\activate`
- **Unix/MacOS**: `source .venv/bin/activate`

## Deactivating

```bash
deactivate
```
