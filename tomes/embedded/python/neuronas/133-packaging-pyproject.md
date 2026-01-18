---
id: "py.packaging.pyproject"
title: "pyproject.toml"
category: packaging
difficulty: intermediate
tags: [python, packaging, configuration, toml]
keywords: [pyproject.toml, build-system, metadata]
use_cases: [build configuration, tool config]
prerequisites: ["py.packaging.structure"]
related: ["py.packaging.structure"]
next_topics: []
---

# pyproject.toml

The standardized configuration file for build systems and tools (black, ruff, pytest).

## Build System

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

## Project Metadata

```toml
[project]
name = "my_package"
version = "0.1.0"
dependencies = [
    "requests",
]
```
