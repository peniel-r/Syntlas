---
id: "c.algorithms.combinatorics"
title: "Combinatorics"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, c.algorithms.sorting, combinatorics, permutation, combination]
keywords: [permutation, combination, factorial, binomial]
use_cases: [enumeration, probability, statistics]
prerequisites: [c.algorithms.sorting]
related: [c.algorithms.dynamic]
next_topics: [c.algorithms.numeric]
---

# Combinatorics

## Factorial

```c
#include <stdio.h>

long long factorial(int n) {
    if (n <= 1) {
        return 1;
    }

    long long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }

    return result;
}

int main() {
    for (int i = 0; i <= 10; i++) {
        printf("%d! = %lld\n", i, factorial(i));
    }

    return 0;
}
```

## Binomial Coefficient

```c
#include <stdio.h>

long long binomial(int n, int k) {
    if (k < 0 || k > n) {
        return 0;
    }

    if (k == 0 || k == n) {
        return 1;
    }

    if (k > n - k) {
        k = n - k;
    }

    long long result = 1;

    for (int i = 1; i <= k; i++) {
        result = result * (n - k + i) / i;
    }

    return result;
}

int main() {
    int n = 5;

    printf("Binomial coefficients for n=%d:\n", n);
    for (int k = 0; k <= n; k++) {
        printf("C(%d, %d) = %lld\n", n, k, binomial(n, k));
    }

    return 0;
}
```

## Permutations

```c
#include <stdio.h>
#include <string.h>

void swap(char* a, char* b) {
    char temp = *a;
    *a = *b;
    *b = temp;
}

void permute(char* str, int l, int r) {
    if (l == r) {
        printf("%s\n", str);
        return;
    }

    for (int i = l; i <= r; i++) {
        swap(str + l, str + i);
        permute(str, l + 1, r);
        swap(str + l, str + i);
    }
}

int main() {
    char str[] = "ABC";

    printf("Permutations of %s:\n", str);
    permute(str, 0, strlen(str) - 1);

    return 0;
}
```

## Combinations

```c
#include <stdio.h>
#include <stdlib.h>

void combine(char* arr, int start, int n, int r, char* data, int index) {
    if (index == r) {
        for (int i = 0; i < r; i++) {
            printf("%c ", data[i]);
        }
        printf("\n");
        return;
    }

    for (int i = start; i <= n && n - i + 1 >= r - index; i++) {
        data[index] = arr[i];
        combine(arr, i + 1, n, r, data, index + 1);
    }
}

int main() {
    char arr[] = {'A', 'B', 'C', 'D'};
    int n = sizeof(arr) / sizeof(arr[0]);
    int r = 2;

    char* data = (char*)malloc(r * sizeof(char));

    printf("Combinations of %d elements taken %d at a time:\n", n, r);
    combine(arr, 0, n - 1, r, data, 0);

    free(data);

    return 0;
}
```

## Power Set

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void print_powerset(char* set, int set_size) {
    unsigned int pow_set_size = (unsigned int)pow(2, set_size);

    printf("Power set:\n");

    for (unsigned int i = 0; i < pow_set_size; i++) {
        printf("{");

        int printed = 0;
        for (int j = 0; j < set_size; j++) {
            if (i & (1 << j)) {
                if (printed) {
                    printf(", ");
                }
                printf("%c", set[j]);
                printed = 1;
            }
        }

        printf("}\n");
    }
}

int main() {
    char set[] = {'A', 'B', 'C'};
    int set_size = sizeof(set) / sizeof(set[0]);

    print_powerset(set, set_size);

    return 0;
}
```

## Pascal's Triangle

```c
#include <stdio.h>

void pascals_triangle(int n) {
    int triangle[n + 1][n + 1];

    for (int line = 0; line <= n; line++) {
        for (int i = 0; i <= line; i++) {
            if (i == 0 || i == line) {
                triangle[line][i] = 1;
            } else {
                triangle[line][i] = triangle[line - 1][i - 1] + triangle[line - 1][i];
            }
        }
    }

    printf("Pascal's Triangle (row %d):\n", n);
    for (int line = 0; line <= n; line++) {
        for (int i = 0; i <= line; i++) {
            printf("%d ", triangle[line][i]);
        }
        printf("\n");
    }
}

int main() {
    pascals_triangle(5);

    return 0;
}
```

## N-th Permutation

```c
#include <stdio.h>
#include <stdlib.h>

int get_factoradic(int n, int fact[], int k) {
    int i = 0;

    while (n > 0 && k > 0) {
        fact[i++] = n % k;
        n /= k;
        k--;
    }

    return i;
}

void nth_permutation(int n, int k, int* result) {
    int fact[k];
    for (int i = 0; i < k; i++) {
        fact[i] = 1;
        for (int j = 2; j <= n; j++) {
            if (j <= n - i) {
                fact[i] *= j;
            }
        }
    }

    int temp[n];
    for (int i = 0; i < n; i++) {
        temp[i] = i;
    }

    for (int i = 0; i < k; i++) {
        swap(&temp[i], &temp[fact[i]]);
    }

    for (int i = 0; i < n; i++) {
        result[i] = temp[i];
    }
}

int main() {
    int n = 5;
    int k = 3;
    int result[5];

    printf("Permutation %d:\n", k);
    nth_permutation(n, k, result);

    for (int i = 0; i < n; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    return 0;
}
```

## Generate Combinations

```c
#include <stdio.h>
#include <stdlib.h>

int* generate_combinations(int n, int r) {
    if (r < 0 || r > n) {
        return NULL;
    }

    int total = 1;
    for (int i = 0; i < r; i++) {
        total *= (n - i);
    }

    int count = total;
    int* combinations = malloc(count * r * sizeof(int));

    int* indices = malloc(r * sizeof(int));
    for (int i = 0; i < r; i++) {
        indices[i] = i;
    }

    for (int row = 0; row < total; row++) {
        for (int i = r - 1; i >= 0; i--) {
            indices[i]++;

            if (indices[i] == n - 1) {
                indices[i] = 0;
            } else {
                indices[i]++;
            }
        }

        for (int i = 0; i < r; i++) {
            combinations[row * r + i] = indices[i];
        }
    }

    free(indices);

    return combinations;
}

int main() {
    int n = 5;
    int r = 3;

    int* combinations = generate_combinations(n, r);
    int total = 1;
    for (int i = 0; i < r; i++) {
        total *= (n - i);
    }

    printf("Combinations of C(%d, %d) = %d:\n", n, r, total);

    for (int row = 0; row < total; row++) {
        for (int i = 0; i < r; i++) {
            printf("%d ", combinations[row * r + i]);
        }
        printf("\n");
    }

    free(combinations);

    return 0;
}
```

## Gray Code

```c
#include <stdio.h>

int gray_code(int n) {
    return n ^ (n >> 1);
}

void generate_gray_codes(int bits) {
    int codes = (1 << bits);

    printf("Gray codes for %d bits:\n", bits);
    for (int i = 0; i < codes; i++) {
        printf("%2d: ", i);

        for (int j = bits - 1; j >= 0; j--) {
            printf("%d", (gray_code(i) >> j) & 1);
        }

        printf("\n");
    }
}

int main() {
    generate_gray_codes(3);

    return 0;
}
```

## Stern's Diatomic Series

```c
#include <stdio.h>

void sterns_diatomc_series(int n) {
    int a = 0, b = 1;
    int c;

    printf("Stern's Diatomic Series (first %d terms):\n", n);

    printf("%d ", a);
    if (n >= 2) {
        printf("%d ", b);
    }

    for (int i = 2; i < n; i++) {
        c = (i * b) ^ (i - 1) * a;
        printf("%d ", c);
        a = b;
        b = c;
    }

    printf("\n");
}

int main() {
    sterns_diatomc_series(10);

    return 0;
}
```

## Fibonacci Number

```c
#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1) {
        return n;
    }

    int a = 0, b = 1, c;

    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }

    return b;
}

int main() {
    printf("Fibonacci sequence (first 10 terms):\n");

    for (int i = 0; i < 10; i++) {
        printf("%d ", fibonacci(i));
    }

    printf("\n");

    return 0;
}
```

## Catalan Numbers

```c
#include <stdio.h>

long long catalan(int n) {
    if (n <= 1) {
        return 1;
    }

    long long cat = 0;

    for (int i = 0; i < n; i++) {
        cat = (2LL * (2 * i + 1) * cat) / (i + 2);
    }

    return cat;
}

int main() {
    printf("Catalan numbers (first 10):\n");

    for (int i = 0; i < 10; i++) {
        printf("%lld ", catalan(i));
    }

    printf("\n");

    return 0;
}
```

> **Note**: Combinatorics grows rapidly. Use appropriate data types (long long) to avoid overflow.
