---
id: "c.thread-local"
title: "Thread-Local Storage"
category: language
difficulty: advanced
tags: [c, threads, tls, concurrency, storage-class]
keywords: [thread_local, _Thread_local, storage-class, errno]
use_cases: [thread safety, error handling, per-thread data]
prerequisites: []
related: []
next_topics: []
---

# Thread-Local Storage

Thread-local storage provides per-thread variables.

## C11 Thread-Local

```c
#include <threads.h>

// Each thread gets its own copy
_Thread_local int thread_counter = 0;

void thread_func(void* arg) {
    // Increments this thread's counter only
    thread_counter++;

    printf("Thread %d: counter = %d\n",
           *(int*)arg, thread_counter);
}
```

## GNU TLS Extension

```c
// GCC/Clang extension
__thread int g_counter = 0;

void thread_func() {
    g_counter++;  // Per-thread copy
    printf("Counter: %d\n", g_counter);
}
```

## TLS vs Global

```c
// Global variable (shared by all threads)
int global_var = 0;

// Thread-local variable (private per thread)
_Thread_local int tls_var = 0;

void thread_func(int id) {
    // All threads modify same variable
    global_var++;

    // Each thread has its own copy
    tls_var++;

    printf("Thread %d: global=%d, tls=%d\n",
           id, global_var, tls_var);
}

// Output:
// Thread 1: global=1, tls=1
// Thread 2: global=2, tls=1
// Thread 1: global=3, tls=2
// Thread 2: global=4, tls=2
```

## Thread-Safe Error Handling

```c
#include <errno.h>
#include <string.h>

void handle_error() {
    // errno is typically thread-local
    if (errno == EACCES) {
        perror("Permission denied");
    }
}

// Each thread can safely check errno
// without interfering with other threads
```

## Per-Thread Resources

```c
#include <stdio.h>

_Thread_local FILE* thread_log = NULL;

void init_thread_log(const char* filename) {
    if (thread_log == NULL) {
        thread_log = fopen(filename, "w");
    }
}

void log_message(const char* msg) {
    if (thread_log != NULL) {
        fprintf(thread_log, "%s\n", msg);
    }
}

void cleanup_thread_log() {
    if (thread_log != NULL) {
        fclose(thread_log);
        thread_log = NULL;
    }
}
```

## Thread-Local Buffers

```c
#include <string.h>

_Thread_local char buffer[1024];

void format_message(int id, const char* msg) {
    // Each thread has its own buffer
    snprintf(buffer, sizeof(buffer),
             "[Thread %d] %s", id, msg);

    // Safe to use without locks
    process_buffer(buffer);
}
```

## Initialization

```c
// Static initialization
_Thread_local int counter = 0;

// Dynamic initialization (requires function)
static int create_buffer() {
    return *malloc(1024);
}

// Note: _Thread_local cannot use non-constant initializers
// Use function pointers or lazy init:

_Thread_local void* tls_buffer = NULL;

void init_tls_buffer() {
    if (tls_buffer == NULL) {
        tls_buffer = malloc(1024);
    }
}
```

## Storage Classes Comparison

| Storage Class | Visibility | Lifetime | Thread Safety |
|---------------|-------------|-----------|---------------|
| `auto` | Block scope | Function call | Not applicable |
| `static` | File/Block scope | Entire program | ❌ Needs locks |
| `extern` | Global scope | Entire program | ❌ Needs locks |
| `thread_local` | Thread scope | Thread lifetime | ✅ Thread-safe |

## Performance Considerations

```c
// Thread-local may have overhead
void fast_function() {
    static int static_var = 0;      // Fast (cached)
    _Thread_local int tls_var = 0;  // Slower (TLS lookup)
    int auto_var = 0;               // Fastest (register/stack)

    // Use TLS only when needed
    tls_var++;
}
```

## Dynamic Thread-Local Keys

```c
#include <pthread.h>

pthread_key_t tls_key;

// Create key with destructor
void key_destructor(void* value) {
    printf("Cleaning up TLS value\n");
    free(value);
}

void init_tls() {
    pthread_key_create(&tls_key, key_destructor);
}

void set_tls(void* value) {
    pthread_setspecific(tls_key, value);
}

void* get_tls() {
    return pthread_getspecific(tls_key);
}

void cleanup_tls() {
    pthread_key_delete(tls_key);
}
```

## Use Cases

### Per-Thread Random Seed

```c
#include <stdlib.h>

_Thread_local unsigned int thread_seed = 0;

void init_random(int thread_id) {
    thread_seed = thread_id * 12345;
}

int thread_random() {
    return rand_r(&thread_seed);  // Thread-safe
}
```

### Thread-Specific Buffers

```c
_Thread_local char error_buffer[256];

char* get_thread_error(const char* msg) {
    strncpy(error_buffer, msg, sizeof(error_buffer) - 1);
    return error_buffer;  // Returns per-thread buffer
}
```

### Connection Pool Per Thread

```c
typedef struct {
    int socket;
    _Thread_local int current_socket;
} ConnectionPool;

int get_connection(ConnectionPool* pool) {
    if (pool->current_socket == 0) {
        pool->current_socket = connect_to_server();
    }
    return pool->current_socket;
}
```

## Limitations

```c
// 1. Cannot initialize dynamically
// _Thread_local int x = get_value();  // Error

// 2. Limited number of TLS slots
// Depends on platform (typically 100s-1000s)

// 3. May have performance overhead
// Access is slower than regular variables

// 4. Destruction timing
// TLS destructors called at thread exit
```

## Best Practices

```c
// ✅ Good: Use TLS for thread-specific state
_Thread_local FILE* log_file = NULL;

// ✅ Good: Thread-safe error handling
_Thread_local int last_error = 0;

// ✅ Good: Per-thread caches
_Thread_local int* cache = NULL;

// ❌ Bad: Using TLS when global works fine
// static int counter = 0;  // Use this instead if only one thread

// ❌ Bad: Excessive TLS usage
// Can cause performance degradation
```

> **Tip**: Use thread-local storage when each thread needs its own state to avoid lock contention.
