---
# TIER 1: ESSENTIAL
id: "cpp.basic.namespaces"
title: "Namespaces"
tags: [cpp, namespaces, organization, beginner]
links: ["cpp.basic.variables", "cpp.basic.functions"]
hash: "sha256:0000000000000000000000000000000000000000000000000000000000"

# TIER 2: STANDARD
category: syntax
difficulty: beginner
keywords: [namespace, using, scope, organization]
prerequisites: ["cpp.basic.variables"]
next: ["cpp.oo.classes", "cpp.modern.modules"]
related:
  - id: "cpp.modern.modules"
    type: complement
    weight: 80
version:
  minimum: "C++11"
  recommended: "C++20"
platforms: [linux, macos, windows]
updated: "2026-01-18"
---

# Namespaces

Namespaces organize code and prevent name collisions.

## Basic Namespace

```cpp
namespace MyNamespace {
    int value = 42;
    
    void print() {
        std::cout << value << std::endl;
    }
}

// Using namespace
MyNamespace::print();  // Call with scope
```

## Using Directive

```cpp
// Bring all names into scope
using namespace std;

cout << "Hello" << endl;  // No std:: prefix needed
```

## Using Declaration

```cpp
// Bring specific name into scope
using std::cout;
using std::endl;

cout << "Hello" << endl;
```

## Nested Namespaces

```cpp
namespace Outer {
    namespace Inner {
        int value = 10;
    }
}

Outer::Inner::value = 20;
```

## Namespace Alias (C++11)

```cpp
namespace ShortName = VeryLongNamespaceName;

ShortName::function();
```

## Anonymous Namespace

```cpp
namespace {
    int internalValue = 42;  // Only visible in this translation unit
}
```

## See Also

- [Modules](cpp.modern.modules) - Modern alternative (C++20)
- [Classes](cpp.oo.classes) - Code organization
