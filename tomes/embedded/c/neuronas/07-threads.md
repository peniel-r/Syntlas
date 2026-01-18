---
id: "c.stdlib.threads"
title: "Thread Support"
category: stdlib
difficulty: advanced
tags: [c, stdlib, pthread, threads, concurrency, mutex]
keywords: [pthread, thread, mutex, condition, join, detach]
use_cases: [concurrent programming, parallel execution, thread safety]
prerequisites: []
related: ["c.stdlib.time"]
next_topics: []
---

# Thread Support

C's <pthread.h> provides POSIX threading functions. Note: Thread support requires linking with -pthread.

## Basic Thread Creation

```c
#include <stdio.h>
#include <pthread.h>

void* thread_function(void* arg) {
    int* thread_id = (int*)arg;
    printf("Thread %d running\n", *thread_id);
    
    return NULL;
}

int main() {
    pthread_t thread;
    int thread_id = 1;
    
    // Create thread
    int rc = pthread_create(&thread, NULL, thread_function, &thread_id);
    if (rc != 0) {
        perror("Failed to create thread");
        return 1;
    }
    
    // Wait for thread to complete
    pthread_join(thread, NULL);
    
    printf("Thread %d completed\n", thread_id);
    return 0;
}
```

## Thread Synchronization with Mutex

```c
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
int shared_counter = 0;

void* increment_thread(void* arg) {
    for (int i = 0; i < 10000; i++) {
        pthread_mutex_lock(&mutex);
        shared_counter++;
        pthread_mutex_unlock(&mutex);
    }
    
    return NULL;
}

int main() {
    pthread_t threads[4];
    int thread_ids[4] = {1, 2, 3, 4};
    
    // Create multiple threads
    for (int i = 0; i < 4; i++) {
        pthread_create(&threads[i], NULL, increment_thread, &thread_ids[i]);
    }
    
    // Wait for all threads
    for (int i = 0; i < 4; i++) {
        pthread_join(threads[i], NULL);
    }
    
    printf("Final counter: %d\n", shared_counter);
    return 0;
}
```

## Condition Variables

```c
#include <stdio.h>
#include <pthread.h>

pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
int work_available = 0;
int work_done = 0;

void* worker_thread(void* arg) {
    int* id = (int*)arg;
    
    // Wait for work
    pthread_mutex_lock(&mutex);
    while (!work_available) {
        pthread_cond_wait(&cond, &mutex);
    }
    pthread_mutex_unlock(&mutex);
    
    printf("Worker %d working\n", *id);
    
    // Signal work done
    pthread_mutex_lock(&mutex);
    work_done = 1;
    work_available = 0;
    pthread_mutex_unlock(&mutex);
    pthread_cond_signal(&cond);
    
    return NULL;
}

int main() {
    pthread_t worker;
    pthread_create(&worker, NULL, worker_thread, NULL);
    
    sleep(1);  // Let worker start
    
    // Assign work
    pthread_mutex_lock(&mutex);
    work_available = 1;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
    
    // Wait for completion
    pthread_mutex_lock(&mutex);
    while (!work_done) {
        pthread_cond_wait(&cond, &mutex);
    }
    pthread_mutex_unlock(&mutex);
    
    pthread_join(worker, NULL);
    return 0;
}
```

## Thread-Safe Counter

```c
#include <stdio.h>
#include <pthread.h>

typedef struct {
    int value;
    pthread_mutex_t mutex;
} ThreadSafeCounter;

ThreadSafeCounter counter = {0, PTHREAD_MUTEX_INITIALIZER};

int safe_increment(ThreadSafeCounter* counter) {
    pthread_mutex_lock(&counter->mutex);
    counter->value++;
    pthread_mutex_unlock(&counter->mutex);
    return counter->value;
}

void* thread_func(void* arg) {
    ThreadSafeCounter* c = (ThreadSafeCounter*)arg;
    
    for (int i = 0; i < 10000; i++) {
        int value = safe_increment(c);
        printf("Counter: %d\n", value);
    }
    
    return NULL;
}

int main() {
    pthread_t threads[5];
    int ids[5] = {1, 2, 3, 4, 5};
    
    for (int i = 0; i < 5; i++) {
        pthread_create(&threads[i], NULL, thread_func, &counter);
    }
    
    for (int i = 0; i < 5; i++) {
        pthread_join(threads[i], NULL);
    }
    
    printf("Final counter: %d\n", counter.value);
    return 0;
}
```

## Thread Pool Pattern

```c
#include <stdio.h>
#include <pthread.h>

#define MAX_THREADS 4
#define THREAD_QUEUE_SIZE 100

typedef struct {
    void (*tasks)[THREAD_QUEUE_SIZE];
    int head;
    int tail;
    int count;
    pthread_mutex_t mutex;
    pthread_cond_t has_work;
    pthread_cond_t has_space;
} ThreadPool;

void* worker_thread(void* arg) {
    ThreadPool* pool = (ThreadPool*)arg;
    
    while (1) {
        pthread_mutex_lock(&pool->mutex);
        
        // Wait for task
        while (pool->count == 0) {
            pthread_cond_wait(&pool->has_work, &pool->mutex);
        }
        
        // Get task
        void (*task)(void*) = pool->tasks[pool->head];
        pool->head = (pool->head + 1) % THREAD_QUEUE_SIZE;
        
        pthread_mutex_unlock(&pool->mutex);
        
        // Execute task
        task(NULL);
        
        // Signal task complete
        pthread_mutex_lock(&pool->mutex);
        pool->count--;
        if (pool->count > 0) {
            pthread_cond_signal(&pool->has_space);
        }
        
        pthread_mutex_unlock(&pool->mutex);
    }
    
    return NULL;
}
```

## Producer-Consumer Pattern

```c
#include <stdio.h>
#include <pthread.h>

#define BUFFER_SIZE 10

typedef struct {
    int buffer[BUFFER_SIZE];
    int in;
    int out;
    int count;
    pthread_mutex_t mutex;
    pthread_cond_t not_empty;
    pthread_cond_t not_full;
} Queue;

Queue queue = {.in = 0, .out = 0, .count = 0, 
             .mutex = PTHREAD_MUTEX_INITIALIZER,
             .not_empty = PTHREAD_COND_INITIALIZER,
             .not_full = PTHREAD_COND_INITIALIZER};

void enqueue(Queue* q, int value) {
    pthread_mutex_lock(&q->mutex);
    
    while (((q->count + 1) % BUFFER_SIZE) == 0) {
        pthread_cond_wait(&q->not_full, &q->mutex);
    }
    
    q->buffer[q->in] = value;
    q->in = (q->in + 1) % BUFFER_SIZE;
    q->count++;
    
    pthread_cond_signal(&q->not_empty);
    pthread_mutex_unlock(&q->mutex);
}

int dequeue(Queue* q, int* value) {
    pthread_mutex_lock(&q->mutex);
    
    while (q->count == 0) {
        pthread_cond_wait(&q->not_empty, &q->mutex);
    }
    
    *value = q->buffer[q->out];
    q->out = (q->out + 1) % BUFFER_SIZE;
    q->count--;
    
    pthread_cond_signal(&q->not_full);
    pthread_mutex_unlock(&q->mutex);
}
```

## Common Patterns

### Thread-local storage (GCC extension)

```c
#if defined(__GNUC__)

static __thread int thread_local_value = 0;

void* thread_func(void* arg) {
    thread_local_value = *(int*)arg;
    printf("Thread %d value: %d\n", pthread_self(), thread_local_value);
    return NULL;
}

int main() {
    int values[] = {10, 20, 30, 40, 50};
    pthread_t threads[4];
    
    for (int i = 0; i < 4; i++) {
        pthread_create(&threads[i], NULL, thread_func, &values[i]);
    }
    
    for (int i = 0; i < 4; i++) {
        pthread_join(threads[i], NULL);
    }
    
    return 0;
}
#endif
```

### Detached Thread

```c
#include <stdio.h>
#include <pthread.h>

void* detached_thread(void* arg) {
    int* value = (int*)arg;
    printf("Detached thread %d running\n", *value);
    
    free(arg);  // Cleanup since parent won't wait
    
    return NULL;
}

int main() {
    pthread_t thread;
    int value = 42;
    
    // Create detached thread
    pthread_create(&thread, NULL, detached_thread, &value);
    pthread_detach(thread);  // Detach from main
    
    // Main thread continues immediately
    printf("Main thread continuing\n");
    sleep(2);  // Give detached thread time
    
    printf("Main thread done\n");
    return 0;
}
```

### Read-Write Lock Pattern

```c
#include <stdio.h>
#include <pthread.h>

typedef struct {
    int readers;
    int writers;
    pthread_mutex_t mutex;
    pthread_cond_t can_read;
    pthread_cond_t can_write;
} RWLock;

RWLock rwlock = {.readers = 0, .writers = 0, 
                  .mutex = PTHREAD_MUTEX_INITIALIZER,
                  .can_read = PTHREAD_COND_INITIALIZER,
                  .can_write = PTHREAD_COND_INITIALIZER};

void start_read(RWLock* lock) {
    pthread_mutex_lock(&lock->mutex);
    
    // Wait if writers active
    while (lock->writers > 0) {
        pthread_cond_wait(&lock->can_read, &lock->mutex);
    }
    
    lock->readers++;
    pthread_mutex_unlock(&lock->mutex);
}

void end_read(RWLock* lock) {
    pthread_mutex_lock(&lock->mutex);
    lock->readers--;
    
    if (lock->readers == 0 && lock->writers == 0) {
        pthread_cond_signal(&lock->can_write);
    }
    
    pthread_mutex_unlock(&lock->mutex);
}

void start_write(RWLock* lock) {
    pthread_mutex_lock(&lock->mutex);
    
    // Wait for no readers or other writers
    while (lock->readers > 0 || lock->writers > 0) {
        pthread_cond_wait(&lock->can_write, &lock->mutex);
    }
    
    lock->writers++;
    pthread_mutex_unlock(&lock->mutex);
}

void end_write(RWLock* lock) {
    pthread_mutex_lock(&lock->mutex);
    lock->writers--;
    
    if (lock->readers == 0 && lock->writers == 0) {
        if (lock->readers > 0) {
            pthread_cond_broadcast(&lock->can_read);
        } else {
            pthread_cond_signal(&lock->can_write);
        }
    }
    
    pthread_mutex_unlock(&lock->mutex);
}
```

> **Warning**: Threaded programming introduces complexity and potential race conditions. Always use appropriate synchronization primitives (mutexes, condition variables) when sharing data between threads.
