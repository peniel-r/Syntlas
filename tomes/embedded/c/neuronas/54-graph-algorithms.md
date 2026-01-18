---
id: "c.algorithms.graph"
title: "Graph Algorithms"
category: algorithms
difficulty: advanced
tags: [c, algorithms, graph, bfs, dfs, shortest]
keywords: [graph, bfs, dfs, shortest path, adjacency]
use_cases: [network analysis, routing, optimization]
prerequisites: ["c.algorithms.datastructures"]
related: ["c.algorithms.search"]
next_topics: ["c.algorithms.dynamic"]
---

# Graph Algorithms

## BFS - Breadth-First Search

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int visited[MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        g->visited[i] = 0;
    }
}

void graph_add_edge(Graph* g, int from, int to) {
    int idx = g->adj_count[from]++;
    g->adj[from][idx] = to;
}

void bfs(Graph* g, int start, int nodes) {
    int queue[MAX_NODES];
    int front = 0, rear = 0;

    queue[rear++] = start;
    g->visited[start] = 1;

    while (front < rear) {
        int current = queue[front++];

        printf("Visited: %d\n", current);

        for (int i = 0; i < g->adj_count[current]; i++) {
            int neighbor = g->adj[current][i];

            if (!g->visited[neighbor]) {
                g->visited[neighbor] = 1;
                queue[rear++] = neighbor;
            }
        }
    }
}

int main() {
    Graph g;
    int nodes = 6;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1);
    graph_add_edge(&g, 0, 2);
    graph_add_edge(&g, 1, 3);
    graph_add_edge(&g, 2, 4);
    graph_add_edge(&g, 3, 5);

    printf("BFS starting from node 0:\n");
    bfs(&g, 0, nodes);

    return 0;
}
```

## DFS - Depth-First Search

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int visited[MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        g->visited[i] = 0;
    }
}

void graph_add_edge(Graph* g, int from, int to) {
    int idx = g->adj_count[from]++;
    g->adj[from][idx] = to;
}

void dfs(Graph* g, int node) {
    g->visited[node] = 1;
    printf("Visited: %d\n", node);

    for (int i = 0; i < g->adj_count[node]; i++) {
        int neighbor = g->adj[node][i];

        if (!g->visited[neighbor]) {
            dfs(&g, neighbor);
        }
    }
}

int main() {
    Graph g;
    int nodes = 6;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1);
    graph_add_edge(&g, 0, 2);
    graph_add_edge(&g, 1, 3);
    graph_add_edge(&g, 2, 4);
    graph_add_edge(&g, 3, 5);

    printf("DFS starting from node 0:\n");
    dfs(&g, 0);

    return 0;
}
```

## Dijkstra's Algorithm

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int weight[MAX_NODES][MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        for (int j = 0; j < nodes; j++) {
            g->weight[i][j] = INT_MAX;
        }
    }
}

void graph_add_edge(Graph* g, int from, int to, int w) {
    int idx = g->adj_count[from]++;
    g->adj[from][idx] = to;
    g->weight[from][to] = w;
}

void dijkstra(Graph* g, int start, int nodes, int dist[], int prev[]) {
    int visited[MAX_NODES] = {0};

    for (int i = 0; i < nodes; i++) {
        dist[i] = INT_MAX;
        prev[i] = -1;
    }
    dist[start] = 0;

    for (int count = 0; count < nodes; count++) {
        int u = -1;
        int min_dist = INT_MAX;

        for (int v = 0; v < nodes; v++) {
            if (!visited[v] && dist[v] < min_dist) {
                min_dist = dist[v];
                u = v;
            }
        }

        if (u == -1) break;
        visited[u] = 1;

        for (int i = 0; i < g->adj_count[u]; i++) {
            int v = g->adj[u][i];
            int alt = dist[u] + g->weight[u][v];

            if (alt < dist[v]) {
                dist[v] = alt;
                prev[v] = u;
            }
        }
    }
}

int main() {
    Graph g;
    int nodes = 5;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1, 4);
    graph_add_edge(&g, 0, 2, 2);
    graph_add_edge(&g, 1, 2, 1);
    graph_add_edge(&g, 1, 3, 5);
    graph_add_edge(&g, 2, 3, 8);
    graph_add_edge(&g, 2, 4, 10);
    graph_add_edge(&g, 3, 4, 2);

    int dist[MAX_NODES], prev[MAX_NODES];
    dijkstra(&g, 0, nodes, dist, prev);

    printf("Shortest distances from node 0:\n");
    for (int i = 0; i < nodes; i++) {
        printf("Node %d: %d\n", i, dist[i]);
    }

    return 0;
}
```

## Topological Sort

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int in_degree[MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        g->in_degree[i] = 0;
    }
}

void graph_add_edge(Graph* g, int from, int to) {
    int idx = g->adj_count[from]++;
    g->adj[from][idx] = to;
    g->in_degree[to]++;
}

void topological_sort(Graph* g, int nodes, int result[]) {
    int queue[MAX_NODES];
    int front = 0, rear = 0;
    int count = 0;

    for (int i = 0; i < nodes; i++) {
        if (g->in_degree[i] == 0) {
            queue[rear++] = i;
        }
    }

    while (front < rear) {
        int u = queue[front++];
        result[count++] = u;

        for (int i = 0; i < g->adj_count[u]; i++) {
            int v = g->adj[u][i];
            g->in_degree[v]--;

            if (g->in_degree[v] == 0) {
                queue[rear++] = v;
            }
        }
    }
}

int main() {
    Graph g;
    int nodes = 6;
    graph_init(&g, nodes);

    graph_add_edge(&g, 5, 2);
    graph_add_edge(&g, 5, 0);
    graph_add_edge(&g, 4, 0);
    graph_add_edge(&g, 4, 1);
    graph_add_edge(&g, 2, 3);
    graph_add_edge(&g, 3, 1);

    int result[MAX_NODES];
    topological_sort(&g, nodes, result);

    printf("Topological sort:\n");
    for (int i = 0; i < nodes; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");

    return 0;
}
```

## Connected Components

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int visited[MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        g->visited[i] = 0;
    }
}

void graph_add_edge(Graph* g, int u, int v) {
    g->adj[u][g->adj_count[u]++] = v;
    g->adj[v][g->adj_count[v]++] = u;
}

void dfs(Graph* g, int node, int component[], int comp_id) {
    g->visited[node] = 1;
    component[node] = comp_id;

    for (int i = 0; i < g->adj_count[node]; i++) {
        int neighbor = g->adj[node][i];

        if (!g->visited[neighbor]) {
            dfs(&g, neighbor, component, comp_id);
        }
    }
}

int find_components(Graph* g, int nodes, int component[]) {
    int comp_count = 0;

    for (int i = 0; i < nodes; i++) {
        if (!g->visited[i]) {
            dfs(&g, i, component, comp_count);
            comp_count++;
        }
    }

    return comp_count;
}

int main() {
    Graph g;
    int nodes = 6;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1);
    graph_add_edge(&g, 1, 2);
    graph_add_edge(&g, 3, 4);
    graph_add_edge(&g, 4, 5);

    int components[MAX_NODES];
    int comp_count = find_components(&g, nodes, components);

    printf("Connected components: %d\n", comp_count);
    for (int i = 0; i < nodes; i++) {
        printf("Node %d in component %d\n", i, components[i]);
    }

    return 0;
}
```

## Detect Cycle

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_NODES 100

typedef struct {
    int adj[MAX_NODES][MAX_NODES];
    int adj_count[MAX_NODES];
    int visited[MAX_NODES];
    int rec_stack[MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        g->adj_count[i] = 0;
        g->visited[i] = 0;
        g->rec_stack[i] = 0;
    }
}

void graph_add_edge(Graph* g, int u, int v) {
    g->adj[u][g->adj_count[u]++] = v;
}

bool has_cycle_util(Graph* g, int node) {
    if (!g->visited[node]) {
        g->visited[node] = 1;
        g->rec_stack[node] = 1;

        for (int i = 0; i < g->adj_count[node]; i++) {
            int neighbor = g->adj[node][i];

            if (!g->visited[neighbor] && has_cycle_util(&g, neighbor)) {
                return true;
            } else if (g->rec_stack[neighbor]) {
                return true;
            }
        }

        g->rec_stack[node] = 0;
    }

    return false;
}

bool has_cycle(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        if (!g->visited[i]) {
            if (has_cycle_util(&g, i)) {
                return true;
            }
        }
    }
    return false;
}

int main() {
    Graph g;
    int nodes = 4;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1);
    graph_add_edge(&g, 1, 2);
    graph_add_edge(&g, 2, 0);
    graph_add_edge(&g, 2, 3);

    if (has_cycle(&g, nodes)) {
        printf("Graph has a cycle\n");
    } else {
        printf("Graph is acyclic\n");
    }

    return 0;
}
```

## Minimum Spanning Tree (Prim's)

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_NODES 100

typedef struct {
    int weight[MAX_NODES][MAX_NODES];
} Graph;

void graph_init(Graph* g, int nodes) {
    for (int i = 0; i < nodes; i++) {
        for (int j = 0; j < nodes; j++) {
            g->weight[i][j] = INT_MAX;
        }
    }
}

void graph_add_edge(Graph* g, int u, int v, int w) {
    g->weight[u][v] = w;
    g->weight[v][u] = w;
}

void prim_mst(Graph* g, int nodes) {
    int parent[MAX_NODES];
    int key[MAX_NODES];
    int visited[MAX_NODES] = {0};

    for (int i = 0; i < nodes; i++) {
        key[i] = INT_MAX;
        parent[i] = -1;
    }
    key[0] = 0;

    for (int count = 0; count < nodes - 1; count++) {
        int u = -1;
        int min_key = INT_MAX;

        for (int v = 0; v < nodes; v++) {
            if (!visited[v] && key[v] < min_key) {
                min_key = key[v];
                u = v;
            }
        }

        visited[u] = 1;

        for (int v = 0; v < nodes; v++) {
            if (!visited[v] && g->weight[u][v] < key[v]) {
                key[v] = g->weight[u][v];
                parent[v] = u;
            }
        }
    }

    printf("MST Edges:\n");
    for (int i = 1; i < nodes; i++) {
        printf("%d - %d (%d)\n", parent[i], i, key[i]);
    }
}

int main() {
    Graph g;
    int nodes = 5;
    graph_init(&g, nodes);

    graph_add_edge(&g, 0, 1, 2);
    graph_add_edge(&g, 0, 3, 6);
    graph_add_edge(&g, 1, 2, 3);
    graph_add_edge(&g, 1, 3, 8);
    graph_add_edge(&g, 1, 4, 5);
    graph_add_edge(&g, 2, 4, 7);
    graph_add_edge(&g, 3, 4, 9);

    prim_mst(&g, nodes);

    return 0;
}
```

> **Note**: Graph algorithms have O(V+E) complexity typically. Choose algorithm based on graph properties (directed, weighted, etc.).
