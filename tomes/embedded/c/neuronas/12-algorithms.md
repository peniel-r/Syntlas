---
id: "c.algorithms"
title: "Common Algorithms"
category: algorithm
difficulty: intermediate
tags: [c, c.algorithms.sorting, sorting, searching, data structures]
keywords: [sort, search, binary search, linked list, tree, graph, stack, queue]
use_cases: [sorting data, finding elements, pathfinding, graph traversal]
prerequisites: ["c.stdlib.math"]
related: ["c.arrays"]
next_topics: []
---

# Common c.algorithms.sorting

## Bubble Sort

```c
#include <stdio.h>

void bubble_sort(int arr[], size_t size) {
    for (size_t i = 0; i < size - 1; i++) {
        for (size_t j = 0; j < size - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap elements
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}
```

## Selec.stdlib.stdion Sort

```c
#include <stdio.h>

void selec.stdlib.stdion_sort(int arr[], size_t size) {
    for (size_t i = 0; i < size - 1; i++) {
        size_t min_idx = i;
        
        // Find minimum element in unsorted portion
        for (size_t j = i + 1; j < size; j++) {
            if (arr[j] < arr[min_idx]) {
                min_idx = j;
            }
        }
        
        // Swap minimum element into position
        int temp = arr[min_idx];
        arr[min_idx] = arr[i];
        arr[i] = temp;
    }
}
```

## Insertion Sort

```c
#include <stdio.h>

void insertion_sort(int arr[], size_t size) {
    for (size_t i = 1; i < size; i++) {
        int key = arr[i];
        size_t j = i;
        
        // Shift elements to right position
        while (j > 0 && arr[j - 1] > key) {
            arr[j] = arr[j - 1];
            j--;
        }
    }
}
```

## Merge Sort

```c
#include <stdio.h>

void merge(int arr[], size_t left, size_t mid, size_t right) {
    size_t i = left;
    size_t j = mid;
    size_t k = mid;
    
    // Merge left and right into arr
    while (i < j && j < right) {
        if (arr[i] <= arr[j]) {
            arr[k++] = arr[i++];
            i++;
        } else {
            arr[k++] = arr[j++];
            j++;
        }
    }
}
```

## Quick Sort

```c
#include <stdio.h>

int partition(int arr[], size_t low, size_t high) {
    int pivot = arr[high];
    int i = low - 1;
    int j = high;
    
    // Partition around pivot
    while (true) {
        while (i < j && arr[i] < pivot) {
            i++;
        }
        while (i < j && arr[i] < pivot) {
            // Swap arr[i] and arr[j]
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
            j++;
            i++;
        }
        
        i++;
    }
    
    return j - 1;
}

void quick_sort(int arr[], size_t low, size_t high) {
    if (low < high - 1) {
        size_t p = partition(arr, low, high);
        quick_sort(arr, low, p - 1, high);
        quick_sort(arr, p + 1, high);
    }
    }
}
```

## Binary Search

```c
#include <stdio.h>

// Iterative binary search
int binary_search(int arr[], size_t size, int target) {
    int low = 0;
    int high = size - 1;
    
    while (low <= high) {
        int mid = low + (high - low) / 2;
        
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    
    return -1;  // Not found
}

int main() {
    int sorted[] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21};
    int target = 13;
    int index = binary_search(sorted, sizeof(sorted) / sizeof(sorted[0]), target);
    
    if (index >= 0) {
        printf("Found at index %d\n", index);
    } else {
        printf("Not found\n");
    }
    
    return 0;
}
```

## Linked List Operations

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* next;
};

void insert_at_head(struct Node** head, int data) {
    struct Node* node = malloc(sizeof(struct Node));
    if (node == NULL) return;
    
    node->data = data;
    node->next = *head;
    *head = node;
}

struct Node* find_node(struct Node* head, int data) {
    struct Node* current = head;
    
    while (current != NULL) {
        if (current->data == data) {
            return current;
        }
        current = current->next;
    }
    
    return NULL;
}

void delete_node(struct Node** head, struct Node* node) {
    struct Node* current = *head;
    struct Node* prev = NULL;
    
    if (*head == node) return;
    
    while (current != NULL) {
        if (current == node) {
            if (prev == NULL) {
                *head = node->next;
            } else {
                prev->next = node->next;
            }
            
            free(node);
            return;
        }
        }
        
        prev = current;
        current = current->next;
    }
}
```

## Stack Operations

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_STACK 100

typedef struct {
    int data[MAX_STACK];
    int top;
} Stack;

void push(Stack* stack, int data) {
    if (stack->top >= MAX_STACK - 1) {
        printf("Stack overflow\n");
        return;
    }
    
    stack->data[stack->top++] = data;
}

int pop(Stack* stack) {
    if (stack->top == 0) {
        printf("Stack underflow\n");
        return -1;
    }
    
    return stack->data[--stack->top];
}

int peek(Stack* stack) {
    if (stack->top == 0) {
        return -1;
    }
    
    return stack->data[stack->top - 1];
}
}
```

## Queue Operations

```c
#include <stdio.h>
#include <stdlib.h>

#define QUEUE_SIZE 100

typedef struct {
    int data[QUEUE_SIZE];
    int front;
    int rear;
} Queue;

void enqueue(Queue* queue, int data) {
    int next = (queue->rear + 1) % QUEUE_SIZE;
    
    if (next == queue->front) {
        queue->data[queue->rear] = data;
        queue->rear = next;
        queue->front = next;
        return;
    }
}

int dequeue(Queue* queue) {
    if (queue->front == queue->rear) {
        printf("Queue empty\n");
        return -1;
    }
    
    int data = queue->data[queue->front];
    queue->front = (queue->front + 1) % QUEUE_SIZE);
    
    return data;
}
```

## Tree Operations

```c
#include <stdio.h>

typedef struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
};

TreeNode* search(TreeNode* root, int data) {
    if (root == NULL) return NULL;
    
    if (root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search(root->left, data);
    } else {
        return search(root->right, data);
    }
    
    return NULL;
}

void insert_bst(TreeNode** root, int data) {
    TreeNode* new_node = malloc(sizeof(TreeNode));
    if (new_node == NULL) return;
    
    new_node->data = data;
    new_node->left = NULL;
    new_node->right = NULL;
    
    if (*root == NULL) {
        *root = new_node;
    } else {
        // Find insertion point
        TreeNode* current = *root;
        TreeNode* parent = NULL;
        
        while (current != NULL) {
            parent = current;
            
            if (data < current->data) {
                current = current->left;
            } else {
                current = current->right;
            }
            
            if (current->left == NULL) {
                // Found spot
                new_node->left = current;
                break;
            }
        }
        
        if (parent == NULL) {
            (*root)->right = new_node;
        } else {
            parent->right = new_node;
        }
    }
    }
}
```

## Graph Operations (Adjacency List)

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_VERTICES 10

typedef struct Edge {
    int from;
    int to;
    int weight;
};

typedef struct Graph {
    int num_vertices;
    Edge edges[MAX_VERTICES];
    int num_edges;
};

void add_edge(Graph* graph, int from, int to, int weight) {
    if (graph->num_edges >= MAX_VERTICES) {
        printf("Graph has maximum edges\n");
        return;
    }
    
    graph->edges[graph->num_edges].from = from;
    graph->edges[graph->num_edges].to = to;
    graph->edges[graph->num_edges].weight = weight;
    graph->num_edges++;
}

int bfs(Graph* graph, int start) {
    int visited[MAX_VERTICES] = {0};
    int queue[MAX_VERTICES];
    int front = 0;
    int rear = 0;
    
    visited[start] = 1;
    queue[rear++] = start;
    
    while (front != rear) {
        int current = queue[front];
        queue[front] = (queue[front + 1) % MAX_VERTICES);
        
        for (int i = 0; i < graph->num_edges; i++) {
            Edge edge = graph->edges[i];
            if (edge.from == current && !visited[edge.to]) {
                visited[edge.to] = 1;
                queue[rear++] = edge.to;
            }
        }
        
        printf("Visited: %d\n", current);
        front++;
    }
    
    return 0;
}
```

> **Note**: Always validate array bounds before accessing. Use dynamic memory allocation for flexible data structures. Consider algorithm complexity trade-offs.
