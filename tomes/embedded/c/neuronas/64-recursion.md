---
id: "c.algorithms.recursion"
title: "Recursive Algorithms"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, c.algorithms.sorting, recursion, backtracking, divide-and-conquer]
keywords: [recursion, backtracking, divide and conquer, tail recursion]
use_cases: [tree traversal, combinatorial problems, optimization]
prerequisites: [c.functions]
related: [c.algorithms.dynamic]
next_topics: [c.algorithms.backtracking]
---

# Recursive c.algorithms.sorting

## Basic Recursion

```c
#include <stdio.h>

void countdown(int n) {
    if (n < 0) {
        printf("Done!\n");
        return;
    }

    printf("%d...\n", n);
    countdown(n - 1);
}

int main() {
    countdown(5);

    return 0;
}
```

## Tail Recursion

```c
#include <stdio.h>

int factorial_tail(int n, int accumulator) {
    if (n <= 1) {
        return accumulator;
    }

    return factorial_tail(n - 1, n * accumulator);
}

int factorial(int n) {
    return factorial_tail(n, 1);
}

int main() {
    printf("5! = %d\n", factorial(5));

    return 0;
}
```

## Tower of Hanoi

```c
#include <stdio.h>

void tower_of_hanoi(int n, char from, char to, char auxiliary) {
    if (n == 1) {
        printf("Move disk 1 from %c to %c\n", from, to);
        return;
    }

    tower_of_hanoi(n - 1, from, auxiliary, to);
    printf("Move disk %d from %c to %c\n", n, from, to);
    tower_of_hanoi(n - 1, auxiliary, to, from);
}

int main() {
    int n = 3;

    printf("Tower of Hanoi with %d disks:\n", n);
    tower_of_hanoi(n, 'A', 'C', 'B');

    return 0;
}
```

## Binary Search (Recursive)

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
    int arr[] = {1, 3, 5, 7, 9, 11, 13};
    int size = sizeof(arr) / sizeof(arr[0]);

    int result = binary_search_recursive(arr, 0, size - 1, 7);

    if (result != -1) {
        printf("Found at index: %d\n", result);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Sum of Array (Recursive)

```c
#include <stdio.h>

int array_sum_recursive(int* arr, int n) {
    if (n <= 0) {
        return 0;
    }

    return arr[n - 1] + array_sum_recursive(arr, n - 1);
}

int main() {
    int arr[] = {1, 2, 3, 4, 5};

    printf("Sum: %d\n", array_sum_recursive(arr, sizeof(arr) / sizeof(arr[0])));

    return 0;
}
}
```

## Maximum in Array (Recursive)

```c
#include <stdio.h>
#include <limits.h>

int array_max_recursive(int* arr, int n) {
    if (n == 1) {
        return arr[0];
    }

    int max_of_rest = array_max_recursive(arr, n - 1);
    return arr[n - 1] > max_of_rest ? arr[n - 1] : max_of_rest;
}

int main() {
    int arr[] = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    int size = sizeof(arr) / sizeof(arr[0]);

    printf("Max: %d\n", array_max_recursive(arr, size));

    return 0;
}
```

## String Palindrome (Recursive)

```c
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool is_palindrome_recursive(const char* str, int left, int right) {
    if (left >= right) {
        return true;
    }

    if (str[left] != str[right]) {
        return false;
    }

    return is_palindrome_recursive(str, left + 1, right - 1);
}

bool is_palindrome(const char* str) {
    return is_palindrome_recursive(str, 0, strlen(str) - 1);
}

int main() {
    const char* words[] = {"racecar", "hello", "level"};

    for (int i = 0; i < 3; i++) {
        printf("'%s': %s\n", words[i], is_palindrome(words[i]) ? "palindrome" : "not palindrome");
    }

    return 0;
}
```

## Generate Parentheses

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void generate_parentheses(int n, int open, int close, char* str, int pos) {
    if (close == n) {
        str[pos] = '\0';
        printf("%s\n", str);
        return;
    }

    if (open < n) {
        str[pos] = '(';
        generate_parentheses(n, open + 1, close, str, pos + 1);
    }

    if (close < open) {
        str[pos] = ')';
        generate_parentheses(n, open, close + 1, str, pos + 1);
    }
}

void print_parentheses(int n) {
    if (n > 0) {
        char* str = (char*)malloc(2 * n * sizeof(char));
        str[2 * n - 1] = '\0';
        generate_parentheses(n, 0, 0, str, 0);
        free(str);
    }
}

int main() {
    printf("Parentheses combinations for n=3:\n");
    print_parentheses(3);

    return 0;
}
```

## Subsets Generation

```c
#include <stdio.h>
#include <stdlib.h>

void subsets_recursive(int* arr, int n, int index, int* subset, int subset_size) {
    if (index == n) {
        printf("{");
        for (int i = 0; i < subset_size; i++) {
            if (i > 0) printf(", ");
            printf("%d", subset[i]);
        }
        printf("}\n");
        return;
    }

    subset[subset_size] = arr[index];
    subsets_recursive(arr, n, index + 1, subset, subset_size + 1);
    subsets_recursive(arr, n, index + 1, subset, subset_size);
}

int main() {
    int arr[] = {1, 2, 3};
    int n = sizeof(arr) / sizeof(arr[0]);
    int* subset = (int*)malloc(n * sizeof(int));

    printf("Subsets:\n");
    subsets_recursive(arr, n, 0, subset, 0);

    free(subset);

    return 0;
}
```

## Permutations (Recursive)

```c
#include <stdio.h>
#include <string.h>

void swap(char* a, char* b) {
    char temp = *a;
    *a = *b;
    *b = temp;
}

void permutations(char* arr, int l, int r) {
    if (l == r) {
        printf("%s\n", arr);
        return;
    }

    for (int i = l; i <= r; i++) {
        swap(arr + l, arr + i);
        permutations(arr, l + 1, r);
        swap(arr + l, arr + i);
    }
}

void generate_permutations(const char* str) {
    char* arr = strdup(str);
    int n = strlen(arr);

    printf("Permutations of %s:\n", str);
    permutations(arr, 0, n - 1);

    free(arr);
}

int main() {
    generate_permutations("ABC");

    return 0;
}
}

## N-Queens (Backtracking)

```c
#include <stdio.h>
#include <stdlib.h>

#define N 4

bool is_safe(int board[N][N], int row, int col) {
    for (int i = 0; i < col; i++) {
        if (board[row][i]) return false;
    }

    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
        if (board[i][j]) return false;
    }

    for (int i = row, j = col; i >= 0 && j < N; i--, j++) {
        if (board[i][j]) return false;
    }

    return true;
}

void solve_nqueens(int board[N][N], int col) {
    if (col >= N) {
        printf("Solution:\n");
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                printf("%d ", board[i][j]);
            }
            printf("\n");
        }
        return;
    }

    for (int i = 0; i < N; i++) {
        if (is_safe(board, i, col)) {
            board[i][col] = 1;
            solve_nqueens(board, col + 1);
            board[i][col] = 0;
        }
    }
}

int main() {
    int board[N][N] = {0};

    printf("Solving N-Queens (N=%d):\n", N);
    solve_nqueens(board, 0);

    return 0;
}
```

## Sudoku Solver (Simplified)

```c
#include <stdio.h>
#include <stdbool.h>

#define N 4

void print_board(int board[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%d ", board[i][j]);
        }
        printf("\n");
    }
}

bool is_valid(int board[N][N], int row, int col, int num) {
    for (int x = 0; x < col; x++) {
        if (board[row][x] == num) return false;
    }

    for (int x = 0; x < row; x++) {
        if (board[x][col] == num) return false;
    }

    int start_row = row - row % 3;
    int start_col = col - col % 3;

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[start_row + i][start_col + j] == num) {
                return false;
            }
        }
    }

    return true;
}

bool solve_sudoku(int board[N][N]) {
    for (int row = 0; row < N; row++) {
        for (int col = 0; col < N; col++) {
            if (board[row][col] == 0) {
                for (int num = 1; num <= N; num++) {
                    if (is_valid(board, row, col, num)) {
                        board[row][col] = num;

                        if (solve_sudoku(board)) {
                            return true;
                        }

                        board[row][col] = 0;
                    }
                }

                return false;
            }
        }
    }

    return true;
}

int main() {
    int board[N][N] = {
        {1, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 3, 0},
        {0, 0, 0, 4}
    };

    printf("Solving simplified Sudoku (4x4):\n");

    if (solve_sudoku(board)) {
        printf("Solution found:\n");
        print_board(board);
    } else {
        printf("No solution\n");
    }

    return 0;
}
```

## Tree Traversal (Recursive)

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;

TreeNode* create_node(int data) {
    TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

void preorder(TreeNode* root) {
    if (root == NULL) {
        return;
    }

    printf("%d ", root->data);
    preorder(root->left);
    preorder(root->right);
}

void inorder(TreeNode* root) {
    if (root == NULL) {
        return;
    }

    inorder(root->left);
    printf("%d ", root->data);
    inorder(root->right);
}

void postorder(TreeNode* root) {
    if (root == NULL) {
        return;
    }

    postorder(root->left);
    postorder(root->right);
    printf("%d ", root->data);
}

int main() {
    TreeNode* root = create_node(1);
    root->left = create_node(2);
    root->right = create_node(3);
    root->left->left = create_node(4);
    root->left->right = create_node(5);

    printf("Preorder: ");
    preorder(root);
    printf("\n");

    printf("Inorder: ");
    inorder(root);
    printf("\n");

    printf("Postorder: ");
    postorder(root);
    printf("\n");

    return 0;
}
```

## Merge Sort (Recursive)

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void merge(int* arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    int* L = (int*)malloc(n1 * sizeof(int));
    int* R = (int*)malloc(n2 * sizeof(int));

    for (int i = 0; i < n1; i++) {
        L[i] = arr[left + i];
    }

    for (int i = 0; i < n2; i++) {
        R[i] = arr[mid + 1 + i];
    }

    int i = 0, j = 0, k = left;

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

void merge_sort_recursive(int* arr, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort_recursive(arr, left, mid);
        merge_sort_recursive(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

int main() {
    int arr[] = {12, 11, 13, 5, 6, 7};
    int n = sizeof(arr) / sizeof(arr[0]);

    printf("Original: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    merge_sort_recursive(arr, 0, n - 1);

    printf("Sorted: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    return 0;
}
```

> **Note**: Recursion can cause stack overflow for deep recursion. Use tail recursion or convert to iteration when possible.
