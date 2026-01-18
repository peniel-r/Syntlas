---
id: 81-shared-libraries
title: Shared Libraries
category: system
difficulty: advanced
tags:
  - shared-libraries
  - so
  - dll
  - dynamic-linking
keywords:
  - shared library
  - .so
  - .dll
  - dlopen
  - dlsym
  - dynamic linking
use_cases:
  - Plugin systems
  - Dynamic loading
  - Code sharing
  - Memory efficiency
prerequisites:
  - compilation
  - memory-management
  - pointers
related:
  - build-systems
  - file-operations
next_topics:
  - static-libraries
---

# Shared Libraries

Shared libraries allow code to be shared between multiple programs and loaded at runtime.

## Creating a Shared Library

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
# Compile with position-independent code (PIC)
gcc -fPIC -c mathlib.c -o mathlib.o

# Create shared library
gcc -shared -o libmathlib.so mathlib.o

# Or one command
gcc -fPIC -shared -o libmathlib.so mathlib.c

# Create versioned library
gcc -fPIC -shared -Wl,-soname,libmathlib.so.1 \
    -o libmathlib.so.1.0.0 mathlib.o
```

## Linking Against Shared Library

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
# Compile and link
gcc main.c -L. -lmathlib -o main

# Set library path for runtime
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
./main

# Or install library to system
sudo cp libmathlib.so /usr/local/lib/
sudo ldconfig
gcc main.c -lmathlib -o main
./main
```

## Library Versioning

```bash
# Create library with versioning
# Version scheme: major.minor.patch
# major: Incompatible API changes
# minor: Backward compatible additions
# patch: Backward compatible fixes

# Compile
gcc -fPIC -c mathlib.c -o mathlib.o

# Create shared library with version info
gcc -shared -Wl,-soname,libmathlib.so.1 \
    -o libmathlib.so.1.0.0 mathlib.o

# Create symlinks
ln -s libmathlib.so.1.0.0 libmathlib.so.1
ln -s libmathlib.so.1 libmathlib.so

# Linking uses unversioned name
gcc main.c -L. -lmathlib -o main

# Runtime uses specific version
LD_LIBRARY_PATH=. ./main
```

## Dynamic Loading (dlopen)

```c
// loader.c
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef int (*add_func)(int, int);
typedef int (*multiply_func)(int, int);

int main(void) {
    // Load library
    void *handle = dlopen("./libmathlib.so", RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "Error loading library: %s\n", dlerror());
        return 1;
    }

    // Get function pointers
    add_func add = (add_func)dlsym(handle, "add");
    multiply_func multiply = (multiply_func)dlsym(handle, "multiply");

    if (add == NULL || multiply == NULL) {
        fprintf(stderr, "Error finding functions: %s\n", dlerror());
        dlclose(handle);
        return 1;
    }

    // Use functions
    printf("5 + 3 = %d\n", add(5, 3));
    printf("4 * 7 = %d\n", multiply(4, 7));

    // Close library
    dlclose(handle);

    return 0;
}
```

```bash
# Compile dynamic loader
gcc loader.c -o loader -ldl

# Run
./loader
```

## Plugin System

```c
// plugin_interface.h
#ifndef PLUGIN_INTERFACE_H
#define PLUGIN_INTERFACE_H

typedef struct {
    const char *name;
    const char *version;
    int (*init)(void);
    void (*process)(void);
    void (*cleanup)(void);
} Plugin;

#endif
```

```c
// plugin_hello.c
#include "plugin_interface.h"
#include <stdio.h>

int plugin_init(void) {
    printf("Hello plugin initialized\n");
    return 0;
}

void plugin_process(void) {
    printf("Hello from plugin!\n");
}

void plugin_cleanup(void) {
    printf("Hello plugin cleaned up\n");
}

Plugin hello_plugin = {
    .name = "Hello",
    .version = "1.0",
    .init = plugin_init,
    .process = plugin_process,
    .cleanup = plugin_cleanup
};

// Export plugin symbol
Plugin *get_plugin(void) {
    return &hello_plugin;
}
```

```c
// loader_plugin.c
#include "plugin_interface.h"
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <dirent.h>

typedef Plugin *(*get_plugin_func)(void);

void load_plugin(const char *path) {
    void *handle = dlopen(path, RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "Failed to load %s: %s\n", path, dlerror());
        return;
    }

    get_plugin_func get_plugin = (get_plugin_func)dlsym(handle, "get_plugin");
    if (get_plugin == NULL) {
        fprintf(stderr, "No get_plugin in %s: %s\n", path, dlerror());
        dlclose(handle);
        return;
    }

    Plugin *plugin = get_plugin();

    printf("\nLoading plugin: %s v%s\n", plugin->name, plugin->version);

    if (plugin->init() == 0) {
        plugin->process();
        plugin->cleanup();
    }

    dlclose(handle);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <plugin.so>...\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        load_plugin(argv[i]);
    }

    return 0;
}
```

```bash
# Compile plugin
gcc -fPIC -shared plugin_hello.c -o plugin_hello.so

# Compile loader
gcc loader_plugin.c -o loader_plugin -ldl

# Run
./loader_plugin plugin_hello.so
```

## Library Path Configuration

```bash
# Temporary path (current session only)
export LD_LIBRARY_PATH=/path/to/library:$LD_LIBRARY_PATH

# Permanent configuration (system-wide)
sudo echo "/usr/local/lib" >> /etc/ld.so.conf
sudo ldconfig

# Per-user configuration
echo "/home/user/lib" >> /etc/ld.so.conf.d/user.conf
sudo ldconfig

# Check library paths
ldconfig -p | grep libname

# Show library dependencies
ldd ./program

# Show all linked libraries
ldd -v ./program
```

## Runpath vs Rpath

```bash
# RPATH - Fixed at link time
gcc main.c -L. -Wl,-rpath,. -lmathlib -o main

# RUNPATH - Can be overridden at runtime
gcc main.c -L. -Wl,-rpath,. -Wl,--enable-new-dtags -lmathlib -o main

# Multiple paths
gcc main.c -L. -Wl,-rpath,/path1:/path2 -lmathlib -o main

# Relative path (portable)
gcc main.c -L. -Wl,-rpath,$ORIGIN/../lib -lmathlib -o main

# Disable rpath
gcc main.c -Wl,--disable-new-dtags -lmathlib -o main
```

## Symbol Visibility

```c
// lib.c
#include <stdio.h>

// Default visibility (exported)
void public_function(void) {
    printf("Public function\n");
}

// Hidden symbol
void __attribute__((visibility("hidden"))) hidden_function(void) {
    printf("Hidden function\n");
}

// Default hidden, mark specific as visible
#pragma GCC visibility push(hidden)
void internal_function(void) {
    printf("Internal function\n");
}
#pragma GCC visibility pop

void __attribute__((visibility("default"))) exported_function(void) {
    printf("Exported function\n");
}
```

```bash
# Compile with visibility
gcc -fvisibility=hidden -fPIC -shared -o lib.so lib.c

# Check exported symbols
nm -D lib.so
nm -g lib.so
objdump -T lib.so
```

## Error Handling

```c
#include <dlfcn.h>
#include <stdio.h>

void safe_load_library(const char *path) {
    // Clear any existing errors
    dlerror();

    // Load library
    void *handle = dlopen(path, RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "dlopen error: %s\n", dlerror());
        return;
    }

    // Get symbol
    dlerror();  // Clear previous errors
    void *symbol = dlsym(handle, "function_name");
    if (symbol == NULL) {
        fprintf(stderr, "dlsym error: %s\n", dlerror());
        dlclose(handle);
        return;
    }

    // Use symbol...

    // Close library
    dlclose(handle);
}
```

## Library Initialization/Finalization

```c
// libinit.c
#include <stdio.h>

__attribute__((constructor))
void library_init(void) {
    printf("Library loaded automatically\n");
}

__attribute__((destructor))
void library_fini(void) {
    printf("Library unloaded automatically\n");
}

int exported_function(void) {
    printf("Function called\n");
    return 42;
}
```

```bash
# Compile and link
gcc -fPIC -shared -o libinit.so libinit.c

gcc main.c -L. -linit -o main
./main
# Output:
# Library loaded automatically
# Function called
# Library unloaded automatically
```

## Cross-Platform Compatibility

```c
// platform.h
#ifdef _WIN32
    #include <windows.h>
    #define LIB_HANDLE HINSTANCE
    #define LOAD_LIBRARY(path) LoadLibraryA(path)
    #define GET_SYMBOL(handle, name) GetProcAddress(handle, name)
    #define CLOSE_LIBRARY(handle) FreeLibrary(handle)
    #define DL_ERROR GetLastError()
#else
    #include <dlfcn.h>
    #define LIB_HANDLE void*
    #define LOAD_LIBRARY(path) dlopen(path, RTLD_LAZY)
    #define GET_SYMBOL(handle, name) dlsym(handle, name)
    #define CLOSE_LIBRARY(handle) dlclose(handle)
    #define DL_ERROR dlerror()
#endif
```

```c
// loader.c
#include "platform.h"
#include <stdio.h>

void load_library(const char *path) {
    LIB_HANDLE handle = LOAD_LIBRARY(path);
    if (handle == NULL) {
        fprintf(stderr, "Error loading library\n");
        return;
    }

    void *symbol = GET_SYMBOL(handle, "function_name");
    if (symbol == NULL) {
        fprintf(stderr, "Error finding symbol\n");
        CLOSE_LIBRARY(handle);
        return;
    }

    // Use symbol...

    CLOSE_LIBRARY(handle);
}
```

## Best Practices

### Use Symbol Versioning

```bash
# Maintain ABI compatibility
# Never change exported function signatures
# Add new functions instead
# Use symbol versioning for changes
```

### Control Symbol Visibility

```c
// Hide internal symbols by default
#pragma GCC visibility push(hidden)

// Only export needed symbols
#pragma GCC visibility pop

void __attribute__((visibility("default"))) exported_function(void) {
}
```

### Handle Errors Properly

```c
// Always check dlopen, dlsym return values
// Use dlerror() for error messages
// Clean up with dlclose()
```

## Common Pitfalls

### 1. Memory Allocation Issues

```c
// WRONG - Allocate in library, free in main
void *lib_alloc(void) {
    return malloc(100);  // Different heap
}
void main_free(void *ptr) {
    free(ptr);  // May crash!
}

// CORRECT - Free in same module
void lib_free(void *ptr) {
    free(ptr);
}
```

### 2. Global State Problems

```c
// WRONG - Global state shared unexpectedly
static int counter = 0;
void increment(void) {
    counter++;  // Shared across all users!
}

// CORRECT - Instance-based state
typedef struct {
    int counter;
} Counter;
Counter *counter_new(void) {
    return calloc(1, sizeof(Counter));
}
```

### 3. ABI Incompatibility

```c
// WRONG - Changing struct layout breaks ABI
// v1: struct { int a; int b; };
// v2: struct { int a; int c; int b; };

// CORRECT - Add fields at end
// v1: struct { int a; int b; };
// v2: struct { int a; int b; int c; };
```

> **Note: Shared libraries require careful ABI management. Use versioning to maintain compatibility. Test with different library versions. Be aware of memory allocation issues across module boundaries. Document clearly which functions are part of the stable API.
