---
id: 82-static-libraries
title: Static Libraries
category: system
difficulty: intermediate
tags:
  - static-libraries
  - ar
  - linking
  - archive
keywords:
  - static library
  - .a
  - ar
  - static linking
  - archive
use_cases:
  - Embedded systems
  - Standalone executables
  - Code distribution
  - Performance
prerequisites:
  - compilation
  - build-systems
related:
  - shared-libraries
  - build-systems
next_topics:
  - dynamic-loading
---

# Static Libraries

Static libraries are compiled into the executable at link time, creating standalone binaries.

## Creating a Static Library

```c
// mathlib.h
#ifndef MATHLIB_H
#define MATHLIB_H

int add(int a, int b);
int multiply(int a, int b);
int factorial(int n);

#endif
```

```c
// mathlib.c
#include "mathlib.h"

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int factorial(int n) {
    if (n < 0) return -1;
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
}
```

```bash
# Compile object files
gcc -c mathlib.c -o mathlib.o

# Create static library
ar rcs libmathlib.a mathlib.o

# Or combine multiple object files
gcc -c mathlib.c -o mathlib.o
gcc -c utils.c -o utils.o
ar rcs libmylib.a mathlib.o utils.o

# View library contents
ar t libmathlib.a
```

## Linking Against Static Library

```c
// main.c
#include <stdio.h>
#include "mathlib.h"

int main(void) {
    printf("5 + 3 = %d\n", add(5, 3));
    printf("4 * 7 = %d\n", multiply(4, 7));
    printf("5! = %d\n", factorial(5));

    return 0;
}
```

```bash
# Link with static library
gcc main.c -L. -lmathlib -o main
gcc main.c libmathlib.a -o main

# Link with full path
gcc main.c /path/to/libmathlib.a -o main

# Force static linking
gcc -static main.c -lmathlib -o main

# Check linked libraries
ldd ./main  # Shows "not a dynamic executable"
```

## Library Maintenance

```bash
# Add object file to library
ar r libmylib.a newfile.o

# Replace object file
ar r libmylib.a oldfile.o

# Delete object file
ar d libmylib.a file.o

# Extract object file
ar x libmylib.a file.o

# Update existing object file
ar u libmylib.a file.o

# Create library index
ranlib libmylib.a
# or
ar s libmylib.a

# Display verbose information
ar tv libmylib.a
```

## Complete Build Process

```makefile
# Makefile for static library
CC = gcc
CFLAGS = -Wall -Wextra -std=c11
AR = ar
RANLIB = ranlib

# Library name
LIB_NAME = mylib
LIB_STATIC = lib$(LIB_NAME).a

# Sources and objects
SRCS = mathlib.c utils.c
OBJS = $(SRCS:.c=.o)

# Targets
.PHONY: all clean install

all: $(LIB_STATIC)

# Create static library
$(LIB_STATIC): $(OBJS)
	$(AR) rcs $@ $^
	$(RANLIB) $@

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(OBJS) $(LIB_STATIC)

# Install
install: $(LIB_STATIC)
	install -d /usr/local/lib
	install -m 644 $(LIB_STATIC) /usr/local/lib/
```

## Static vs Shared Libraries

```bash
# Static library (.a)
gcc -c lib.c -o lib.o
ar rcs lib.a lib.o
gcc main.c lib.a -o static_main
# Pros: No runtime dependencies, slightly faster
# Cons: Larger executables, no updates without recompile

# Shared library (.so)
gcc -fPIC -c lib.c -o lib.o
gcc -shared -o lib.so lib.o
gcc main.c -L. -l -o shared_main
# Pros: Smaller executables, easier updates
# Cons: Runtime dependencies, slight performance overhead
```

## Combining Static and Dynamic

```c
// main.c
#include <stdio.h>
#include "mathlib.h"

// Use static library
extern int add(int a, int b);

// Use shared library functions
extern int multiply(int a, int b);

int main(void) {
    printf("Static add: %d\n", add(5, 3));
    printf("Shared multiply: %d\n", multiply(4, 7));

    return 0;
}
```

```bash
# Compile static libmathlib.a
ar rcs libmathlib.a mathlib.o

# Compile shared libutils.so
gcc -fPIC -shared -o libutils.so utils.o

# Link with both
gcc main.c libmathlib.a -L. -lutils -o main

# Check
ldd ./main
# Shows libutils.so linked dynamically
# libmathlib.a linked statically
```

## Symbol Resolution

```c
// lib1.c
int common_func(void) {
    return 1;
}

int lib1_func(void) {
    return common_func();
}
```

```c
// lib2.c
int common_func(void) {
    return 2;
}

int lib2_func(void) {
    return common_func();
}
```

```bash
# Create libraries
ar rcs lib1.a lib1.o
ar rcs lib2.a lib2.o

# Link order matters!
gcc main.c -L. -l1 -l2 -o main
gcc main.c -L. -l2 -l1 -o main2

# Results may differ depending on link order
```

## Static Library Optimization

```bash
# Enable link-time optimization (LTO)
gcc -c -flto lib.c -o lib.o
ar rcs lib.a lib.o
gcc -flto main.c lib.a -o main

# Strip symbols to reduce size
gcc -s main.c lib.a -o main
strip main

# Optimize for size
gcc -Os -c lib.c -o lib.o
ar rcs lib.a lib.o

# Check symbol table
nm lib.a
nm --size-sort lib.a
```

## Dependency Management

```makefile
# Complex makefile with dependencies
CC = gcc
CFLAGS = -Wall -Wextra -std=c11

# Library 1
LIB1_SRCS = lib1.c
LIB1_OBJS = $(LIB1_SRCS:.c=.o)
LIB1_STATIC = lib1.a

# Library 2 (depends on lib1)
LIB2_SRCS = lib2.c
LIB2_OBJS = $(LIB2_SRCS:.c=.o)
LIB2_STATIC = lib2.a

# Main (depends on both)
MAIN_SRCS = main.c
MAIN_OBJS = $(MAIN_SRCS:.c=.o)
MAIN = main

.PHONY: all clean

all: $(MAIN)

$(MAIN): $(MAIN_OBJS) $(LIB2_STATIC) $(LIB1_STATIC)
	$(CC) $(CFLAGS) -o $@ $^

$(LIB2_STATIC): $(LIB2_OBJS)
	ar rcs $@ $^

$(LIB1_STATIC): $(LIB1_OBJS)
	ar rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(MAIN_OBJS) $(LIB1_OBJS) $(LIB2_OBJS)
	rm -f $(LIB1_STATIC) $(LIB2_STATIC) $(MAIN)
```

## Cross-Platform Static Libraries

```c
// platform.h
#ifdef _WIN32
    #include <windows.h>
    #define LIB_HANDLE HMODULE
#else
    #include <dlfcn.h>
    #define LIB_HANDLE void*
#endif

// Static functions available always
int static_function(void);

// Dynamic functions require loading
int dynamic_function(void);
```

## Static Library Versioning

```bash
# Version the library
VERSION = 1.0.0
LIB_NAME = mylib

# Create versioned archive
ar rcs lib$(LIB_NAME)_$(VERSION).a lib.o

# Create symlink
ln -s lib$(LIB_NAME)_$(VERSION).a lib$(LIB_NAME).a

# Or use make variable
LIB_STATIC = lib$(LIB_NAME)_$(VERSION).a
```

## Examining Static Libraries

```bash
# List contents
ar t lib.a

# List with details
ar tv lib.a

# Show object file details
nm lib.a
nm -C lib.a  # Demangle C++ names
nm -S lib.a  # Show sizes

# Extract object file
ar x lib.a file.o

# Read object file
objdump -t lib.a
objdump -d lib.a

# Check library compatibility
file lib.a

# Show archive format
ar --version
```

## Static Library Distribution

```bash
# Create distribution package
VERSION=1.0.0
DIST_DIR=dist-$(VERSION)

mkdir -p $(DIST_DIR)/include
mkdir -p $(DIST_DIR)/lib
mkdir -p $(DIST_DIR)/doc

cp *.h $(DIST_DIR)/include/
cp lib*.a $(DIST_DIR)/lib/
cp README.md $(DIST_DIR)/doc/

# Create tarball
tar czf mylib-$(VERSION).tar.gz $(DIST_DIR)

# Install from tarball
tar xzf mylib-$(VERSION).tar.gz
cd dist-$(VERSION)
sudo cp include/* /usr/local/include/
sudo cp lib/* /usr/local/lib/
```

## Best Practices

### Organize Library Structure

```bash
# Recommended directory layout
mylib/
├── include/
│   └── mylib.h
├── src/
│   ├── core.c
│   └── utils.c
├── lib/
│   └── libmylib.a
├── examples/
│   └── example.c
├── tests/
│   └── test.c
└── Makefile
```

### Use Appropriate Link Order

```bash
# Libraries depend on each other - order matters
gcc main.c liba.a libb.a libc.a -o main
# libc.a depends on libb.a depends on liba.a
```

### Document Public API

```c
// mylib.h - Public API
#ifndef MYLIB_H
#define MYLIB_H

// Public functions
int mylib_init(void);
void mylib_cleanup(void);

// Public structures
typedef struct {
    int value;
} MylibObject;

// Public constants
#define MYLIB_MAX_SIZE 100

#endif

// Internal functions in .c files only
static int internal_helper(void) {
}
```

## Common Pitfalls

### 1. Missing Dependencies

```bash
# WRONG - Library dependencies not included
gcc main.c liba.a -o main
# Fails at link time if liba depends on libb

# CORRECT - Include all dependencies
gcc main.c liba.a libb.a -o main
```

### 2. Circular Dependencies

```c
// liba.c uses libb functions
extern int libb_func(void);

// libb.c uses liba functions
extern int liba_func(void);

// WRONG - Can't resolve circular dependency
ar rcs liba.a liba.o
ar rcs libb.a libb.o
gcc main.c liba.a libb.a -o main  # Link errors!

// CORRECT - Extract and relink
ar x liba.a liba.o
ar x libb.a libb.o
gcc main.c liba.o libb.o -o main
```

### 3. Mixed Static/Shared Issues

```bash
# WRONG - Conflicting symbols
gcc -static-libgcc main.c lib.a -o main

# CORRECT - Be explicit about linking
gcc main.c lib.a -Wl,-Bstatic -lprivate -Wl,-Bdynamic -lsystem -o main
```

> **Note: Static libraries create standalone executables with no runtime dependencies. They're ideal for embedded systems and distribution. However, they result in larger binaries and require recompilation for updates. Consider using shared libraries for code that may need updates.
