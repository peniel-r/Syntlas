---
id: 83-dynamic-loading
title: Dynamic Loading
category: system
difficulty: advanced
tags:
  - dlopen
  - dlsym
  - plugins
  - dynamic-linking
keywords:
  - dynamic loading
  - dlopen
  - dlsym
  - dlclose
  - dlerror
  - plugins
use_cases:
  - Plugin systems
  - Runtime loading
  - Extensible applications
  - Hot swapping
prerequisites:
  - pointers
  - functions
  - shared-libraries
related:
  - shared-libraries
  - callbacks
next_topics:
  - inter-process-communication
---

# Dynamic Loading

Dynamic loading allows programs to load libraries at runtime rather than at link time.

## Basic Dynamic Loading

```c
#include <stdio.h>
#include <dlfcn.h>

int main(void) {
    // Load library
    void *handle = dlopen("./libmylib.so", RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "Error: %s\n", dlerror());
        return 1;
    }

    // Clear any existing error
    dlerror();

    // Get function pointer
    int (*my_func)(int) = dlsym(handle, "my_function");
    char *error = dlerror();
    if (error != NULL) {
        fprintf(stderr, "Error: %s\n", error);
        dlclose(handle);
        return 1;
    }

    // Call function
    int result = my_func(42);
    printf("Result: %d\n", result);

    // Close library
    dlclose(handle);

    return 0;
}
```

## Loading Flags

```c
// RTLD_LAZY - Perform lazy binding (default)
void *handle = dlopen("./lib.so", RTLD_LAZY);

// RTLD_NOW - Resolve all symbols immediately
void *handle = dlopen("./lib.so", RTLD_NOW);

// RTLD_GLOBAL - Make symbols available globally
void *handle = dlopen("./lib.so", RTLD_GLOBAL);

// RTLD_LOCAL - Symbols not available to other libraries
void *handle = dlopen("./lib.so", RTLD_LOCAL);

// RTLD_NODELETE - Don't unload on dlclose
void *handle = dlopen("./lib.so", RTLD_NODELETE);

// RTLD_NOLOAD - Don't load, just check if loaded
void *handle = dlopen("./lib.so", RTLD_NOLOAD);

// Combined flags
void *handle = dlopen("./lib.so", RTLD_NOW | RTLD_GLOBAL);
```

## Error Handling

```c
#include <dlfcn.h>
#include <stdio.h>

void *safe_dlopen(const char *filename, int flags) {
    dlerror();  // Clear previous error

    void *handle = dlopen(filename, flags);
    if (handle == NULL) {
        fprintf(stderr, "dlopen(%s) failed: %s\n", filename, dlerror());
        return NULL;
    }

    return handle;
}

void *safe_dlsym(void *handle, const char *symbol) {
    dlerror();  // Clear previous error

    void *func = dlsym(handle, symbol);
    if (func == NULL) {
        fprintf(stderr, "dlsym(%s) failed: %s\n", symbol, dlerror());
        return NULL;
    }

    return func;
}

int main(void) {
    void *handle = safe_dlopen("./lib.so", RTLD_LAZY);
    if (handle == NULL) {
        return 1;
    }

    int (*func)(int) = safe_dlsym(handle, "my_func");
    if (func == NULL) {
        dlclose(handle);
        return 1;
    }

    int result = func(42);
    printf("Result: %d\n", result);

    dlclose(handle);
    return 0;
}
```

## Plugin System

```c
// plugin.h
#ifndef PLUGIN_H
#define PLUGIN_H

typedef struct {
    const char *name;
    const char *version;
    int (*initialize)(void);
    void (*process)(void);
    void (*shutdown)(void);
} Plugin;

// Each plugin must implement this
Plugin *get_plugin(void);

#endif
```

```c
// plugin_hello.c
#include "plugin.h"
#include <stdio.h>

static int hello_initialize(void) {
    printf("Hello plugin initialized\n");
    return 0;
}

static void hello_process(void) {
    printf("Hello from plugin!\n");
}

static void hello_shutdown(void) {
    printf("Hello plugin shut down\n");
}

static Plugin hello_plugin = {
    .name = "Hello",
    .version = "1.0",
    .initialize = hello_initialize,
    .process = hello_process,
    .shutdown = hello_shutdown
};

Plugin *get_plugin(void) {
    return &hello_plugin;
}
```

```c
// plugin_manager.c
#include "plugin.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_PLUGINS 10

typedef struct {
    void *handle;
    Plugin *plugin;
} LoadedPlugin;

static LoadedPlugin plugins[MAX_PLUGINS];
static int plugin_count = 0;

int load_plugin(const char *path) {
    if (plugin_count >= MAX_PLUGINS) {
        fprintf(stderr, "Maximum plugins loaded\n");
        return -1;
    }

    void *handle = dlopen(path, RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "Failed to load %s: %s\n", path, dlerror());
        return -1;
    }

    Plugin *(*get_plugin_func)(void) = dlsym(handle, "get_plugin");
    if (get_plugin_func == NULL) {
        fprintf(stderr, "No get_plugin in %s: %s\n", path, dlerror());
        dlclose(handle);
        return -1;
    }

    Plugin *plugin = get_plugin_func();
    if (plugin == NULL) {
        fprintf(stderr, "get_plugin returned NULL\n");
        dlclose(handle);
        return -1;
    }

    // Initialize plugin
    if (plugin->initialize != NULL) {
        if (plugin->initialize() != 0) {
            fprintf(stderr, "Plugin initialization failed\n");
            dlclose(handle);
            return -1;
        }
    }

    plugins[plugin_count].handle = handle;
    plugins[plugin_count].plugin = plugin;
    plugin_count++;

    printf("Loaded plugin: %s v%s\n", plugin->name, plugin->version);
    return 0;
}

void run_plugins(void) {
    for (int i = 0; i < plugin_count; i++) {
        if (plugins[i].plugin->process != NULL) {
            plugins[i].plugin->process();
        }
    }
}

void unload_plugins(void) {
    for (int i = 0; i < plugin_count; i++) {
        if (plugins[i].plugin->shutdown != NULL) {
            plugins[i].plugin->shutdown();
        }
        if (plugins[i].handle != NULL) {
            dlclose(plugins[i].handle);
        }
    }
    plugin_count = 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <plugin.so>...\n", argv[0]);
        return 1;
    }

    // Load all plugins
    for (int i = 1; i < argc; i++) {
        load_plugin(argv[i]);
    }

    // Run all plugins
    run_plugins();

    // Cleanup
    unload_plugins();

    return 0;
}
```

```bash
# Compile plugin
gcc -fPIC -shared plugin_hello.c -o plugin_hello.so

# Compile manager
gcc plugin_manager.c -o plugin_manager -ldl

# Run
./plugin_manager plugin_hello.so
```

## Runtime Symbol Lookup

```c
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

// Lookup table for dynamic symbols
typedef struct {
    const char *name;
    void **pointer;
} SymbolLookup;

// Load multiple symbols at once
int load_symbols(void *handle, SymbolLookup *symbols, int count) {
    for (int i = 0; i < count; i++) {
        dlerror();
        *symbols[i].pointer = dlsym(handle, symbols[i].name);

        char *error = dlerror();
        if (error != NULL) {
            fprintf(stderr, "Failed to find %s: %s\n",
                    symbols[i].name, error);
            return 0;
        }
    }
    return 1;
}

int main(void) {
    // Define symbols to load
    int (*func1)(int);
    int (*func2)(int, int);
    void (*func3)(void);

    SymbolLookup symbols[] = {
        {"function1", (void **)&func1},
        {"function2", (void **)&func2},
        {"function3", (void **)&func3}
    };

    void *handle = dlopen("./lib.so", RTLD_LAZY);
    if (handle == NULL) {
        fprintf(stderr, "Error: %s\n", dlerror());
        return 1;
    }

    // Load all symbols
    if (!load_symbols(handle, symbols, 3)) {
        dlclose(handle);
        return 1;
    }

    // Use loaded functions
    func1(42);
    func2(5, 3);
    func3();

    dlclose(handle);
    return 0;
}
```

## Hot Reloading

```c
#include <dlfcn.h>
#include <stdio.h>
#include <time.h>

typedef void (*update_func)(float delta);

void *load_module(const char *path) {
    return dlopen(path, RTLD_LAZY);
}

void reload_module(void **handle, const char *path, update_func *update) {
    // Close old module
    if (*handle != NULL) {
        dlclose(*handle);
    }

    // Load new module
    *handle = dlopen(path, RTLD_LAZY);
    if (*handle == NULL) {
        fprintf(stderr, "Error: %s\n", dlerror());
        return;
    }

    // Get function pointer
    *update = (update_func)dlsym(*handle, "update");
    if (*update == NULL) {
        fprintf(stderr, "Error: %s\n", dlerror());
        dlclose(*handle);
        *handle = NULL;
    }
}

int main(void) {
    void *handle = NULL;
    update_func update = NULL;

    time_t last_reload = 0;
    const char *module_path = "./module.so";

    while (1) {
        // Check for file modification (simplified)
        time_t now = time(NULL);
        if (now - last_reload > 5) {  // Reload every 5 seconds
            printf("Reloading module...\n");
            reload_module(&handle, module_path, &update);
            last_reload = now;
        }

        // Call update if available
        if (update != NULL) {
            update(0.016f);  // 60 FPS
        }

        // Sleep
        usleep(16000);
    }

    if (handle != NULL) {
        dlclose(handle);
    }

    return 0;
}
```

## Cross-Platform Dynamic Loading

```c
// dlopen_portable.h
#ifndef DLOPEN_PORTABLE_H
#define DLOPEN_PORTABLE_H

#ifdef _WIN32
    #include <windows.h>
    typedef HMODULE lib_handle_t;
    #define LIB_LOAD(path) LoadLibraryA(path)
    #define LIB_SYM(handle, name) GetProcAddress(handle, name)
    #define LIB_CLOSE(handle) FreeLibrary(handle)
    #define LIB_ERROR() GetLastError()
#else
    #include <dlfcn.h>
    typedef void *lib_handle_t;
    #define LIB_LOAD(path) dlopen(path, RTLD_LAZY)
    #define LIB_SYM(handle, name) dlsym(handle, name)
    #define LIB_CLOSE(handle) dlclose(handle)
    #define LIB_ERROR() dlerror()
#endif

#endif
```

```c
// main.c
#include "dlopen_portable.h"
#include <stdio.h>

int main(void) {
    lib_handle_t handle = LIB_LOAD("./lib.so");
    if (handle == NULL) {
        fprintf(stderr, "Error loading library\n");
        return 1;
    }

    void *func = LIB_SYM(handle, "my_function");
    if (func == NULL) {
        fprintf(stderr, "Error finding symbol\n");
        LIB_CLOSE(handle);
        return 1;
    }

    // Use function...

    LIB_CLOSE(handle);
    return 0;
}
```

## Symbol Visibility Control

```c
// lib.c
#include <stdio.h>

// Default visible
void public_function(void) {
    printf("Public\n");
}

// Hidden from dynamic loader
void __attribute__((visibility("hidden"))) private_function(void) {
    printf("Private\n");
}

// Only export specific symbols
#pragma GCC visibility push(hidden)
void internal_function(void) {
    printf("Internal\n");
}
#pragma GCC visibility pop

void __attribute__((visibility("default"))) exported_function(void) {
    printf("Exported\n");
}
```

```bash
# Compile with visibility
gcc -fvisibility=hidden -fPIC -shared -o lib.so lib.c

# Check exported symbols
nm -D lib.so
```

## Best Practices

### Always Check Return Values

```c
// GOOD - Check all operations
void *handle = dlopen(path, RTLD_LAZY);
if (handle == NULL) {
    // Handle error
}

void *func = dlsym(handle, name);
if (func == NULL) {
    // Handle error
    dlclose(handle);
}
```

### Use Type-Safe Function Pointers

```c
// GOOD - Use proper function types
typedef int (*calculate_func)(int, int);
calculate_func calc = (calculate_func)dlsym(handle, "calculate");

// BAD - Use void*
void *func = dlsym(handle, "calculate");
((int (*)(int, int))func)(5, 3);  // Error-prone
```

### Clean Up Resources

```c
// GOOD - Always close handles
void *handle = dlopen(path, RTLD_LAZY);
if (handle != NULL) {
    // Use library...
    dlclose(handle);
}

// BAD - Memory leak
void *handle = dlopen(path, RTLD_LAZY);
// Use library...
// Forgot to close!
```

## Common Pitfalls

### 1. Memory Allocation Across Modules

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

### 2. Symbol Naming Collisions

```c
// WRONG - Generic names cause conflicts
void init(void);
void cleanup(void);

// CORRECT - Use namespaced names
void mylib_init(void);
void mylib_cleanup(void);
```

### 3. Missing Constructor/Destructor

```c
// WRONG - No initialization
int global_var = 0;  // Uninitialized

// CORRECT - Use constructor
__attribute__((constructor))
static void library_init(void) {
    global_var = 42;
}
```

> **Note: Dynamic loading is powerful but complex. Always handle errors properly. Be aware of cross-module issues like memory allocation and global state. Document clearly which symbols are part of the public API. Use symbol visibility to hide internal implementation details.
