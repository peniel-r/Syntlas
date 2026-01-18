---
id: 86-atomics
title: Atomic Operations
category: system
difficulty: advanced
tags:
  - atomics
  - lock-free
  - c11
  - memory-order
keywords:
  - atomic
  - lock-free
  - c11
  - memory-order
  - atomic operations
use_cases:
  - Lock-free programming
  - High-performance synchronization
  - Simple counters
  - Flags
prerequisites:
  - pointers
  - memory-management
related:
  - synchronization
  - threads
next_topics:
  - signal-handling
---

# Atomic Operations

Atomic operations provide lock-free synchronization for simple operations.

## Basic Atomic Types (C11)

```c
#include <stdio.h>
#include <stdatomic.h>
#include <pthread.h>

atomic_int counter = ATOMIC_VAR_INIT(0);

void *increment(void *arg) {
    for (int i = 0; i < 100000; i++) {
        // Atomic increment
        atomic_fetch_add(&counter, 1);
    }
    return NULL;
}

int main(void) {
    pthread_t thread1, thread2;

    pthread_create(&thread1, NULL, increment, NULL);
    pthread_create(&thread2, NULL, increment, NULL);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Final counter: %d\n", atomic_load(&counter));
    // Should be 200000

    return 0;
}
```

## Atomic Load and Store

```c
#include <stdatomic.h>

atomic_int value = ATOMIC_VAR_INIT(0);

// Atomic load (read)
int current = atomic_load(&value);

// Atomic store (write)
atomic_store(&value, 42);

// Explicit memory ordering
int current_explicit = atomic_load_explicit(&value, memory_order_seq_cst);
atomic_store_explicit(&value, 42, memory_order_seq_cst);
```

## Compare and Swap (CAS)

```c
#include <stdio.h>
#include <stdatomic.h>

atomic_int shared_value = ATOMIC_VAR_INIT(0);

int compare_and_swap(int expected, int desired) {
    int current = atomic_load(&shared_value);

    if (current == expected) {
        atomic_store(&shared_value, desired);
        return 1;  // Success
    }

    return 0;  // Failed
}

// Using built-in CAS
int cas_operation(int expected, int desired) {
    return atomic_compare_exchange_strong(&shared_value, &expected, desired);
}

int main(void) {
    int expected = 0;
    int desired = 42;

    if (atomic_compare_exchange_strong(&shared_value, &expected, desired)) {
        printf("CAS succeeded! Value is now %d\n", atomic_load(&shared_value));
    } else {
        printf("CAS failed! Expected %d, got %d\n", expected, desired);
    }

    return 0;
}
```

## Atomic Add and Subtract

```c
#include <stdatomic.h>

atomic_int counter = ATOMIC_VAR_INIT(0);

// Atomic add
atomic_fetch_add(&counter, 5);    // Returns old value
int old = atomic_fetch_add(&counter, 5);

// Atomic subtract
atomic_fetch_sub(&counter, 3);    // Returns old value

// Return new value versions
int new_val = atomic_add_fetch(&counter, 5);    // Returns new value
new_val = atomic_sub_fetch(&counter, 3);      // Returns new value
```

## Lock-Free Stack

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdatomic.h>

typedef struct Node {
    int data;
    struct Node *next;
} Node;

typedef struct {
    atomic_ptr_t head;
} LockFreeStack;

void stack_init(LockFreeStack *stack) {
    atomic_init(&stack->head, NULL);
}

void stack_push(LockFreeStack *stack, int data) {
    Node *new_node = malloc(sizeof(Node));
    new_node->data = data;

    Node *old_head;
    do {
        old_head = atomic_load(&stack->head);
        new_node->next = old_head;
    } while (!atomic_compare_exchange_strong(&stack->head, &old_head, new_node));
}

int stack_pop(LockFreeStack *stack, int *value) {
    Node *old_head, *new_head;

    do {
        old_head = atomic_load(&stack->head);
        if (old_head == NULL) {
            return 0;  // Stack empty
        }
        new_head = old_head->next;
    } while (!atomic_compare_exchange_strong(&stack->head, &old_head, new_head));

    *value = old_head->data;
    free(old_head);
    return 1;  // Success
}

int main(void) {
    LockFreeStack stack;
    stack_init(&stack);

    stack_push(&stack, 10);
    stack_push(&stack, 20);
    stack_push(&stack, 30);

    int value;
    while (stack_pop(&stack, &value)) {
        printf("Popped: %d\n", value);
    }

    return 0;
}
```

## Spin Lock with Atomics

```c
#include <stdatomic.h>
#include <pthread.h>

typedef struct {
    atomic_flag lock;
} SpinLock;

void spinlock_init(SpinLock *lock) {
    atomic_flag_clear(&lock->lock);
}

void spinlock_lock(SpinLock *lock) {
    // Spin until we can acquire the lock
    while (atomic_flag_test_and_set(&lock->lock, memory_order_acquire)) {
        // Optionally add a small pause to reduce contention
        __asm__ volatile("pause" ::: "memory");
    }
}

void spinlock_unlock(SpinLock *lock) {
    atomic_flag_clear(&lock->lock, memory_order_release);
}

// Usage example
SpinLock lock;
spinlock_init(&lock);

spinlock_lock(&lock);
// Critical section
spinlock_unlock(&lock);
```

## Atomic Flags

```c
#include <stdatomic.h>

atomic_flag flag = ATOMIC_FLAG_INIT;

// Set flag
while (atomic_flag_test_and_set(&flag)) {
    // Wait until flag is cleared
}

// Clear flag
atomic_flag_clear(&flag);

// With explicit memory ordering
atomic_flag_test_and_set_explicit(&flag, memory_order_acquire);
atomic_flag_clear_explicit(&flag, memory_order_release);
```

## Memory Ordering

```c
#include <stdatomic.h>

atomic_int x = ATOMIC_VAR_INIT(0);
atomic_int y = ATOMIC_VAR_INIT(0);

// Relaxed - No synchronization
atomic_store_explicit(&x, 1, memory_order_relaxed);

// Acquire/Release - Pair for synchronization
atomic_thread_fence(memory_order_release);
atomic_store_explicit(&x, 1, memory_order_relaxed);

// In another thread
int value = atomic_load_explicit(&x, memory_order_acquire);

// Sequentially consistent (default, strongest)
atomic_store(&x, 1);
int value = atomic_load(&x);  // memory_order_seq_cst
```

## Atomic Pointer

```c
#include <stdatomic.h>

int data = 42;
atomic_ptr_t atomic_ptr;

// Initialize
atomic_init(&atomic_ptr, &data);

// Load
int *ptr = atomic_load(&atomic_ptr);

// Store
int new_data = 100;
atomic_store(&atomic_ptr, &new_data);

// Compare and swap
int *expected = &data;
int *desired = &new_data;
if (atomic_compare_exchange_strong(&atomic_ptr, &expected, desired)) {
    printf("CAS succeeded\n");
}
```

## Lock-Free Counter

```c
#include <stdatomic.h>
#include <pthread.h>

typedef struct {
    atomic_int value;
} AtomicCounter;

void counter_init(AtomicCounter *counter) {
    atomic_init(&counter->value, 0);
}

int counter_increment(AtomicCounter *counter) {
    return atomic_fetch_add(&counter->value, 1) + 1;
}

int counter_decrement(AtomicCounter *counter) {
    return atomic_fetch_sub(&counter->value, 1) - 1;
}

int counter_get(AtomicCounter *counter) {
    return atomic_load(&counter->value);
}

// Usage
AtomicCounter counter;
counter_init(&counter);

// Thread-safe increment
int current = counter_increment(&counter);
```

## Reference Counting with Atomics

```c
#include <stdatomic.h>
#include <stdlib.h>

typedef struct {
    atomic_int ref_count;
    void *data;
} RefCounted;

RefCounted *ref_new(void *data) {
    RefCounted *obj = malloc(sizeof(RefCounted));
    if (obj) {
        atomic_init(&obj->ref_count, 1);
        obj->data = data;
    }
    return obj;
}

void ref_retain(RefCounted *obj) {
    if (obj) {
        atomic_fetch_add(&obj->ref_count, 1);
    }
}

void ref_release(RefCounted *obj) {
    if (obj) {
        if (atomic_fetch_sub(&obj->ref_count, 1) == 1) {
            // Last reference, free
            free(obj->data);
            free(obj);
        }
    }
}

// Usage
RefCounted *obj = ref_new(malloc(100));
ref_retain(obj);
ref_release(obj);
ref_release(obj);  // Frees
```

## Best Practices

### Use Appropriate Memory Ordering

```c
// Default to sequentially consistent (safest)
atomic_store(&x, 1);

// Use relaxed for simple counters
atomic_fetch_add(&counter, 1);  // memory_order_relaxed

// Use acquire/release for synchronization
atomic_thread_fence(memory_order_release);
atomic_store_explicit(&flag, 1, memory_order_relaxed);
```

### Check Lock-Free Property

```c
#include <stdatomic.h>

atomic_int a;

// Check if operations are lock-free
if (atomic_is_lock_free(&a)) {
    printf("Atomic operations are lock-free\n");
} else {
    printf("Atomic operations use locks\n");
}
```

### Avoid Overusing Atomics

```c
// GOOD - Simple operation
atomic_int counter;
atomic_fetch_add(&counter, 1);

// BAD - Complex operations, use mutex instead
atomic_int data;
// Complex operations that need multiple steps
// Should use mutex for correctness
```

## Common Pitfalls

### 1. ABA Problem

```c
// WRONG - CAS can fail due to ABA problem
// Thread 1 reads A, Thread 2 changes A->B->A
// Thread 1's CAS with A as expected succeeds but state changed

// SOLUTION - Use version counters or tagged pointers
```

### 2. Wrong Memory Ordering

```c
// WRONG - Incorrect synchronization
atomic_store(&flag, 1);
data = 42;  // Might not be visible before flag!

// CORRECT - Use proper ordering
atomic_thread_fence(memory_order_release);
data = 42;
atomic_store_explicit(&flag, 1, memory_order_relaxed);
```

### 3. Assuming Sequential Consistency

```c
// WRONG - Assuming all operations are totally ordered
// Different threads may see different orders without proper ordering

// CORRECT - Use sequentially consistent when needed
atomic_store_explicit(&x, 1, memory_order_seq_cst);
```

> **Note: Atomic operations are powerful but complex. Use the simplest memory ordering that works. Test thoroughly on different architectures. For complex operations, consider using locks or higher-level synchronization primitives.
