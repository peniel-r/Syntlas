---
id: "c.algorithms.sorting"
title: "Sorting Algorithms"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, c.algorithms.sorting, sorting, bubble, quicksort, merge]
keywords: [sort, bubble, insertion, quicksort, mergesort]
use_cases: [data organization, optimization, c.algorithms.sorting]
prerequisites: ["c.algorithms.search"]
related: ["c.stdlib.qsort"]
next_topics: ["c.algorithms.hash"]
---

# Sorting c.algorithms.sorting

## Bubble Sort

```c
#include <stdio.h>

void bubble_sort(int* arr, size_t size) {
    for (size_t i = 0; i < size - 1; i++) {
        for (size_t j = 0; j < size - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    bubble_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Selec.stdlib.stdion Sort

```c
#include <stdio.h>

void selec.stdlib.stdion_sort(int* arr, size_t size) {
    for (size_t i = 0; i < size - 1; i++) {
        size_t min_idx = i;

        for (size_t j = i + 1; j < size; j++) {
            if (arr[j] < arr[min_idx]) {
                min_idx = j;
            }
        }

        // Swap
        int temp = arr[min_idx];
        arr[min_idx] = arr[i];
        arr[i] = temp;
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    selec.stdlib.stdion_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Insertion Sort

```c
#include <stdio.h>

void insertion_sort(int* arr, size_t size) {
    for (size_t i = 1; i < size; i++) {
        int key = arr[i];
        size_t j = i;

        while (j > 0 && arr[j - 1] > key) {
            arr[j] = arr[j - 1];
            j--;
        }

        arr[j] = key;
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    insertion_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Merge Sort

```c
#include <stdio.h>
#include <stdlib.h>

void merge(int* arr, size_t left, size_t mid, size_t right) {
    size_t n1 = mid - left + 1;
    size_t n2 = right - mid;

    int* L = malloc(n1 * sizeof(int));
    int* R = malloc(n2 * sizeof(int));

    for (size_t i = 0; i < n1; i++) {
        L[i] = arr[left + i];
    }
    for (size_t j = 0; j < n2; j++) {
        R[j] = arr[mid + 1 + j];
    }

    size_t i = 0, j = 0, k = left;

    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k++] = L[i++];
        } else {
            arr[k++] = R[j++];
        }
    }

    while (i < n1) {
        arr[k++] = L[i++];
    }
    while (j < n2) {
        arr[k++] = R[j++];
    }

    free(L);
    free(R);
}

void merge_sort(int* arr, size_t left, size_t right) {
    if (left < right) {
        size_t mid = left + (right - left) / 2;
        merge_sort(arr, left, mid);
        merge_sort(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    merge_sort(numbers, 0, size - 1);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Quick Sort

```c
#include <stdio.h>

size_t partition(int* arr, size_t low, size_t high) {
    int pivot = arr[high];
    size_t i = low - 1;

    for (size_t j = low; j < high; j++) {
        if (arr[j] < pivot) {
            i++;
            // Swap
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }

    // Swap pivot
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
}

void quick_sort(int* arr, size_t low, size_t high) {
    if (low < high) {
        size_t pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    quick_sort(numbers, 0, size - 1);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Counting Sort

```c
#include <stdio.h>
#include <stdlib.h>

void counting_sort(int* arr, size_t size, int max_value) {
    int* count = calloc(max_value + 1, sizeof(int));
    int* output = malloc(size * sizeof(int));

    for (size_t i = 0; i < size; i++) {
        count[arr[i]]++;
    }

    for (int i = 1; i <= max_value; i++) {
        count[i] += count[i - 1];
    }

    for (int i = (int)size - 1; i >= 0; i--) {
        output[count[arr[i]] - 1] = arr[i];
        count[arr[i]]--;
    }

    for (size_t i = 0; i < size; i++) {
        arr[i] = output[i];
    }

    free(count);
    free(output);
}

int main() {
    int numbers[] = {4, 2, 2, 8, 3, 3, 1};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    counting_sort(numbers, size, 8);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Radix Sort

```c
#include <stdio.h>
#include <stdlib.h>

void counting_sort_by_digit(int* arr, size_t size, int exp) {
    int* output = malloc(size * sizeof(int));
    int count[10] = {0};

    for (size_t i = 0; i < size; i++) {
        count[(arr[i] / exp) % 10]++;
    }

    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }

    for (int i = (int)size - 1; i >= 0; i--) {
        output[count[(arr[i] / exp) % 10] - 1] = arr[i];
        count[(arr[i] / exp) % 10]--;
    }

    for (size_t i = 0; i < size; i++) {
        arr[i] = output[i];
    }

    free(output);
}

void radix_sort(int* arr, size_t size) {
    int max = arr[0];
    for (size_t i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }

    for (int exp = 1; max / exp > 0; exp *= 10) {
        counting_sort_by_digit(arr, size, exp);
    }
}

int main() {
    int numbers[] = {170, 45, 75, 90, 802, 24, 2, 66};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    radix_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Shell Sort

```c
#include <stdio.h>

void shell_sort(int* arr, size_t size) {
    for (size_t gap = size / 2; gap > 0; gap /= 2) {
        for (size_t i = gap; i < size; i++) {
            int temp = arr[i];
            size_t j;

            for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
                arr[j] = arr[j - gap];
            }

            arr[j] = temp;
        }
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    shell_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Heap Sort

```c
#include <stdio.h>

void heapify(int* arr, size_t size, size_t i) {
    size_t largest = i;
    size_t left = 2 * i + 1;
    size_t right = 2 * i + 2;

    if (left < size && arr[left] > arr[largest]) {
        largest = left;
    }

    if (right < size && arr[right] > arr[largest]) {
        largest = right;
    }

    if (largest != i) {
        // Swap
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;

        heapify(arr, size, largest);
    }
}

void heap_sort(int* arr, size_t size) {
    // Build max heap
    for (int i = (int)size / 2 - 1; i >= 0; i--) {
        heapify(arr, size, i);
    }

    // Extract elements
    for (int i = (int)size - 1; i > 0; i--) {
        // Swap
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;

        heapify(arr, i, 0);
    }
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    heap_sort(numbers, size);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Sort with Comparison Function

```c
#include <stdio.h>

typedef int (*CompareFunc)(const void*, const void*);

void generic_bubble_sort(void* arr, size_t size, size_t elem_size,
                         CompareFunc compare) {
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

int compare_int(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int main() {
    int numbers[] = {64, 34, 25, 12, 22, 11, 90};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    generic_bubble_sort(numbers, size, sizeof(int), compare_int);

    printf("Sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Stable Sort

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int value;
    int original_index;
} StableElement;

void stable_sort(StableElement* arr, size_t size) {
    for (size_t i = 0; i < size - 1; i++) {
        for (size_t j = 0; j < size - i - 1; j++) {
            if (arr[j].value > arr[j + 1].value ||
                (arr[j].value == arr[j + 1].value &&
                 arr[j].original_index > arr[j + 1].original_index)) {
                // Swap
                StableElement temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int main() {
    StableElement elements[] = {
        {3, 0}, {1, 1}, {2, 2}, {1, 3}
    };
    size_t size = sizeof(elements) / sizeof(elements[0]);

    stable_sort(elements, size);

    printf("Stable sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d(%d) ", elements[i].value, elements[i].original_index);
    }
    printf("\n");

    return 0;
}
```

> **Note**: Quicksort O(n log n) average, Merge sort O(n log n) worst, Bubble sort O(n²) worst.
