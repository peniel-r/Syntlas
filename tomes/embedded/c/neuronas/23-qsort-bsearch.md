---
id: "c.stdlib.qsort"
title: "Sorting and Searching (qsort, bsearch)"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, qsort, bsearch, sorting, searching]
keywords: [qsort, bsearch, sort, search, compare, binary]
use_cases: [data processing, algorithms, database operations]
prerequisites: ["c.pointers", "c.functions"]
related: ["c.strings"]
next_topics: ["c.stdlib.math"]
---

# Sorting and Searching

## qsort - Quick Sort

```c
#include <stdio.h>
#include <stdlib.h>

int compare_ints(const void* a, const void* b) {
    int int_a = *((int*)a);
    int int_b = *((int*)b);

    if (int_a == int_b) return 0;
    else if (int_a < int_b) return -1;
    else return 1;
}

int main() {
    int numbers[] = {5, 2, 8, 1, 9, 3};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    printf("Before sort: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    qsort(numbers, size, sizeof(int), compare_ints);

    printf("After sort: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Sorting Strings

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int compare_strings(const void* a, const void* b) {
    const char* str_a = *(const char**)a;
    const char* str_b = *(const char**)b;

    return strcmp(str_a, str_b);
}

int main() {
    const char* fruits[] = {"banana", "apple", "cherry", "date"};
    size_t count = sizeof(fruits) / sizeof(fruits[0]);

    printf("Before: ");
    for (size_t i = 0; i < count; i++) {
        printf("%s ", fruits[i]);
    }
    printf("\n");

    qsort(fruits, count, sizeof(const char*), compare_strings);

    printf("After: ");
    for (size_t i = 0; i < count; i++) {
        printf("%s ", fruits[i]);
    }
    printf("\n");

    return 0;
}
```

## Reverse Sort

```c
#include <stdio.h>
#include <stdlib.h>

int compare_reverse(const void* a, const void* b) {
    return compare_ints(b, a);
}

int compare_ints(const void* a, const void* b) {
    int int_a = *((int*)a);
    int int_b = *((int*)b);

    return int_a - int_b;
}

int main() {
    int numbers[] = {5, 2, 8, 1, 9, 3};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    qsort(numbers, size, sizeof(int), compare_reverse);

    printf("Reverse sorted: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
```

## Sorting Structures

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const char* name;
    int age;
} Person;

int compare_persons(const void* a, const void* b) {
    const Person* p1 = (const Person*)a;
    const Person* p2 = (const Person*)b;

    return p1->age - p2->age;
}

int main() {
    Person people[] = {
        {"Alice", 30},
        {"Bob", 25},
        {"Charlie", 35}
    };
    size_t count = sizeof(people) / sizeof(people[0]);

    qsort(people, count, sizeof(Person), compare_persons);

    for (size_t i = 0; i < count; i++) {
        printf("%s: %d\n", people[i].name, people[i].age);
    }

    return 0;
}
```

## bsearch - Binary Search

```c
#include <stdio.h>
#include <stdlib.h>

int compare_ints(const void* a, const void* b) {
    int int_a = *((int*)a);
    int int_b = *((int*)b);

    return int_a - int_b;
}

int main() {
    int numbers[] = {1, 3, 5, 7, 9, 11, 13};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);

    int target = 7;

    void* result = bsearch(&target, numbers, size, sizeof(int), compare_ints);

    if (result != NULL) {
        int found = *((int*)result);
        printf("Found %d\n", found);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## bsearch with Custom Data

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const char* name;
    int id;
} Employee;

int compare_employees(const void* a, const void* b) {
    const Employee* e1 = (const Employee*)a;
    const Employee* e2 = (const Employee*)b;

    return strcmp(e1->name, e2->name);
}

int main() {
    Employee employees[] = {
        {"Alice", 101},
        {"Bob", 102},
        {"Charlie", 103}
    };
    size_t count = sizeof(employees) / sizeof(employees[0]);

    Employee target = {"Bob", 0};

    void* result = bsearch(&target, employees, count, sizeof(Employee), compare_employees);

    if (result != NULL) {
        Employee found = *((Employee*)result);
        printf("Found: %s (ID: %d)\n", found.name, found.id);
    } else {
        printf("Not found\n");
    }

    return 0;
}
```

## Case-Insensitive Sort

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int compare_case_insensitive(const void* a, const void* b) {
    const char* str_a = *(const char**)a;
    const char* str_b = *(const char**)b;

    return strcasecmp(str_a, str_b);
}

int main() {
    const char* words[] = {"Apple", "banana", "Cherry", "date"};
    size_t count = sizeof(words) / sizeof(words[0]);

    qsort(words, count, sizeof(const char*), compare_case_insensitive);

    for (size_t i = 0; i < count; i++) {
        printf("%s\n", words[i]);
    }

    return 0;
}
```

## Sort by Multiple Fields

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const char* name;
    int score;
    int age;
} Student;

int compare_students(const void* a, const void* b) {
    const Student* s1 = (const Student*)a;
    const Student* s2 = (const Student*)b;

    // Sort by score (descending)
    if (s1->score != s2->score) {
        return s2->score - s1->score;
    }

    // Then by age (ascending)
    return s1->age - s2->age;
}

int main() {
    Student students[] = {
        {"Alice", 90, 20},
        {"Bob", 85, 22},
        {"Charlie", 90, 19},
        {"David", 85, 21}
    };
    size_t count = sizeof(students) / sizeof(students[0]);

    qsort(students, count, sizeof(Student), compare_students);

    for (size_t i = 0; i < count; i++) {
        printf("%s: %d (age %d)\n",
               students[i].name, students[i].score, students[i].age);
    }

    return 0;
}
```

> **Note**: The array must be sorted before using `bsearch`. `qsort` uses quicksort with O(n log n) average complexity.
