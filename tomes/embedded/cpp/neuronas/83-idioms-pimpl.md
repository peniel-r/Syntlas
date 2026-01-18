---
id: "cpp.idioms.pimpl"
title: "Pimpl Idiom"
category: patterns
difficulty: advanced
tags: [cpp, patterns, pimpl, compilation]
keywords: [pointer to implementation, compilation firewall]
use_cases: [reducing build times, abi stability, encapsulation]
prerequisites: ["cpp.memory.smart-pointers"]
related: ["cpp.oo.classes"]
next_topics: []
---

# Pimpl Idiom

**P**ointer to **Impl**ementation. Moves private members to a separate class/struct defined in the `.cpp` file.

## Header (`widget.h`)

```cpp
#include <memory>

class Widget {
public:
    Widget();
    ~Widget();
    void draw();
private:
    struct Impl;
    std::unique_ptr<Impl> pImpl;
};
```

## Implementation (`widget.cpp`)

```cpp
#include "widget.h"

struct Widget::Impl {
    void draw_internal() {}
};

Widget::Widget() : pImpl(std::make_unique<Impl>()) {}
Widget::~Widget() = default; // Must be in cpp
void Widget::draw() { pImpl->draw_internal(); }
```
