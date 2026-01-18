---
id: "c.patterns.callbacks"
title: "Callbacks and Function Pointers"
category: patterns
difficulty: intermediate
tags: [c, callback, function pointer, strategy]
keywords: [callback, function pointer, strategy, observer]
use_cases: [event handling, sorting, c.algorithms.sorting]
prerequisites: ["c.pointers", "c.functions"]
related: ["c.stdlib.qsort"]
next_topics: ["c.stdlib.signal"]
---

# Callbacks and Function 

## Function Pointer Basics

```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int main() {
    int (*operation)(int, int) = add;

    printf("5 + 3 = %d\n", operation(5, 3));

    operation = multiply;
    printf("5 * 3 = %d\n", operation(5, 3));

    return 0;
}
```

## Callback Function

```c
#include <stdio.h>

void process_array(int* arr, size_t size,
                  void (*callback)(int)) {
    for (size_t i = 0; i < size; i++) {
        callback(arr[i]);
    }
}

void print_number(int n) {
    printf("%d ", n);
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    process_array(numbers, size, print_number);
    printf("\n");

    return 0;
}
```

## Array Map

```c
#include <stdio.h>
#include <stdlib.h>

int* map(int* arr, size_t size,
         int (*transform)(int)) {
    int* result = malloc(size * sizeof(int));
    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < size; i++) {
        result[i] = transform(arr[i]);
    }

    return result;
}

int square(int x) {
    return x * x;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int* squared = map(numbers, size, square);

    for (size_t i = 0; i < size; i++) {
        printf("%d ", squared[i]);
    }
    printf("\n");

    free(squared);
    return 0;
}
```

## Array Filter

```c
#include <stdio.h>
#include <stdlib.h>

int* filter(int* arr, size_t size,
            bool (*predicate)(int),
            size_t* result_size) {
    int* result = malloc(size * sizeof(int));
    if (result == NULL) {
        return NULL;
    }

    size_t count = 0;
    for (size_t i = 0; i < size; i++) {
        if (predicate(arr[i])) {
            result[count++] = arr[i];
        }
    }

    *result_size = count;
    return result;
}

bool is_even(int x) {
    return x % 2 == 0;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    size_t even_count;
    int* evens = filter(numbers, size, is_even, &even_count);

    printf("Even numbers: ");
    for (size_t i = 0; i < even_count; i++) {
        printf("%d ", evens[i]);
    }
    printf("\n");

    free(evens);
    return 0;
}
```

## Array Reduce

```c
#include <stdio.h>

int reduce(int* arr, size_t size,
           int (*accumulator)(int, int),
           int initial) {
    int result = initial;

    for (size_t i = 0; i < size; i++) {
        result = accumulator(result, arr[i]);
    }

    return result;
}

int sum(int a, int b) {
    return a + b;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int total = reduce(numbers, size, sum, 0);
    printf("Sum: %d\n", total);

    return 0;
}
```

## Strategy Pattern

```c
#include <stdio.h>
#include <string.h>

typedef int (*CompareFunc)(const void*, const void*);

int compare_int(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

int compare_string(const void* a, const void* b) {
    return strcmp(*(const char**)a, *(const char**)b);
}

void sort_array(void* arr, size_t size, size_t elem_size,
                CompareFunc compare) {
    // Bubble sort for demonstration
    for (size_t i = 0; i < size - 1; i++) {
        for (size_t j = 0; j < size - i - 1; j++) {
            void* a = (char*)arr + j * elem_size;
            void* b = (char*)arr + (j + 1) * elem_size;

            if (compare(a, b) > 0) {
                // Swap
                char temp[elem_size];
                memcpy(temp, a, elem_size);
                memcpy(a, b, elem_size);
                memcpy(b, temp, elem_size);
            }
        }
    }
}

int main() {
    int numbers[] = {5, 2, 8, 1, 9};
    size_t num_size = sizeof(numbers) / sizeof(numbers[0]);

    sort_array(numbers, num_size, sizeof(int), compare_int);

    printf("Sorted numbers: ");
    for (size_t i = 0; i < num_size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Observer Pattern

```c
#include <stdio.h>
#include <stdlib.h>

typedef void (*ObserverCallback)(int);

typedef struct {
    ObserverCallback callback;
    struct Observer* next;
} Observer;

Observer* observers = NULL;

void add_observer(ObserverCallback callback) {
    Observer* obs = malloc(sizeof(Observer));
    obs->callback = callback;
    obs->next = observers;
    observers = obs;
}

void notify_observers(int value) {
    Observer* obs = observers;
    while (obs != NULL) {
        obs->callback(value);
        obs = obs->next;
    }
}

void observer1(int value) {
    printf("Observer1: %d\n", value);
}

void observer2(int value) {
    printf("Observer2: %d\n", value);
}

int main() {
    add_observer(observer1);
    add_observer(observer2);

    notify_observers(42);

    return 0;
}
```

## Function Pointer Array

```c
#include <stdio.h>

int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return a / b; }

int main() {
    int (*operations[4])(int, int) = {
        add, subtract, multiply, divide
    };

    int a = 10, b = 5;

    for (int i = 0; i < 4; i++) {
        printf("Operation %d: %d\n", i, operations[i](a, b));
    }

    return 0;
}
```

## Callback with Context

```c
#include <stdio.h>

void process_with_context(void* data,
                         void (*callback)(void*, int)) {
    int values[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(values) / sizeof(values[0]);

    for (size_t i = 0; i < size; i++) {
        callback(data, values[i]);
    }
}

void print_prefix(void* context, int value) {
    const char* prefix = (const char*)context;
    printf("%s: %d\n", prefix, value);
}

int main() {
    const char* prefix = "Value";

    process_with_context((void*)prefix, print_prefix);

    return 0;
}
```

## Higher-Order 

```c
#include <stdio.h>
#include <stdlib.h>

typedef int (*Predicate)(int);

int* filter_and_map(int* arr, size_t size,
                   Predicate pred,
                   int (*map)(int),
                   size_t* result_size) {
    int* result = malloc(size * sizeof(int));
    if (result == NULL) return NULL;

    size_t count = 0;
    for (size_t i = 0; i < size; i++) {
        if (pred(arr[i])) {
            result[count++] = map(arr[i]);
        }
    }

    *result_size = count;
    return result;
}

bool is_positive(int x) {
    return x > 0;
}

int double_value(int x) {
    return x * 2;
}

int main() {
    int numbers[] = {-5, 3, -2, 7, 1, -4};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    size_t result_size;
    int* result = filter_and_map(numbers, size,
                               is_positive,
                               double_value,
                               &result_size);

    printf("Doubled positives: ");
    for (size_t i = 0; i < result_size; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    free(result);
    return 0;
}
```

## State Machine with Callbacks

```c
#include <stdio.h>
#include <stdbool.h>

typedef void (*StateHandler)(void);

void idle_state(void) {
    printf("Idle state\n");
}

void running_state(void) {
    printf("Running state\n");
}

void paused_state(void) {
    printf("Paused state\n");
}

StateHandler states[] = {idle_state, running_state, paused_state};
int current_state = 0;

void set_state(int new_state) {
    current_state = new_state;
}

void update(void) {
    states[current_state]();
}

int main() {
    update();

    set_state(1);
    update();

    set_state(2);
    update();

    return 0;
}
```

## Timer Callback

```c
#include <stdio.h>
#include <time.h>

typedef void (*TimerCallback)(void*);

typedef struct {
    TimerCallback callback;
    void* context;
    time_t interval;
    time_t last_trigger;
} Timer;

void timer_init(Timer* timer, TimerCallback callback,
               void* context, time_t interval) {
    timer->callback = callback;
    timer->context = context;
    timer->interval = interval;
    timer->last_trigger = time(NULL);
}

void timer_update(Timer* timer) {
    time_t now = time(NULL);

    if (difftime(now, timer->last_trigger) >= timer->interval) {
        timer->callback(timer->context);
        timer->last_trigger = now;
    }
}

void timer_callback(void* context) {
    const char* message = (const char*)context;
    printf("Timer triggered: %s\n", message);
}

int main() {
    Timer timer;
    timer_init(&timer, timer_callback,
                "Periodic task", 2);

    printf("Waiting for timer...\n");

    for (int i = 0; i < 5; i++) {
        sleep(1);
        timer_update(&timer);
    }

    return 0;
}
```

## Event Queue

```c
#include <stdio.h>
#include <stdlib.h>

typedef void (*EventHandler)(int);

typedef struct {
    int event;
    EventHandler handler;
    struct EventNode* next;
} EventNode;

EventNode* event_queue = NULL;

void enqueue_event(int event, EventHandler handler) {
    EventNode* node = malloc(sizeof(EventNode));
    node->event = event;
    node->handler = handler;
    node->next = event_queue;
    event_queue = node;
}

void process_events(void) {
    while (event_queue != NULL) {
        EventNode* node = event_queue;
        node->handler(node->event);
        event_queue = node->next;
        free(node);
    }
}

void click_handler(int event) {
    printf("Click event: %d\n", event);
}

void key_handler(int event) {
    printf("Key event: %d\n", event);
}

int main() {
    enqueue_event(1, click_handler);
    enqueue_event(2, key_handler);

    process_events();

    return 0;
}
```

## Comparator Registration

```c
#include <stdio.h>
#include <string.h>

typedef int (*Comparator)(const void*, const void*);

typedef struct {
    const char* name;
    Comparator comparator;
} TypeInfo;

int compare_int(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

int compare_string(const void* a, const void* b) {
    return strcmp(*(const char**)a, *(const char**)b);
}

TypeInfo types[] = {
    {"int", compare_int},
    {"string", compare_string}
};

void sort_generic(void* arr, size_t size, size_t elem_size,
                  const char* type_name) {
    TypeInfo* type = NULL;

    for (size_t i = 0; i < sizeof(types) / sizeof(types[0]); i++) {
        if (strcmp(types[i].name, type_name) == 0) {
            type = &types[i];
            break;
        }
    }

    if (type == NULL) {
        printf("Unknown type: %s\n", type_name);
        return;
    }

    printf("Sorting using %s comparator\n", type_name);
    // Use type->comparator for sorting
}

int main() {
    int numbers[] = {5, 2, 8, 1, 9};

    sort_generic(numbers, 5, sizeof(int), "int");

    return 0;
}
```

> **Note**: Function  provide flexibility but can be harder to debug. Use typedefs for readability.
