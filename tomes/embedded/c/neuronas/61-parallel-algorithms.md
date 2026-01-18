---
id: "c.algorithms.parallel"
title: "Parallel Algorithms"
category: algorithms
difficulty: advanced
tags: [c, algorithms, parallel, concurrency, openmp]
keywords: [parallel, openmp, concurrent, multithreaded, divide and conquer]
use_cases: [parallel processing, performance optimization, speedup]
prerequisites: [c.stdlib.threads"]
related: [c.algorithms.sort"]
next_topics: [c.bestpractices.performance]
---

# Parallel Algorithms

## Parallel Sum

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

typedef struct {
    int* array;
    int start;
    int end;
    int partial_sum;
} SumData;

void* parallel_sum(void* arg) {
    SumData* data = (SumData*)arg;
    int sum = 0;

    for (int i = data->start; i < data->end; i++) {
        sum += data->array[i];
    }

    data->partial_sum = sum;
    return NULL;
}

int main() {
    int array[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    int size = sizeof(array) / sizeof(array[0]);
    int chunk_size = size / NUM_THREADS;

    pthread_t threads[NUM_THREADS];
    SumData data[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;

        pthread_create(&threads[i], NULL, parallel_sum, &data[i]);
    }

    int total_sum = 0;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
        total_sum += data[i].partial_sum;
    }

    printf("Parallel sum: %d\n", total_sum);

    return 0;
}
```

## Parallel Max

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <limits.h>

#define NUM_THREADS 4

typedef struct {
    int* array;
    int start;
    int end;
    int max_value;
} MaxData;

void* parallel_max(void* arg) {
    MaxData* data = (MaxData*)arg;
    int max = INT_MIN;

    for (int i = data->start; i < data->end; i++) {
        if (data->array[i] > max) {
            max = data->array[i];
        }
    }

    data->max_value = max;
    return NULL;
}

int main() {
    int array[] = {5, 2, 8, 1, 9, 3, 7, 4, 6, 10};
    int size = sizeof(array) / sizeof(array[0]);
    int chunk_size = size / NUM_THREADS;

    pthread_t threads[NUM_THREADS];
    MaxData data[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;

        pthread_create(&threads[i], NULL, parallel_max, &data[i]);
    }

    int global_max = INT_MIN;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);

        if (data[i].max_value > global_max) {
            global_max = data[i].max_value;
        }
    }

    printf("Parallel max: %d\n", global_max);

    return 0;
}
```

## Parallel Count

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

typedef struct {
    int* array;
    int start;
    int end;
    int target;
    int count;
} CountData;

void* parallel_count(void* arg) {
    CountData* data = (CountData*)arg;
    int count = 0;

    for (int i = data->start; i < data->end; i++) {
        if (data->array[i] == data->target) {
            count++;
        }
    }

    data->count = count;
    return NULL;
}

int main() {
    int array[] = {1, 2, 1, 3, 1, 4, 1, 5, 1, 1};
    int size = sizeof(array) / sizeof(array[0]);
    int chunk_size = size / NUM_THREADS;

    pthread_t threads[NUM_THREADS];
    CountData data[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;
        data[i].target = 1;

        pthread_create(&threads[i], NULL, parallel_count, &data[i]);
    }

    int total_count = 0;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
        total_count += data[i].count;
    }

    printf("Parallel count: %d\n", total_count);

    return 0;
}
```

## Parallel Sort (Merge Sort)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS 2

typedef struct {
    int* array;
    int start;
    int mid;
    int end;
} MergeData;

void merge(int* array, int start, int mid, int end) {
    int temp[end - start + 1];

    int i = start;
    int j = mid + 1;
    int k = 0;

    while (i <= mid && j <= end) {
        if (array[i] <= array[j]) {
            temp[k++] = array[i++];
        } else {
            temp[k++] = array[j++];
        }
    }

    while (i <= mid) {
        temp[k++] = array[i++];
    }

    while (j <= end) {
        temp[k++] = array[j++];
    }

    memcpy(array + start, temp, (end - start + 1) * sizeof(int));
}

void* parallel_merge_sort(void* arg) {
    MergeData* data = (MergeData*)arg;

    if (data->start < data->end) {
        int mid = data->start + (data->end - data->start) / 2;

        MergeData left = {data->array, data->start, 0, mid};
        MergeData right = {data->array, mid + 1, 0, data->end};

        parallel_merge_sort(&left);
        parallel_merge_sort(&right);

        merge(data->array, data->start, mid, data->end);
    }

    return NULL;
}

int main() {
    int array[] = {5, 2, 8, 1, 9, 3, 7, 4, 6};
    int size = sizeof(array) / sizeof(array[0]);

    pthread_t threads[NUM_THREADS];
    MergeData data[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        int chunk_size = size / NUM_THREADS;
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].mid = 0;
        data[i].end = (i == NUM_THREADS - 1) ? size - 1 : (i + 1) * chunk_size - 1;

        pthread_create(&threads[i], NULL, parallel_merge_sort, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Sorted array:\n");
    for (int i = 0; i < size; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");

    return 0;
}
```

## Parallel Matrix Multiplication

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4
#define SIZE 100

typedef struct {
    int* A;
    int* B;
    int* C;
    int start_row;
    int end_row;
    int N;
} MatMulData;

void* parallel_matrix_multiply(void* arg) {
    MatMulData* data = (MatMulData*)arg;

    for (int i = data->start_row; i < data->end_row; i++) {
        for (int j = 0; j < data->N; j++) {
            int sum = 0;
            for (int k = 0; k < data->N; k++) {
                sum += data->A[i * data->N + k] * data->B[k * data->N + j];
            }
            data->C[i * data->N + j] = sum;
        }
    }

    return NULL;
}

int main() {
    int* A = malloc(SIZE * SIZE * sizeof(int));
    int* B = malloc(SIZE * SIZE * sizeof(int));
    int* C = malloc(SIZE * SIZE * sizeof(int));

    // Initialize matrices
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            A[i * SIZE + j] = i;
            B[i * SIZE + j] = j;
        }
    }

    pthread_t threads[NUM_THREADS];
    MatMulData data[NUM_THREADS];

    int rows_per_thread = SIZE / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].A = A;
        data[i].B = B;
        data[i].C = C;
        data[i].start_row = i * rows_per_thread;
        data[i].end_row = (i == NUM_THREADS - 1) ? SIZE : (i + 1) * rows_per_thread;
        data[i].N = SIZE;

        pthread_create(&threads[i], NULL, parallel_matrix_multiply, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Matrix multiplication complete\n");

    free(A);
    free(B);
    free(C);

    return 0;
}
```

## Parallel Prefix Sum

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 2

typedef struct {
    int* array;
    int start;
    int end;
} PrefixData;

void* parallel_prefix_sum(void* arg) {
    PrefixData* data = (PrefixData*)arg;

    int sum = 0;
    for (int i = data->start; i <= data->end; i++) {
        sum += data->array[i];
        data->array[i] = sum;
    }

    return NULL;
}

int main() {
    int array[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int size = sizeof(array) / sizeof(array[0]);

    pthread_t threads[NUM_THREADS];
    PrefixData data[NUM_THREADS];

    int chunk_size = size / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size - 1;

        pthread_create(&threads[i], NULL, parallel_prefix_sum, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    // Fix boundaries between chunks
    for (int i = chunk_size - 1; i < size; i += chunk_size) {
        int carry = array[i];
        for (int j = i + 1; j < i + chunk_size && j < size; j++) {
            array[j] += carry;
            carry = 0;
        }
    }

    printf("Prefix sum:\n");
    for (int i = 0; i < size; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");

    return 0;
}
```

## Parallel Filter

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

typedef struct {
    int* input;
    int* output;
    int start;
    int end;
    int predicate;
    int count;
} FilterData;

void* parallel_filter(void* arg) {
    FilterData* data = (FilterData*)arg;
    int write_pos = data->start;

    for (int i = data->start; i < data->end; i++) {
        if (data->input[i] == data->predicate) {
            data->output[write_pos++] = data->input[i];
        }
    }

    data->count = write_pos - data->start;
    return NULL;
}

int main() {
    int input[] = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1};
    int size = sizeof(input) / sizeof(input[0]);
    int* output = malloc(size * sizeof(int));

    pthread_t threads[NUM_THREADS];
    FilterData data[NUM_THREADS];

    int chunk_size = size / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].input = input;
        data[i].output = output;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;
        data[i].predicate = 1;

        pthread_create(&threads[i], NULL, parallel_filter, &data[i]);
    }

    int total_count = 0;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
        total_count += data[i].count;
    }

    printf("Filtered array (%d elements):\n", total_count);
    for (int i = 0; i < total_count; i++) {
        printf("%d ", output[i]);
    }
    printf("\n");

    free(output);

    return 0;
}
```

## Parallel Map

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

typedef struct {
    int* input;
    int* output;
    int start;
    int end;
} MapData;

void* parallel_map(void* arg) {
    MapData* data = (MapData*)arg;

    for (int i = data->start; i < data->end; i++) {
        data->output[i] = data->input[i] * 2;
    }

    return NULL;
}

int main() {
    int input[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    int size = sizeof(input) / sizeof(input[0]);
    int* output = malloc(size * sizeof(int));

    pthread_t threads[NUM_THREADS];
    MapData data[NUM_THREADS];

    int chunk_size = size / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].input = input;
        data[i].output = output;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;

        pthread_create(&threads[i], NULL, parallel_map, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Mapped array:\n");
    for (int i = 0; i < size; i++) {
        printf("%d ", output[i]);
    }
    printf("\n");

    free(output);

    return 0;
}
```

## Parallel Reduce

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4

typedef struct {
    int* array;
    int start;
    int end;
    int sum;
} ReduceData;

void* parallel_reduce(void* arg) {
    ReduceData* data = (ReduceData*)arg;
    int sum = 0;

    for (int i = data->start; i < data->end; i++) {
        sum += data->array[i];
    }

    data->sum = sum;
    return NULL;
}

int main() {
    int array[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    int size = sizeof(array) / sizeof(array[0]);

    pthread_t threads[NUM_THREADS];
    ReduceData data[NUM_THREADS];

    int chunk_size = size / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].array = array;
        data[i].start = i * chunk_size;
        data[i].end = (i == NUM_THREADS - 1) ? size : (i + 1) * chunk_size;

        pthread_create(&threads[i], NULL, parallel_reduce, &data[i]);
    }

    int total_sum = 0;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
        total_sum += data[i].sum;
    }

    printf("Reduced sum: %d\n", total_sum);

    return 0;
}
```

## Parallel BFS

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_NODES 100
#define NUM_THREADS 4

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int visited[MAX_NODES];
    int start;
    int distance[MAX_NODES];
} GraphData;

typedef struct {
    GraphData* graph;
    int queue[MAX_NODES];
    int front;
    int rear;
    int thread_id;
} BFSData;

pthread_mutex_t queue_mutex;

void* parallel_bfs(void* arg) {
    BFSData* data = (BFSData*)arg;

    while (1) {
        pthread_mutex_lock(&queue_mutex);

        if (data->front >= data->rear) {
            pthread_mutex_unlock(&queue_mutex);
            break;
        }

        int current = data->queue[data->front++];
        pthread_mutex_unlock(&queue_mutex);

        if (data->graph->visited[current]) {
            continue;
        }

        data->graph->visited[current] = 1;

        for (int i = 0; i < data->graph->adj_count[current]; i++) {
            int neighbor = data->graph->adj[current][i];

            if (!data->graph->visited[neighbor]) {
                pthread_mutex_lock(&queue_mutex);
                data->queue[data->rear++] = neighbor;
                data->distance[neighbor] = data->distance[current] + 1;
                pthread_mutex_unlock(&queue_mutex);
            }
        }
    }

    return NULL;
}

int main() {
    pthread_mutex_init(&queue_mutex, NULL);

    GraphData graph;
    for (int i = 0; i < MAX_NODES; i++) {
        graph.adj_count[i] = 0;
        graph.visited[i] = 0;
        for (int j = 0; j < MAX_NODES; j++) {
            graph.adj[i][j] = 0;
        }
        graph.distance[i] = -1;
    }

    // Build simple graph
    graph.adj[0][0] = 1;
    graph.adj[0][1] = 2;
    graph.adj_count[0] = 2;

    graph.adj[1][0] = 3;
    graph.adj[1][1] = 4;
    graph.adj_count[1] = 2;

    graph.adj[2][0] = 5;
    graph.adj[2][1] = 6;
    graph.adj_count[2] = 2;

    pthread_t threads[NUM_THREADS];
    BFSData data[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++) {
        data[i].graph = &graph;
        data[i].front = 0;
        data[i].rear = 1;
        data[i].queue[0] = i;
        data[i].thread_id = i;

        pthread_create(&threads[i], NULL, parallel_bfs, &data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Distances from thread 0:\n");
    for (int i = 0; i < 7; i++) {
        printf("Node %d: %d\n", i, graph.distance[i]);
    }

    pthread_mutex_destroy(&queue_mutex);

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

void* thread_func(void* arg) {
    int id = *(int*)arg;

    printf("Thread %d waiting at barrier\n", id);
    pthread_barrier_wait(&barrier, NULL);

    printf("Thread %d passed barrier\n", id);

    return NULL;
}

int main() {
    pthread_barrier_init(&barrier, NULL, NUM_THREADS);

    pthread_t threads[NUM_THREADS];
    int ids[NUM_THREADS] = {0, 1, 2, 3};

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

> **Note**: Parallel algorithms require careful synchronization. Use appropriate locks, barriers, or atomic operations.
