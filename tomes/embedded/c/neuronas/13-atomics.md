---
id: "c.atomics"
title: "Atomic Operations"
category: language
difficulty: advanced
tags: [c, concurrency, atomics, threads, memory-order]
keywords: [atomic, memory_order, fetch_add, compare_exchange, volatile]
use_cases: [lock-free programming, shared state, concurrent data structures]
prerequisites: []
related: []
next_topics: []
---

# Atomic Operations

C11 provides atomic operations for lock-free concurrent programming.

## stdatomic.h

```c
#include <stdatomic.h>
```

## Atomic Types

```c
#include <stdatomic.h>

atomic_int counter = ATOMIC_VAR_INIT(0);
atomic_flag lock = ATOMIC_FLAG_INIT;

// Atomic pointer
atomic_uintptr_t ptr;
```

## Atomic Operations

### Load and Store

```c
#include <stdatomic.h>

atomic_int value = 42;

// Load (atomic read)
int x = atomic_load(&value);

// Store (atomic write)
atomic_store(&value, 100);
```

### Fetch-Add/Subtract

```c
atomic_int counter = 0;

// Atomic add, returns previous value
int prev = atomic_fetch_add(&counter, 1);
// counter is now 1, prev is 0

// Atomic subtract
int prev2 = atomic_fetch_sub(&counter, 1);
// counter is now 0, prev2 is 1
```

### Compare and Exchange

```c
atomic_int value = 10;
int expected = 10;
int desired = 20;

// Atomic CAS loop
int success = atomic_compare_exchange_strong(
    &value, &expected, desired
);

if (success) {
    // value is now 20
    printf("CAS succeeded\n");
} else {
    // value unchanged, expected now has actual value
    printf("CAS failed, actual value: %d\n", expected);
}
```

### Exchange

```c
atomic_int value = 10;
int new_value = 20;

// Atomic swap, returns previous value
int old_value = atomic_exchange(&value, new_value);
// value is now 20, old_value is 10
```

## Memory Ordering

```c
#include <stdatomic.h>

atomic_int x = 0;
atomic_int y = 0;

// Relaxed: no synchronization guarantees
atomic_fetch_add_explicit(&x, 1, memory_order_relaxed);

// Acquire: all prior writes become visible
int val = atomic_load_explicit(&y, memory_order_acquire);

// Release: all prior writes become visible to others
atomic_store_explicit(&x, 42, memory_order_release);

// Acquire-Release: both acquire and release
atomic_fetch_add_explicit(&x, 1, memory_order_acq_rel);

// Sequentially consistent: total ordering
int val = atomic_load_explicit(&y, memory_order_seq_cst);
```

## Memory Ordering Hierarchy

| Order | Guarantees | Use Case |
|-------|-------------|----------|
| `memory_order_relaxed` | No ordering | Simple counters |
| `memory_order_consume` | Data dependency | Pointer chasing |
| `memory_order_acquire` | Acquire | Load flags |
| `memory_order_release` | Release | Store flags |
| `memory_order_acq_rel` | Both | Read-modify-write |
| `memory_order_seq_cst` | Total ordering | Synchronization primitives |

## Atomic Flag (Lock)

```c
#include <stdatomic.h>

atomic_flag lock = ATOMIC_FLAG_INIT;

// Try to acquire lock
while (atomic_flag_test_and_set(&lock, memory_order_acquire)) {
    // Spin until lock is free
}

// Critical section
printf("Locked section\n");

// Release lock
atomic_flag_clear(&lock, memory_order_release);
```

## Atomic Pointer

```c
struct Node {
    int data;
    struct Node* next;
};

atomic_ptr head = NULL;

// CAS for lock-free stack
struct Node* new_node = malloc(sizeof(struct Node));
new_node->data = 42;
new_node->next = NULL;

struct Node* expected = NULL;
if (atomic_compare_exchange_strong(
    &head, &expected, new_node,
    memory_order_release, memory_order_relaxed
)) {
    // Successfully added to stack
} else {
    // Race condition, retry
    free(new_node);
}
```

## Wait and Notify

```c
#include <stdatomic.h>

atomic_int ready = 0;

// Wait for value to change
while (atomic_load(&ready) == 0) {
    atomic_wait(&ready, 0);
}

// Notify waiting threads
atomic_notify_one(&ready);
atomic_notify_all(&ready);
```

## Common Patterns

### Atomic Counter

```c
#include <stdatomic.h>

atomic_int request_count = 0;

void handle_request() {
    // Thread-safe increment
    atomic_fetch_add(&request_count, 1);

    // Process request
    // ...
}

int get_total_requests() {
    return atomic_load(&request_count);
}
```

### Spin Lock with Backoff

```c
#include <stdatomic.h>

typedef struct {
    atomic_flag flag;
} spinlock_t;

void spinlock_init(spinlock_t* lock) {
    atomic_flag_clear(&lock->flag, memory_order_release);
}

void spinlock_lock(spinlock_t* lock) {
    int retries = 0;
    while (atomic_flag_test_and_set(
        &lock->flag,
        memory_order_acquire
    )) {
        // Exponential backoff
        for (int i = 0; i < (1 << retries); i++) {
            __asm__ volatile("pause");
        }
        if (retries < 10) retries++;
    }
}

void spinlock_unlock(spinlock_t* lock) {
    atomic_flag_clear(&lock->flag, memory_order_release);
}
```

### Double-Checked Locking

```c
#include <stdatomic.h>

typedef struct {
    atomic_intptr_t ptr;
} lazy_init_t;

void* get_or_init(lazy_init_t* lazy) {
    // First check (atomic load)
    void* ptr = (void*)atomic_load(&lazy->ptr);
    if (ptr != NULL) return ptr;

    // Initialize (with proper lock)
    spinlock_lock(&global_lock);

    // Double-check
    ptr = (void*)atomic_load(&lazy->ptr);
    if (ptr == NULL) {
        ptr = allocate_and_init();
        atomic_store(&lazy->ptr, (intptr_t)ptr);
    }

    spinlock_unlock(&global_lock);
    return ptr;
}
```

> **Warning**: Atomic operations are difficult to use correctly. Prefer using higher-level synchronization primitives when possible.
