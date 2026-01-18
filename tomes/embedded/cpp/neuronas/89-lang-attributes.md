---
id: "cpp.lang.attributes"
title: "Attributes"
category: language
difficulty: intermediate
tags: [cpp, attributes, modern]
keywords: [[nodiscard], [deprecated], [maybe_unused]]
use_cases: [compiler hints, warnings]
prerequisites: ["cpp.basics.functions"]
related: ["cpp.basics.functions"]
next_topics: []
---

# Attributes

Standardized syntax for compiler hints `[[...]]`.

## Examples

- `[[nodiscard]]`: Warn if return value is ignored.
- `[[deprecated]]`: Warn if used.
- `[[maybe_unused]]`: Suppress unused warning.
- `[[noreturn]]`: Function never returns (e.g., `exit`).

```cpp
[[nodiscard]] int get_error_code();
```
