---
id: "py.packaging.structure"
title: "Project Structure"
category: packaging
difficulty: intermediate
tags: [python, packaging, structure, layout]
keywords: [src layout, package, __init__.py]
use_cases: [organizing code, distribution]
prerequisites: ["python.basics.types"]
related: ["py.packaging.pyproject"]
next_topics: []
---

# Project Structure

Standard layout for Python projects.

```text
project_name/
├── pyproject.toml       # Build configuration
├── README.md
├── src/
│   └── package_name/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_main.py
```

Using a `src` directory prevents import errors during testing (importing from local folder instead of installed package).
