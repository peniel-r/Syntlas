---
id: 85-synchronization
title: Thread Synchronization
category: system
difficulty: advanced
tags:
  - pthread
  - mutex
  - condition-variable
  - semaphore
keywords:
  - mutex
  - condition variable
  - semaphore
  - pthread
  - synchronization
use_cases:
  - Thread coordination
  - Resource protection
  - Concurrent access
  - Thread safety
prerequisites:
  - threads
  - process-management
related:
  - inter-process-communication
  - threads
next_topics:
  - atomics
---

# Thread Synchronization

Synchronization mechanisms ensure safe concurrent access to shared resources.

## Mutex (Mutual Exclusion)

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int counter = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *increment_counter(void *arg) {
    for (int i = 0; i < 100000; i++) {
        // Lock mutex
        pthread_mutex_lock(&mutex);

        // Critical section
        counter++;

        // Unlock mutex
        pthread_mutex_unlock(&mutex);
    }

    return NULL;
}

int main(void) {
    pthread_t thread1, thread2;

    // Create threads
    pthread_create(&thread1, NULL, increment_counter, NULL);
    pthread_create(&thread2, NULL, increment_counter, NULL);

    // Wait for threads
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Final counter: %d\n", counter);
    // Should be 200000

    // Destroy mutex
    pthread_mutex_destroy(&mutex);

    return 0;
}
```

## Mutex Initialization and Destruction

```c
#include <pthread.h>

// Static initialization
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

// Dynamic initialization
pthread_mutex_t mutex;
pthread_mutex_init(&mutex, NULL);

// With attributes
pthread_mutex_t mutex;
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
pthread_mutex_init(&mutex, &attr);
pthread_mutexattr_destroy(&attr);

// Destroy mutex
pthread_mutex_destroy(&mutex);
```

## Try Lock

```c
#include <pthread.h>
#include <stdio.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
int resource = 0;

void *try_access(void *arg) {
    int id = *(int *)arg;

    // Try to lock without blocking
    if (pthread_mutex_trylock(&mutex) == 0) {
        printf("Thread %d: Acquired lock\n", id);

        // Critical section
        resource++;

        // Unlock
        pthread_mutex_unlock(&mutex);
        printf("Thread %d: Released lock\n", id);
    } else {
        printf("Thread %d: Lock busy, doing other work\n", id);
    }

    return NULL;
}

int main(void) {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;

    pthread_mutex_lock(&mutex);  // Hold lock initially

    pthread_create(&thread1, NULL, try_access, &id1);
    pthread_create(&thread2, NULL, try_access, &id2);

    sleep(1);  // Threads will try to lock
    pthread_mutex_unlock(&mutex);  // Release

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    pthread_mutex_destroy(&mutex);
    return 0;
}
```

## Condition Variables

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
int data_ready = 0;
int shared_data = 0;

void *producer(void *arg) {
    for (int i = 0; i < 5; i++) {
        pthread_mutex_lock(&mutex);

        // Produce data
        shared_data = i * 10;
        data_ready = 1;

        printf("Producer: Produced %d\n", shared_data);

        // Signal consumer
        pthread_cond_signal(&cond);

        pthread_mutex_unlock(&mutex);

        sleep(1);
    }

    return NULL;
}

void *consumer(void *arg) {
    for (int i = 0; i < 5; i++) {
        pthread_mutex_lock(&mutex);

        // Wait for data
        while (!data_ready) {
            pthread_cond_wait(&cond, &mutex);
        }

        // Consume data
        printf("Consumer: Consumed %d\n", shared_data);
        data_ready = 0;

        pthread_mutex_unlock(&mutex);
    }

    return NULL;
}

int main(void) {
    pthread_t producer_thread, consumer_thread;

    pthread_create(&producer_thread, NULL, producer, NULL);
    pthread_create(&consumer_thread, NULL, consumer, NULL);

    pthread_join(producer_thread, NULL);
    pthread_join(consumer_thread, NULL);

    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);

    return 0;
}
```

## Semaphores

```c
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <pthread.h>

#define BUFFER_SIZE 5
sem_t empty, full;
int buffer[BUFFER_SIZE];
int in = 0, out = 0;

void *producer(void *arg) {
    for (int i = 0; i < 10; i++) {
        int item = i;

        // Wait for empty slot
        sem_wait(&empty);

        // Add to buffer
        buffer[in] = item;
        in = (in + 1) % BUFFER_SIZE;
        printf("Producer: Produced %d\n", item);

        // Signal slot filled
        sem_post(&full);

        sleep(1);
    }

    return NULL;
}

void *consumer(void *arg) {
    for (int i = 0; i < 10; i++) {
        // Wait for item
        sem_wait(&full);

        // Remove from buffer
        int item = buffer[out];
        out = (out + 1) % BUFFER_SIZE;
        printf("Consumer: Consumed %d\n", item);

        // Signal slot empty
        sem_post(&empty);

        sleep(2);
    }

    return NULL;
}

int main(void) {
    pthread_t producer_thread, consumer_thread;

    // Initialize semaphores
    sem_init(&empty, 0, BUFFER_SIZE);  // Initially all empty
    sem_init(&full, 0, 0);            // Initially none full

    pthread_create(&producer_thread, NULL, producer, NULL);
    pthread_create(&consumer_thread, NULL, consumer, NULL);

    pthread_join(producer_thread, NULL);
    pthread_join(consumer_thread, NULL);

    // Cleanup
    sem_destroy(&empty);
    sem_destroy(&full);

    return 0;
}
```

## Read-Write Locks

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
int shared_data = 0;

void *reader(void *arg) {
    int id = *(int *)arg;

    // Acquire read lock (multiple readers can hold this)
    pthread_rwlock_rdlock(&rwlock);

    printf("Reader %d: Reading data = %d\n", id, shared_data);
    sleep(1);

    // Release read lock
    pthread_rwlock_unlock(&rwlock);
    printf("Reader %d: Done\n", id);

    return NULL;
}

void *writer(void *arg) {
    int id = *(int *)arg;

    // Acquire write lock (exclusive access)
    pthread_rwlock_wrlock(&rwlock);

    printf("Writer %d: Writing data\n", id);
    shared_data += 10;
    printf("Writer %d: Wrote data = %d\n", id, shared_data);
    sleep(1);

    // Release write lock
    pthread_rwlock_unlock(&rwlock);
    printf("Writer %d: Done\n", id);

    return NULL;
}

int main(void) {
    pthread_t threads[6];
    int ids[6] = {1, 2, 3, 4, 5, 6};

    // Create readers and writers
    pthread_create(&threads[0], NULL, reader, &ids[0]);
    pthread_create(&threads[1], NULL, reader, &ids[1]);
    pthread_create(&threads[2], NULL, reader, &ids[2]);
    pthread_create(&threads[3], NULL, writer, &ids[3]);
    pthread_create(&threads[4], NULL, reader, &ids[4]);
    pthread_create(&threads[5], NULL, writer, &ids[5]);

    // Wait for all threads
    for (int i = 0; i < 6; i++) {
        pthread_join(threads[i], NULL);
    }

    pthread_rwlock_destroy(&rwlock);
    return 0;
}
```

## Barrier Synchronization

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

pthread_barrier_t barrier;

void *thread_function(void *arg) {
    int id = *(int *)arg;

    printf("Thread %d: Phase 1\n", id);
    sleep(1);

    // Wait at barrier
    pthread_barrier_wait(&barrier);
    printf("Thread %d: Phase 2\n", id);

    sleep(1);

    // Wait at barrier again
    pthread_barrier_wait(&barrier);
    printf("Thread %d: Phase 3\n", id);

    return NULL;
}

int main(void) {
    pthread_t threads[NUM_THREADS];
    int ids[NUM_THREADS];

    // Initialize barrier
    pthread_barrier_init(&barrier, NULL, NUM_THREADS);

    // Create threads
    for (int i = 0; i < NUM_THREADS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, thread_function, &ids[i]);
    }

    // Wait for threads
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    // Destroy barrier
    pthread_barrier_destroy(&barrier);

    return 0;
}
```

## Deadlock Prevention

```c
#include <pthread.h>

pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex2 = PTHREAD_MUTEX_INITIALIZER;

// WRONG - Potential deadlock
void *deadlock_thread1(void *arg) {
    pthread_mutex_lock(&mutex1);
    sleep(1);
    pthread_mutex_lock(&mutex2);  // Might block forever
    // Critical section
    pthread_mutex_unlock(&mutex2);
    pthread_mutex_unlock(&mutex1);
    return NULL;
}

void *deadlock_thread2(void *arg) {
    pthread_mutex_lock(&mutex2);
    sleep(1);
    pthread_mutex_lock(&mutex1);  // Might block forever
    // Critical section
    pthread_mutex_unlock(&mutex1);
    pthread_mutex_unlock(&mutex2);
    return NULL;
}

// CORRECT - Consistent locking order prevents deadlock
void *safe_thread1(void *arg) {
    pthread_mutex_lock(&mutex1);
    pthread_mutex_lock(&mutex2);  // Always lock 1 then 2
    // Critical section
    pthread_mutex_unlock(&mutex2);
    pthread_mutex_unlock(&mutex1);
    return NULL;
}

void *safe_thread2(void *arg) {
    pthread_mutex_lock(&mutex1);  // Always lock 1 then 2
    pthread_mutex_lock(&mutex2);
    // Critical section
    pthread_mutex_unlock(&mutex2);
    pthread_mutex_unlock(&mutex1);
    return NULL;
}
```

## Mutex Attributes

```c
#include <pthread.h>
#include <stdio.h>

void create_mutex_types(void) {
    pthread_mutex_t mutex;
    pthread_mutexattr_t attr;

    pthread_mutexattr_init(&attr);

    // Normal mutex (default)
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    pthread_mutex_init(&mutex, &attr);
    pthread_mutex_destroy(&mutex);

    // Error checking mutex
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
    pthread_mutex_init(&mutex, &attr);
    pthread_mutex_destroy(&mutex);

    // Recursive mutex (can lock multiple times by same thread)
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);
    pthread_mutex_destroy(&mutex);

    pthread_mutexattr_destroy(&attr);
}
```

## Best Practices

### Always Lock and Unlock Properly

```c
// GOOD - Ensure unlock happens
pthread_mutex_lock(&mutex);
// Critical section
if (error) {
    pthread_mutex_unlock(&mutex);  // Unlock before return
    return -1;
}
pthread_mutex_unlock(&mutex);

// BETTER - Use RAII pattern in C (requires helper function)
```

### Keep Locks Brief

```c
// GOOD - Short critical section
pthread_mutex_lock(&mutex);
int value = shared_variable;
pthread_mutex_unlock(&mutex);

// Process value (not holding lock)
result = process(value);

// BAD - Long critical section
pthread_mutex_lock(&mutex);
int value = shared_variable;
result = process(value);  // Takes time, holding lock
pthread_mutex_unlock(&mutex);
```

### Avoid Nested Locks

```c
// AVOID - Complex locking leads to deadlocks
pthread_mutex_lock(&mutex1);
pthread_mutex_lock(&mutex2);
pthread_mutex_lock(&mutex3);
// ...
pthread_mutex_unlock(&mutex3);
pthread_mutex_unlock(&mutex2);
pthread_mutex_unlock(&mutex1);

// BETTER - Simplify locking
pthread_mutex_lock(&main_mutex);
// All operations
pthread_mutex_unlock(&main_mutex);
```

## Common Pitfalls

### 1. Forgetting to Unlock

```c
// WRONG - Unlock forgotten
pthread_mutex_lock(&mutex);
if (error_condition) {
    return -1;  // Forgot to unlock!
}
pthread_mutex_unlock(&mutex);

// CORRECT - Always unlock
pthread_mutex_lock(&mutex);
if (error_condition) {
    pthread_mutex_unlock(&mutex);
    return -1;
}
pthread_mutex_unlock(&mutex);
```

### 2. Double Lock

```c
// WRONG - Same thread locks twice (deadlock with normal mutex)
pthread_mutex_lock(&mutex);
pthread_mutex_lock(&mutex);  // Deadlock!
// Critical section
pthread_mutex_unlock(&mutex);
pthread_mutex_unlock(&mutex);

// CORRECT - Use recursive mutex
pthread_mutexattr_t attr;
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
pthread_mutex_init(&mutex, &attr);
```

### 3. Wrong Wait Condition

```c
// WRONG - Spurious wakeups not handled
if (!condition) {
    pthread_cond_wait(&cond, &mutex);
}

// CORRECT - Always use while loop
while (!condition) {
    pthread_cond_wait(&cond, &mutex);
}
```

> **Note: Synchronization is complex and error-prone. Always use the simplest mechanism that works. Test thoroughly with multiple threads. Consider using higher-level abstractions or libraries when possible. Always initialize and destroy synchronization primitives properly.
