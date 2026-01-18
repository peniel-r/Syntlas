---
id: "c.stdlib.threads"
title: "Threads (pthread)"
category: stdlib
difficulty: advanced
tags: [c, threads, pthread, concurrency, mutex]
keywords: [pthread, mutex, condition, thread, lock]
use_cases: [parallel processing, concurrency, synchronization]
prerequisites: ["c.stdlib.process"]
related: ["c.stdlib.signal"]
next_topics: ["c.algorithms.parallel"]
---

# Threads (pthread)

## Basic Thread Creation

```c
#include <stdio.h>
#include <pthread.h>

void* thread_func(void* arg) {
    printf("Thread running\n");
    return NULL;
}

int main() {
    pthread_t thread;

    if (pthread_create(&thread, NULL, thread_func, NULL) != 0) {
        perror("Failed to create thread");
        return 1;
    }

    if (pthread_join(thread, NULL) != 0) {
        perror("Failed to join thread");
        return 1;
    }

    printf("Thread completed\n");

    return 0;
}
```

## Thread with Arguments

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct {
    int id;
    const char* message;
} ThreadArgs;

void* thread_func(void* arg) {
    ThreadArgs* args = (ThreadArgs*)arg;
    printf("Thread %d: %s\n", args->id, args->message);
    return NULL;
}

int main() {
    pthread_t thread;
    ThreadArgs args = {1, "Hello from thread"};

    pthread_create(&thread, NULL, thread_func, &args);
    pthread_join(thread, NULL);

    return 0;
}
```

## Multiple Threads

```c
#include <stdio.h>
#include <pthread.h>

void* thread_func(void* arg) {
    int id = *(int*)arg;
    printf("Thread %d running\n", id);
    return NULL;
}

int main() {
    const int num_threads = 3;
    pthread_t threads[num_threads];
    int ids[num_threads] = {1, 2, 3};

    for (int i = 0; i < num_threads; i++) {
        pthread_create(&threads[i], NULL, thread_func, &ids[i]);
    }

    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
        printf("Thread %d completed\n", ids[i]);
    }

    return 0;
}
```

## Mutex - Basic

```c
#include <stdio.h>
#include <pthread.h>

int counter = 0;
pthread_mutex_t mutex;

void* increment(void* arg) {
    for (int i = 0; i < 10000; i++) {
        pthread_mutex_lock(&mutex);
        counter++;
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

int main() {
    pthread_mutex_init(&mutex, NULL);

    pthread_t t1, t2;
    pthread_create(&t1, NULL, increment, NULL);
    pthread_create(&t2, NULL, increment, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Counter: %d\n", counter);

    pthread_mutex_destroy(&mutex);
    return 0;
}
```

## Mutex with Timeout

```c
#include <stdio.h>
#include <pthread.h>
#include <time.h>

pthread_mutex_t mutex;
int shared_data = 0;

void* try_lock(void* arg) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    ts.tv_sec += 1;

    if (pthread_mutex_timedlock(&mutex, &ts) == 0) {
        printf("Got lock\n");
        shared_data++;
        pthread_mutex_unlock(&mutex);
    } else {
        printf("Lock timeout\n");
    }

    return NULL;
}

int main() {
    pthread_mutex_init(&mutex, NULL);

    pthread_t thread;
    pthread_create(&thread, NULL, try_lock, NULL);
    pthread_join(thread, NULL);

    printf("Shared data: %d\n", shared_data);

    pthread_mutex_destroy(&mutex);
    return 0;
}
```

## Condition Variable

```c
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex;
pthread_cond_t cond;
int ready = 0;

void* wait_for_condition(void* arg) {
    pthread_mutex_lock(&mutex);
    while (!ready) {
        printf("Waiting...\n");
        pthread_cond_wait(&cond, &mutex);
    }
    printf("Condition met!\n");
    pthread_mutex_unlock(&mutex);
    return NULL;
}

void* signal_condition(void* arg) {
    sleep(1);

    pthread_mutex_lock(&mutex);
    ready = 1;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);

    printf("Signaled\n");
    return NULL;
}

int main() {
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);

    pthread_t waiter, signaler;
    pthread_create(&waiter, NULL, wait_for_condition, NULL);
    pthread_create(&signaler, NULL, signal_condition, NULL);

    pthread_join(waiter, NULL);
    pthread_join(signaler, NULL);

    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
    return 0;
}
```

## Read-Write Lock

```c
#include <stdio.h>
#include <pthread.h>

pthread_rwlock_t rwlock;
int shared_data = 0;

void* reader(void* arg) {
    pthread_rwlock_rdlock(&rwlock);
    printf("Reader: %d\n", shared_data);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}

void* writer(void* arg) {
    pthread_rwlock_wrlock(&rwlock);
    shared_data++;
    printf("Writer: %d\n", shared_data);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}

int main() {
    pthread_rwlock_init(&rwlock, NULL);

    pthread_t r1, r2, w1;
    pthread_create(&r1, NULL, reader, NULL);
    pthread_create(&r2, NULL, reader, NULL);
    pthread_create(&w1, NULL, writer, NULL);

    pthread_join(r1, NULL);
    pthread_join(r2, NULL);
    pthread_join(w1, NULL);

    pthread_rwlock_destroy(&rwlock);
    return 0;
}
```

## Thread-Specific Data

```c
#include <stdio.h>
#include <pthread.h>

static pthread_key_t thread_key;

void thread_key_init(void) {
    pthread_key_create(&thread_key, NULL);
}

void set_thread_data(void* data) {
    pthread_setspecific(thread_key, data);
}

void* get_thread_data(void) {
    return pthread_getspecific(thread_key);
}

void cleanup_key(void) {
    pthread_key_delete(thread_key);
}

void* thread_func(void* arg) {
    int thread_id = *(int*)arg;
    set_thread_data(&thread_id);

    int* data = (int*)get_thread_data();
    printf("Thread %d: Data %p\n", thread_id, data);

    return NULL;
}

int main() {
    thread_key_init();

    pthread_t t1, t2;
    int id1 = 1, id2 = 2;

    pthread_create(&t1, NULL, thread_func, &id1);
    pthread_create(&t2, NULL, thread_func, &id2);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    cleanup_key();
    return 0;
}
```

## Barrier

```c
#include <stdio.h>
#include <pthread.h>

#define NUM_THREADS 3

pthread_barrier_t barrier;

void* thread_func(void* arg) {
    int id = *(int*)arg;
    printf("Thread %d waiting\n", id);

    pthread_barrier_wait(&barrier);

    printf("Thread %d proceeding\n", id);
    return NULL;
}

int main() {
    pthread_barrier_init(&barrier, NULL, NUM_THREADS);

    pthread_t threads[NUM_THREADS];
    int ids[NUM_THREADS] = {1, 2, 3};

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_create(&threads[i], NULL, thread_func, &ids[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    pthread_barrier_destroy(&barrier);
    return 0;
}
```

## Semaphore

```c
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t semaphore;

void* thread_func(void* arg) {
    sem_wait(&semaphore);
    printf("Thread entered critical section\n");
    sleep(1);
    printf("Thread leaving critical section\n");
    sem_post(&semaphore);
    return NULL;
}

int main() {
    sem_init(&semaphore, 0, 2);

    pthread_t t1, t2, t3;
    pthread_create(&t1, NULL, thread_func, NULL);
    pthread_create(&t2, NULL, thread_func, NULL);
    pthread_create(&t3, NULL, thread_func, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);

    sem_destroy(&semaphore);
    return 0;
}
```

## Thread Attributes

```c
#include <stdio.h>
#include <pthread.h>

void* thread_func(void* arg) {
    printf("Thread running\n");
    return NULL;
}

int main() {
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    // Set detached state
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

    // Set stack size
    size_t stack_size = 1024 * 1024;
    pthread_attr_setstacksize(&attr, stack_size);

    pthread_t thread;
    pthread_create(&thread, &attr, thread_func, NULL);

    pthread_join(thread, NULL);

    pthread_attr_destroy(&attr);
    return 0;
}
```

## Thread Cancelation

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* thread_func(void* arg) {
    while (1) {
        printf("Thread working...\n");
        sleep(1);
        pthread_testcancel();
    }
    return NULL;
}

int main() {
    pthread_t thread;
    pthread_create(&thread, NULL, thread_func, NULL);

    sleep(3);

    printf("Canceling thread\n");
    pthread_cancel(thread);

    void* result;
    pthread_join(thread, &result);

    printf("Thread %s\n",
           result == PTHREAD_CANCELED ? "canceled" : "completed");

    return 0;
}
```

## Thread Pool

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct {
    void (*task)(void*);
    void* arg;
} Task;

typedef struct {
    pthread_t* threads;
    Task* tasks;
    int thread_count;
    int task_count;
    int head;
    int tail;
    int shutdown;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
} ThreadPool;

void* worker_thread(void* arg) {
    ThreadPool* pool = (ThreadPool*)arg;

    while (1) {
        pthread_mutex_lock(&pool->mutex);

        while (pool->task_count == 0 && !pool->shutdown) {
            pthread_cond_wait(&pool->cond, &pool->mutex);
        }

        if (pool->shutdown) {
            pthread_mutex_unlock(&pool->mutex);
            pthread_exit(NULL);
        }

        Task task = pool->tasks[pool->head];
        pool->head = (pool->head + 1) % 100;
        pool->task_count--;

        pthread_mutex_unlock(&pool->mutex);

        task.task(task.arg);
    }

    return NULL;
}

ThreadPool* thread_pool_create(int thread_count) {
    ThreadPool* pool = malloc(sizeof(ThreadPool));
    pool->threads = malloc(thread_count * sizeof(pthread_t));
    pool->tasks = malloc(100 * sizeof(Task));
    pool->thread_count = thread_count;
    pool->task_count = 0;
    pool->head = 0;
    pool->tail = 0;
    pool->shutdown = 0;

    pthread_mutex_init(&pool->mutex, NULL);
    pthread_cond_init(&pool->cond, NULL);

    for (int i = 0; i < thread_count; i++) {
        pthread_create(&pool->threads[i], NULL, worker_thread, pool);
    }

    return pool;
}

int main() {
    ThreadPool* pool = thread_pool_create(3);
    // Submit tasks...
    // Wait for completion...
    // Cleanup...

    free(pool->threads);
    free(pool->tasks);
    free(pool);

    return 0;
}
```

## Spinlock

```c
#include <stdio.h>
#include <pthread.h>

pthread_spinlock_t spinlock;
int shared_data = 0;

void* thread_func(void* arg) {
    pthread_spin_lock(&spinlock);
    shared_data++;
    pthread_spin_unlock(&spinlock);
    return NULL;
}

int main() {
    pthread_spin_init(&spinlock, PTHREAD_PROCESS_PRIVATE);

    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread_func, NULL);
    pthread_create(&t2, NULL, thread_func, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Shared data: %d\n", shared_data);

    pthread_spin_destroy(&spinlock);
    return 0;
}
```

> **Note**: pthreads is Unix-specific. Windows uses different threading APIs. Always check return values and clean up resources.
