---
id: "c.algorithms.search"
title: "Search Algorithms"
category: algorithms
difficulty: intermediate
tags: [c, algorithms, search, binary, linear]
keywords: [search, binary, linear, interpolation]
use_cases: [data lookup, optimization, algorithms]
prerequisites: ["c.arrays"]
related: ["c.stdlib.qsort"]
next_topics: ["c.algorithms.sort"]
---

# Search Algorithms

## Linear Search

```c
#include <stdio.h>

int linear_search(int* arr, size_t size, int target) {
    for (size_t i = 0; i < size; i++) {
        if (arr[i] == target) {
            return (int)i;
        }
    }
    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = linear_search(numbers, size, 7);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Binary Search

```c
#include <stdio.h>

int binary_search(int* arr, size_t size, int target) {
    int left = 0;
    int right = (int)size - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = binary_search(numbers, size, 7);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Binary Search Recursive

```c
#include <stdio.h>

int binary_search_recursive(int* arr, int left, int right, int target) {
    if (left > right) {
        return -1;
    }

    int mid = left + (right - left) / 2;

    if (arr[mid] == target) {
        return mid;
    } else if (arr[mid] < target) {
        return binary_search_recursive(arr, mid + 1, right, target);
    } else {
        return binary_search_recursive(arr, left, mid - 1, target);
    }
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = binary_search_recursive(numbers, 0, (int)size - 1, 7);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Interpolation Search

```c
#include <stdio.h>

int interpolation_search(int* arr, size_t size, int target) {
    int left = 0;
    int right = (int)size - 1;

    while (left <= right && target >= arr[left] && target <= arr[right]) {
        if (arr[right] == arr[left]) {
            if (arr[left] == target) {
                return left;
            }
            break;
        }

        int pos = left + ((target - arr[left]) * (right - left)) / (arr[right] - arr[left]);

        if (arr[pos] == target) {
            return pos;
        } else if (arr[pos] < target) {
            left = pos + 1;
        } else {
            right = pos - 1;
        }
    }

    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = interpolation_search(numbers, size, 7);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Find All Occurrences

```c
#include <stdio.h>
#include <stdlib.h>

int* find_all(int* arr, size_t size, int target, size_t* count) {
    // Count occurrences
    *count = 0;
    for (size_t i = 0; i < size; i++) {
        if (arr[i] == target) {
            (*count)++;
        }
    }

    if (*count == 0) {
        return NULL;
    }

    // Allocate result array
    int* result = malloc(*count * sizeof(int));
    if (result == NULL) {
        return NULL;
    }

    // Fill result
    size_t j = 0;
    for (size_t i = 0; i < size; i++) {
        if (arr[i] == target) {
            result[j++] = (int)i;
        }
    }

    return result;
}

int main() {
    int numbers[] = {1, 2, 3, 2, 4, 2, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    size_t count;
    int* indices = find_all(numbers, size, 2, &count);

    if (indices != NULL) {
        printf("Found %zu occurrences at indices: ", count);
        for (size_t i = 0; i < count; i++) {
            printf("%d ", indices[i]);
        }
        printf("\n");
        free(indices);
    }

    return 0;
}
```

## Find Closest

```c
#include <stdio.h>
#include <stdlib.h>

int find_closest(int* arr, size_t size, int target) {
    if (size == 0) {
        return -1;
    }

    int closest = 0;
    int min_diff = abs(arr[0] - target);

    for (size_t i = 1; i < size; i++) {
        int diff = abs(arr[i] - target);

        if (diff < min_diff) {
            min_diff = diff;
            closest = (int)i;
        }
    }

    return closest;
}

int main() {
    int numbers[] = {1, 5, 10, 15, 20};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int target = 12;
    int index = find_closest(numbers, size, target);

    if (index != -1) {
        printf("Closest to %d is %d at index %d\n",
               target, numbers[index], index);
    }

    return 0;
}
```

## Search in 2D Array

```c
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    int row;
    int col;
} Position;

bool search_2d(int** matrix, int rows, int cols, int target,
               Position* result) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (matrix[i][j] == target) {
                result->row = i;
                result->col = j;
                return true;
            }
        }
    }
    return false;
}

int main() {
    int rows = 3, cols = 3;
    int* matrix[3] = {
        (int[]){1, 2, 3},
        (int[]){4, 5, 6},
        (int[]){7, 8, 9}
    };

    Position pos;
    if (search_2d(matrix, rows, cols, 5, &pos)) {
        printf("Found at (%d, %d)\n", pos.row, pos.col);
    }

    return 0;
}
```

## Search with Comparison Function

```c
#include <stdio.h>

typedef int (*CompareFunc)(const void*, const void*);

int compare_int(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int binary_search_generic(void* arr, size_t size, size_t elem_size,
                       const void* target, CompareFunc compare) {
    int left = 0;
    int right = (int)size - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2;
        void* mid_elem = (char*)arr + mid * elem_size;

        int cmp = compare(mid_elem, target);

        if (cmp == 0) {
            return mid;
        } else if (cmp < 0) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int target = 7;
    int result = binary_search_generic(numbers, size, sizeof(int),
                                    &target, compare_int);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    }

    return 0;
}
```

## Search with Count

```c
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    int index;
    int comparisons;
} SearchResult;

SearchResult search_with_stats(int* arr, size_t size, int target) {
    SearchResult result = {-1, 0};

    for (size_t i = 0; i < size; i++) {
        result.comparisons++;

        if (arr[i] == target) {
            result.index = (int)i;
            break;
        }
    }

    return result;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    SearchResult res = search_with_stats(numbers, size, 7);

    if (res.index != -1) {
        printf("Found at index %d after %d comparisons\n",
               res.index, res.comparisons);
    }

    return 0;
}
```

## Exponential Search

```c
#include <stdio.h>
#include <math.h>

int exponential_search(int* arr, size_t size, int target) {
    if (arr[0] == target) {
        return 0;
    }

    int i = 1;
    while (i < (int)size && arr[i] <= target) {
        i *= 2;
    }

    int left = i / 2;
    int right = (i < (int)size) ? i : (int)size - 1;

    // Binary search in range
    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = exponential_search(numbers, size, 11);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    }

    return 0;
}
```

## Jump Search

```c
#include <stdio.h>
#include <math.h>

int jump_search(int* arr, size_t size, int target) {
    int step = (int)sqrt((double)size);
    int prev = 0;

    // Find block where target may be
    while (arr[(int)fmin(step, (int)size - 1)] < target) {
        prev = step;
        step += (int)sqrt((double)size);

        if (prev >= (int)size) {
            return -1;
        }
    }

    // Linear search in block
    while (arr[prev] < target) {
        prev++;

        if (prev == (int)fmin(step, (int)size)) {
            return -1;
        }
    }

    if (arr[prev] == target) {
        return prev;
    }

    return -1;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int result = jump_search(numbers, size, 11);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    }

    return 0;
}
```

> **Note**: Binary search requires sorted array O(log n), linear search works on unsorted O(n).
