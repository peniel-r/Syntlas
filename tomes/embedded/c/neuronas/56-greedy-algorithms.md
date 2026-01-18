---
id: "c.algorithms.greedy"
title: "Greedy Algorithms"
category: c.algorithms.sorting
difficulty: intermediate
tags: [c, c.algorithms.sorting, greedy, optimization]
keywords: [greedy, algorithm, optimisation, scheduling]
use_cases: [resource allocation, scheduling, pathfinding]
prerequisites: ["c.algorithms.sorting"]
related: ["c.algorithms.dynamic"]
next_topics: ["c.algorithms.hash"]
---

# Greedy c.algorithms.sorting

## Activity Selec.stdlib.stdion

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int start;
    int finish;
} Activity;

int compare_finish(const void* a, const void* b) {
    return ((Activity*)a)->finish - ((Activity*)b)->finish;
}

void activity_selec.stdlib.stdion(Activity* activities, int n) {
    qsort(activities, n, sizeof(Activity), compare_finish);

    printf("Selected activities:\n");

    int i = 0;
    int count = 0;
    printf("Activity %d: [%d, %d]\n", count++, activities[i].start, activities[i].finish);

    for (int j = 1; j < n; j++) {
        if (activities[j].start >= activities[i].finish) {
            printf("Activity %d: [%d, %d]\n", count++, activities[j].start, activities[j].finish);
            i = j;
        }
    }
}

int main() {
    Activity activities[] = {
        {1, 3}, {2, 5}, {0, 6}, {5, 7}, {8, 9}, {5, 9}
    };
    int n = sizeof(activities) / sizeof(activities[0]);

    activity_selec.stdlib.stdion(activities, n);

    return 0;
}
```

## Huffman Coding

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TREE_HT 100

typedef struct Node {
    char ch;
    int freq;
    struct Node* left;
    struct Node* right;
} Node;

typedef struct {
    char* array;
    int top;
} MinHeap;

Node* newNode(char ch, int freq) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->ch = ch;
    node->freq = freq;
    node->left = node->right = NULL;
    return node;
}

MinHeap* createMinHeap(int capacity) {
    MinHeap* heap = (MinHeap*)malloc(sizeof(MinHeap));
    heap->array = (char*)malloc(capacity * sizeof(char));
    heap->top = 0;
    return heap;
}

void swapNodes(Node** a, Node** b) {
    Node* t = *a;
    *a = *b;
    *b = t;
}

void buildHuffmanTree(const char* text) {
    int freq[256] = {0};

    for (int i = 0; text[i] != '\0'; i++) {
        freq[(unsigned char)text[i]]++;
    }

    printf("Character frequencies:\n");
    for (int i = 0; i < 256; i++) {
        if (freq[i] > 0) {
            printf("'%c': %d\n", i, freq[i]);
        }
    }
}

int main() {
    const char* text = "this is an example for huffman encoding";

    buildHuffmanTree(text);

    return 0;
}
```

## Fractional Knapsack

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int value;
    int weight;
    double ratio;
} Item;

int compare_ratio(const void* a, const void* b) {
    Item* itemA = (Item*)a;
    Item* itemB = (Item*)b;

    if (itemB->ratio > itemA->ratio) return 1;
    return -1;
}

double fractional_knapsack(Item* items, int n, int capacity) {
    for (int i = 0; i < n; i++) {
        items[i].ratio = (double)items[i].value / items[i].weight;
    }

    qsort(items, n, sizeof(Item), compare_ratio);

    double total_value = 0.0;

    printf("Items added to knapsack:\n");

    for (int i = 0; i < n; i++) {
        if (capacity == 0) break;

        int weight_taken = (items[i].weight <= capacity) ?
                        items[i].weight : capacity;

        double value_taken = (double)weight_taken / items[i].weight * items[i].value;

        total_value += value_taken;
        capacity -= weight_taken;

        printf("Item %d: weight=%d, value=%.2f\n", i, weight_taken, value_taken);
    }

    return total_value;
}

int main() {
    Item items[] = {
        {60, 10, 0}, {100, 20, 0}, {120, 30, 0}
    };
    int n = sizeof(items) / sizeof(items[0]);
    int capacity = 50;

    double max_value = fractional_knapsack(items, n, capacity);

    printf("\nMaximum value: %.2f\n", max_value);

    return 0;
}
```

## Job Sequencing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char id[10];
    int deadline;
    int profit;
} Job;

int compare_profit(const void* a, const void* b) {
    return ((Job*)b)->profit - ((Job*)a)->profit;
}

void job_sequencing(Job* jobs, int n) {
    qsort(jobs, n, sizeof(Job), compare_profit);

    int max_deadline = 0;
    for (int i = 0; i < n; i++) {
        if (jobs[i].deadline > max_deadline) {
            max_deadline = jobs[i].deadline;
        }
    }

    int* slots = (int*)calloc(max_deadline + 1, sizeof(int));
    int total_profit = 0;

    printf("Job sequence:\n");

    for (int i = 0; i < n; i++) {
        for (int j = jobs[i].deadline; j > 0; j--) {
            if (slots[j] == 0) {
                slots[j] = 1;
                total_profit += jobs[i].profit;
                printf("Job %s: deadline=%d, profit=%d\n",
                       jobs[i].id, jobs[i].deadline, jobs[i].profit);
                break;
            }
        }
    }

    free(slots);

    printf("\nTotal profit: %d\n", total_profit);
}

int main() {
    Job jobs[] = {
        {"J1", 2, 100}, {"J2", 1, 19}, {"J3", 2, 27},
        {"J4", 1, 25}, {"J5", 3, 15}
    };
    int n = sizeof(jobs) / sizeof(jobs[0]);

    job_sequencing(jobs, n);

    return 0;
}
```

## Coin Change (Greedy)

```c
#include <stdio.h>
#include <stdlib.h>

void coin_change_greedy(int amount, int* coins, int n) {
    qsort(coins, n, sizeof(int),
           [](const void* a, const void* b) {
               return *(int*)b - *(int*)a;
           });

    printf("Coins used: ");

    for (int i = 0; i < n; i++) {
        while (amount >= coins[i]) {
            printf("%d ", coins[i]);
            amount -= coins[i];
        }
    }

    printf("\n");
}

int main() {
    int amount = 43;
    int coins[] = {1, 2, 5, 10, 20, 50};
    int n = sizeof(coins) / sizeof(coins[0]);

    coin_change_greedy(amount, coins, n);

    return 0;
}
```

## Minimum Spanning Tree (Prim's)

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define V 5

typedef struct {
    int parent;
    int key;
    bool mst_set;
} PrimMST;

int prim_mst(int graph[V][V]) {
    PrimMST prim[V];

    for (int i = 0; i < V; i++) {
        prim[i].key = INT_MAX;
        prim[i].parent = -1;
        prim[i].mst_set = false;
    }

    prim[0].key = 0;

    for (int count = 0; count < V - 1; count++) {
        int min = INT_MAX, u;

        for (int v = 0; v < V; v++) {
            if (!prim[v].mst_set && prim[v].key < min) {
                min = prim[v].key;
                u = v;
            }
        }

        prim[u].mst_set = true;

        printf("Edge %d - %d\n", prim[u].parent, u);

        for (int v = 0; v < V; v++) {
            if (graph[u][v] && !prim[v].mst_set &&
                graph[u][v] < prim[v].key) {
                prim[v].parent = u;
                prim[v].key = graph[u][v];
            }
        }
    }

    int total_weight = 0;
    printf("\nMST edges:\n");
    for (int i = 1; i < V; i++) {
        printf("%d - %d (%d)\n", prim[i].parent, i, prim[i].key);
        total_weight += prim[i].key;
    }

    return total_weight;
}

int main() {
    int graph[V][V] = {
        {0, 2, 0, 6, 0},
        {2, 0, 3, 8, 5},
        {0, 3, 0, 0, 7},
        {6, 8, 0, 0, 9},
        {0, 5, 7, 9, 0}
    };

    printf("Minimum Spanning Tree:\n");
    prim_mst(graph);

    return 0;
}
```

## Dijkstra's Shortest Path

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define V 9

int dijkstra(int graph[V][V], int src) {
    int dist[V];
    bool spt_set[V];

    for (int i = 0; i < V; i++) {
        dist[i] = INT_MAX;
        spt_set[i] = false;
    }

    dist[src] = 0;

    for (int count = 0; count < V - 1; count++) {
        int min = INT_MAX, u;

        for (int v = 0; v < V; v++) {
            if (!spt_set[v] && dist[v] <= min) {
                min = dist[v];
                u = v;
            }
        }

        spt_set[u] = true;

        for (int v = 0; v < V; v++) {
            if (!spt_set[v] && graph[u][v] &&
                dist[u] != INT_MAX &&
                dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
            }
        }
    }

    printf("Vertex\tDistance from Source\n");
    for (int i = 0; i < V; i++) {
        printf("%d\t\t%d\n", i, dist[i]);
    }

    return 0;
}

int main() {
    int graph[V][V] = {
        {0, 4, 0, 0, 0, 0, 0, 8, 0},
        {4, 0, 8, 0, 0, 0, 0, 11, 0},
        {0, 8, 0, 7, 0, 4, 0, 0, 2},
        {0, 0, 7, 0, 9, 14, 0, 0, 0},
        {0, 0, 0, 9, 0, 10, 0, 0, 0},
        {0, 0, 4, 14, 10, 0, 2, 0, 0},
        {0, 0, 0, 0, 0, 2, 0, 1, 6},
        {8, 11, 0, 0, 0, 0, 1, 0, 7},
        {0, 0, 2, 0, 0, 0, 6, 7, 0}
    };

    printf("Dijkstra's shortest path from source 0:\n");
    dijkstra(graph, 0);

    return 0;
}
```

## Kruskal's Algorithm

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define V 4
#define E 5

typedef struct {
    int src, dest, weight;
} Edge;

typedef struct {
    int parent;
    int rank;
} Subset;

int find(Subset subsets[], int i) {
    if (subsets[i].parent != i)
        subsets[i].parent = find(subsets, subsets[i].parent);
    return subsets[i].parent;
}

void union_subsets(Subset subsets[], int x, int y) {
    int xroot = find(subsets, x);
    int yroot = find(subsets, y);

    if (subsets[xroot].rank < subsets[yroot].rank) {
        subsets[xroot].parent = yroot;
    } else if (subsets[xroot].rank > subsets[yroot].rank) {
        subsets[yroot].parent = xroot;
    } else {
        subsets[yroot].parent = xroot;
        subsets[xroot].rank++;
    }
}

int kruskal(Edge edges[], int e) {
    Edge result[V];
    int e_count = 0;

    qsort(edges, e, sizeof(Edge),
           [](const void* a, const void* b) {
               return ((Edge*)a)->weight - ((Edge*)b)->weight;
           });

    Subset* subsets = (Subset*)malloc(V * sizeof(Subset));

    for (int v = 0; v < V; ++v) {
        subsets[v].parent = v;
        subsets[v].rank = 0;
    }

    int i = 0;
    while (e_count < V - 1 && i < e) {
        Edge next_edge = edges[i++];

        int x = find(subsets, next_edge.src);
        int y = find(subsets, next_edge.dest);

        if (x != y) {
            result[e_count++] = next_edge;
            union_subsets(subsets, x, y);
        }
    }

    printf("Kruskal's MST:\n");
    for (i = 0; i < e_count; ++i) {
        printf("%d -- %d == %d\n", result[i].src,
               result[i].dest, result[i].weight);
    }

    free(subsets);
    return 0;
}

int main() {
    Edge edges[] = {
        {0, 1, 10}, {0, 2, 6}, {0, 3, 5},
        {1, 3, 15}, {2, 3, 4}
    };
    int e = sizeof(edges) / sizeof(edges[0]);

    kruskal(edges, e);

    return 0;
}
```

> **Note**: Greedy c.algorithms.sorting make locally optimal choices. They don't always find global optimal but are often close and O(n log n).
