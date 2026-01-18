---
id: "c.algorithms.backtracking"
title: "Backtracking"
category: algorithms
difficulty: advanced
tags: [c, algorithms, backtracking, search, pruning]
keywords: [backtracking, pruning, search, constraint satisfaction]
use_cases: [puzzle solving, optimization, constraint problems]
prerequisites: [c.algorithms.recursion]
related: [c.algorithms.dynamic]
next_topics: [c.algorithms.graph]
---

# Backtracking

## N-Queens Problem

```c
#include <stdio.h>
#include <stdlib.h>

#define N 8

int board[N][N] = {0};

void print_board(void) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%c ", board[i][j] ? 'Q' : '.');
        }
        printf("\n");
    }
}

bool is_safe(int row, int col) {
    // Check row
    for (int i = 0; i < col; i++) {
        if (board[row][i]) return false;
    }

    // Check upper diagonal
    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
        if (board[i][j]) return false;
    }

    // Check lower diagonal
    for (int i = row, j = col; i < N && j < N; i++, j++) {
        if (board[i][j]) return false;
    }

    return true;
}

bool solve(int col) {
    if (col >= N) {
        return true;
    }

    for (int row = 0; row < N; row++) {
        if (is_safe(row, col)) {
            board[row][col] = 1;

            if (solve(col + 1)) {
                return true;
            }

            board[row][col] = 0;
        }
    }

    return false;
}

int main() {
    printf("Solving N-Queens for N=%d:\n", N);

    if (solve(0)) {
        print_board();
        printf("Solution found!\n");
    } else {
        printf("No solution\n");
    }

    return 0;
}
```

## Sudoku Solver

```c
#include <stdio.h>
#include <stdbool.h>

#define N 9

int grid[N][N] = {0};

void print_grid(void) {
    for (int i = 0; i < N; i++) {
        if (i > 0 && i % 3 == 0) {
            printf("---------------------\n");
        }
        for (int j = 0; j < N; j++) {
            if (j > 0 && j % 3 == 0) {
                printf("| ");
            }
            printf("%d ", grid[i][j]);
        }
        printf("|\n");
    }
    printf("---------------------\n");
}

bool is_valid(int row, int col, int num) {
    for (int x = 0; x < col; x++) {
        if (grid[row][x] == num) return false;
    }

    for (int x = 0; x < row; x++) {
        if (grid[x][col] == num) return false;
    }

    int start_row = row - row % 3;
    int start_col = col - col % 3;

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (grid[start_row + i][start_col + j] == num) {
                return false;
            }
        }
    }

    return true;
}

bool find_empty(int* row, int* col) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (grid[i][j] == 0) {
                *row = i;
                *col = j;
                return true;
            }
        }
    }
    return false;
}

bool solve(void) {
    int row, col;

    if (!find_empty(&row, &col)) {
        return true;
    }

    for (int num = 1; num <= N; num++) {
        if (is_valid(row, col, num)) {
            grid[row][col] = num;

            if (solve()) {
                return true;
            }

            grid[row][col] = 0;
        }
    }

    return false;
}

int main() {
    printf("Solving Sudoku:\n");

    // Initialize with sample puzzle
    grid[0][0] = 5; grid[0][1] = 3;
    grid[0][4] = 7;
    grid[1][0] = 6;
    grid[1][3] = 9;
    grid[1][4] = 1;
    grid[1][5] = 8;
    grid[2][1] = 9;
    grid[2][2] = 8;
    grid[2][7] = 3;
    grid[3][0] = 8;
    grid[3][5] = 6;
    grid[4][4] = 3;
    grid[4][6] = 4;
    grid[5][1] = 7;
    grid[5][5] = 9;
    grid[5][6] = 2;
    grid[5][7] = 6;
    grid[6][3] = 5;
    grid[6][4] = 9;
    grid[6][7] = 1;
    grid[7][2] = 1;
    grid[7][6] = 8;
    grid[7][7] = 4;
    grid[8][1] = 2;
    grid[8][5] = 5;
    grid[8][8] = 0;
    grid[8][6] = 3;

    print_grid();

    if (solve()) {
        printf("Solution found!\n");
        print_grid();
    } else {
        printf("No solution\n");
    }

    return 0;
}
```

## Subset Sum

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_SIZE 10

void subset_sum(int* nums, int n, int target, int index, int* subset,
             int subset_size, int current_sum) {
    if (current_sum == target) {
        printf("Found subset: {");
        for (int i = 0; i < subset_size; i++) {
            printf("%d ", subset[i]);
        }
        printf("}\n");
        return;
    }

    if (index >= n || current_sum > target) {
        return;
    }

    // Include current element
    subset[subset_size++] = nums[index];
    subset_sum(nums, n, target, index + 1, subset, subset_size,
                current_sum + nums[index]);
    subset_size--;

    // Exclude current element
    subset_sum(nums, n, target, index + 1, subset, subset_size,
                current_sum);
}

int main() {
    int nums[] = {2, 4, 6, 10};
    int n = sizeof(nums) / sizeof(nums[0]);
    int target = 16;
    int* subset = (int*)malloc(MAX_SIZE * sizeof(int));

    printf("Subsets that sum to %d:\n", target);
    subset_sum(nums, n, target, 0, subset, 0, 0);

    free(subset);

    return 0;
}
```

## Permutations with Duplicates

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void swap(char* a, char* b) {
    char temp = *a;
    *a = *b;
    *b = temp;
}

void permute_unique(char* str, int l, int r) {
    if (l == r) {
        printf("%s\n", str);
        return;
    }

    for (int i = l; i <= r; i++) {
        swap(str + l, str + i);
        permute_unique(str, l + 1, r);
        swap(str + l, str + i);
    }
}

void generate_permutations_unique(const char* str) {
    char* arr = strdup(str);
    int n = strlen(arr);

    // Sort to handle duplicates
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (arr[i] > arr[j]) {
                swap(arr + i, arr + j);
            }
        }
    }

    printf("Unique permutations of %s:\n", str);
    permute_unique(arr, 0, n - 1);

    free(arr);
}

int main() {
    generate_permutations_unique("AAB");

    return 0;
}
```

## Word Search

```c
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define SIZE 3

char board[SIZE][SIZE] = {
    {'A', 'B', 'C'},
    {'D', 'E', 'F'},
    {'G', 'H', 'I'}
};

bool exists(char word[SIZE + 1]) {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            for (int k = 0; k < SIZE; k++) {
                if (board[i][j] == word[0] &&
                    board[(i+1) % SIZE][j] == word[1] &&
                    board[(i+2) % SIZE][j] == word[2]) {
                    return true;
                }
            }
        }
    }
    return false;
}

int main() {
    char words[][SIZE + 1] = {"ABC", "BEH", "CFI"};

    printf("Board:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%c ", board[i][j]);
        }
        printf("\n");
    }

    printf("\nWord search:\n");
    for (int i = 0; i < 3; i++) {
        if (exists(words[i])) {
            printf("Found: %s\n", words[i]);
        }
    }

    return 0;
}
```

## Hamiltonian Cycle

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define V 5

int graph[V][V] = {
    {0, 1, 0, 1, 0},
    {1, 0, 1, 0, 1},
    {0, 1, 0, 1, 1},
    {1, 0, 1, 0, 1},
    {0, 1, 1, 1, 0}
};

int path[V] = {0};
bool visited[V] = {false};

bool hamiltonian_cycle_util(int pos) {
    if (pos == V - 1) {
        if (graph[pos][0] == 1 && path[V - 1] == -1) {
            path[pos] = 0;
            return true;
        }
        return false;
    }

    visited[pos] = true;

    for (int v = 0; v < V; v++) {
        if (graph[pos][v] && !visited[v]) {
            path[pos] = v;
            path[v] = -1;

            if (hamiltonian_cycle_util(v)) {
                return true;
            }

            path[v] = -1;
            visited[v] = false;
        }
    }

    visited[pos] = false;
    return false;
}

void hamiltonian_cycle(void) {
    path[0] = 0;
    path[1] = -1;

    for (int v = 1; v < V; v++) {
        path[1] = v;
        path[v] = -1;

        if (hamiltonian_cycle_util(v)) {
            printf("Hamiltonian Cycle: ");
            for (int i = 0; i < V; i++) {
                printf("%d ", path[i]);
            }
            printf("0\n");
            return;
        }

        path[v] = -1;
    }

    printf("No Hamiltonian cycle\n");
}

int main() {
    printf("Hamiltonian Cycle:\n");
    hamiltonian_cycle();

    return 0;
}
```

## Coloring Problem

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define V 4

int graph[V][V] = {
    {0, 1, 1, 1},
    {1, 0, 1, 0},
    {1, 1, 0, 1},
    {1, 0, 1, 0}
};

bool is_safe(int v, int color[], int c) {
    for (int i = 0; i < V; i++) {
        if (graph[v][i] && color[i] == c) {
            return false;
        }
    }
    return true;
}

bool graph_coloring_util(int m) {
    if (m == V) {
        return true;
    }

    int v;
    for (v = 0; v < V; v++) {
        if (color[v] == -1) {
            for (int c = 1; c <= m; c++) {
                if (is_safe(v, color, c)) {
                    color[v] = c;
                    if (graph_coloring_util(m + 1)) {
                        return true;
                    }
                    color[v] = -1;
                }
            }
            }
        }
    }

    return false;
}

void graph_coloring(void) {
    int color[V];
    for (int i = 0; i < V; i++) {
        color[i] = -1;
    }

    printf("Graph coloring:\n");
    int m = 1;

    while (!graph_coloring_util(m)) {
        m++;
        if (m > V) {
            printf("No coloring possible\n");
            return;
        }
    }

    printf("Using %d colors:\n", m);
    for (int i = 0; i < V; i++) {
        printf("Vertex %d: %d\n", i, color[i]);
    }
}

int main() {
    graph_coloring();

    return 0;
}
```

## Knight's Tour

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define SIZE 8

int dx[8] = {2, 1, -1, -2, -2, -1, 1, 2};
int dy[8] = {1, 2, 2, 1, -1, -2, -2, -1};

bool is_safe(int x, int y, int board[SIZE][SIZE]) {
    return (x >= 0 && x < SIZE && y >= 0 && y < SIZE && board[x][y] == -1);
}

bool knights_tour_util(int x, int y, int move_count, int board[SIZE][SIZE]) {
    if (move_count == SIZE * SIZE) {
        return true;
    }

    for (int i = 0; i < 8; i++) {
        int next_x = x + dx[i];
        int next_y = y + dy[i];

        if (is_safe(next_x, next_y, board)) {
            board[next_x][next_y] = move_count;

            if (knights_tour_util(next_x, next_y, move_count + 1, board)) {
                board[next_x][next_y] = -1;
                return true;
            }

            board[next_x][next_y] = -1;
        }
    }

    return false;
}

void knights_tour(void) {
    int board[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            board[i][j] = -1;
        }
    }

    int start_x = 0, start_y = 0;
    board[start_x][start_y] = 0;

    printf("Knight's Tour starting at (%d, %d):\n", start_x, start_y);

    if (knights_tour_util(start_x, start_y, 1, board)) {
        printf("Tour found!\n");
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                if (board[i][j] != -1) {
                    printf("%2d ", board[i][j]);
                } else {
                    printf("    ");
                }
                if (j == SIZE - 1) printf("\n");
            }
        }
    } else {
        printf("No tour found\n");
    }
}

int main() {
    knights_tour();

    return 0;
}
```

## Maze Solving

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define SIZE 5

int maze[SIZE][SIZE] = {
    {0, 1, 0, 0, 0},
    {0, 1, 0, 1, 0},
    {0, 0, 0, 1, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0}
};

bool solve_maze(int x, int y, int solution[SIZE][SIZE]) {
    if (x == SIZE - 1 && y == SIZE - 1) {
        solution[x][y] = 1;
        return true;
    }

    if (x < 0 || x >= SIZE || y < 0 || y >= SIZE || maze[x][y] == 1 || solution[x][y] == 1) {
        return false;
    }

    solution[x][y] = 1;

    // Try right
    if (solve_maze(x + 1, y, solution)) {
        return true;
    }

    // Try down
    if (solve_maze(x, y + 1, solution)) {
        return true;
    }

    // Try left
    if (solve_maze(x - 1, y, solution)) {
        return true;
    }

    // Try up
    if (solve_maze(x, y - 1, solution)) {
        return true;
    }

    solution[x][y] = 0;
    return false;
}

void print_maze(int maze[SIZE][SIZE], int solution[SIZE][SIZE]) {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (solution[i][j] == 1) {
                printf("* ");
            } else if (maze[i][j] == 1) {
                printf("# ");
            } else {
                printf(". ");
            }
        }
        printf("\n");
    }
}

int main() {
    int solution[SIZE][SIZE] = {0};

    printf("Maze:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d ", maze[i][j]);
        }
        printf("\n");
    }

    printf("\nSolving maze...\n");
    if (solve_maze(0, 0, solution)) {
        printf("Solution found:\n");
        print_maze(maze, solution);
    } else {
        printf("No solution\n");
    }

    return 0;
}
```

## Partition Problem

```c
#include <stdio.h>
#include <stdbool.h>

#define SIZE 5

bool partition(int nums[], int n, int start, int current_sum, int target_sum, bool taken[]) {
    if (current_sum == target_sum) {
        printf("Partition: ");
        bool first = true;
        for (int i = 0; i < n; i++) {
            if (taken[i]) {
                if (!first) printf(" + ");
                printf("%d ", nums[i]);
                first = false;
            }
        }
        printf("\n");
        return true;
    }

    if (start >= n || current_sum > target_sum) {
        return false;
    }

    for (int i = start; i < n; i++) {
        if (!taken[i]) {
            taken[i] = true;
            if (partition(nums, n, i + 1, current_sum + nums[i], target_sum, taken)) {
                taken[i] = false;
                return true;
            }
            taken[i] = false;
        }
    }

    return false;
}

bool can_partition(int nums[], int n) {
    int total_sum = 0;
    for (int i = 0; i < n; i++) {
        total_sum += nums[i];
    }

    if (total_sum % 2 != 0) {
        return false;
    }

    bool* taken = (bool*)malloc(n * sizeof(bool));
    for (int i = 0; i < n; i++) {
        taken[i] = false;
    }

    bool result = partition(nums, n, 0, 0, total_sum / 2, taken);
    free(taken);

    return result;
}

int main() {
    int nums[] = {1, 5, 11, 5};
    int n = sizeof(nums) / sizeof(nums[0]);

    printf("Can partition? %s\n", can_partition(nums, n) ? "Yes" : "No");

    return 0;
}
```

> **Note**: Backtracking explores all possibilities but can be slow. Use pruning to eliminate impossible branches early.
