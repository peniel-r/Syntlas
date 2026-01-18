---
id: "c.bestpractices.testing"
title: Testing Practices
category: bestpractices
difficulty: intermediate
tags:
  - testing
  - unit-testing
  - assertions
  - debugging
keywords:
  - unit testing
  - assertions
  - test cases
  - debugging
  - verification
use_cases:
  - Code quality
  - Regression testing
  - Bug prevention
  - Quality assurance
prerequisites:
  - 
  - c.preprocessor
  - 
related:
  - c.stdlib.assert
  - 
  - 
next_topics:
  - 
---

# Testing Practices

Testing is crucial for maintaining code quality and preventing regressions in C programs.

## Simple Test Framework

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Test result tracking
typedef struct {
    int total;
    int passed;
    int failed;
} TestStats;

TestStats stats = {0, 0, 0};

// Assertion c.preprocessor.macros
#define ASSERT(condition) \
    do { \
        stats.total++; \
        if (condition) { \
            stats.passed++; \
            printf("  [PASS] %s:%d: %s\n", __FILE__, __LINE__, #condition); \
        } else { \
            stats.failed++; \
            printf("  [FAIL] %s:%d: %s\n", __FILE__, __LINE__, #condition); \
        } \
    } while(0)

#define ASSERT_EQ(expected, actual) \
    ASSERT((expected) == (actual))

#define ASSERT_NE(expected, actual) \
    ASSERT((expected) != (actual))

#define ASSERT_GT(expected, actual) \
    ASSERT((expected) > (actual))

#define ASSERT_LT(expected, actual) \
    ASSERT((expected) < (actual))

// Test case macro
#define TEST(name) \
    void test_##name(void); \
    __attribute__((constructor)) \
    void register_##name(void) { \
        printf("\n[Test: %s]\n", #name); \
        test_##name(); \
    } \
    void test_##name(void)

// Print test summary
void print_test_summary(void) {
    printf("\n=== Test Summary ===\n");
    printf("Total: %d\n", stats.total);
    printf("Passed: %d\n", stats.passed);
    printf("Failed: %d\n", stats.failed);
    printf("==================\n");
}

// Register summary at exit
void print_summary_on_exit(void) {
    print_test_summary();
}
```

## Using the Test Framework

```c
// Test 

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

TEST(addition) {
    ASSERT_EQ(5, add(2, 3));
    ASSERT_EQ(0, add(0, 0));
    ASSERT_EQ(-5, add(-2, -3));
}

TEST(multiplication) {
    ASSERT_EQ(6, multiply(2, 3));
    ASSERT_EQ(0, multiply(5, 0));
    ASSERT_EQ(-6, multiply(-2, 3));
}

TEST(boundary_values) {
    ASSERT_EQ(INT_MAX, INT_MAX);
    ASSERT_EQ(INT_MIN, INT_MIN);
}

TEST(string_operations) {
    char str[100];
    strcpy(str, "hello");
    ASSERT_EQ(5, strlen(str));
    ASSERT_EQ('h', str[0]);
}

int main(void) {
    atexit(print_summary_on_exit);
    return (stats.failed > 0) ? 1 : 0;
}
```

## Unit Testing for 

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function under test
int factorial(int n) {
    if (n < 0) return -1;
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
}

// Test cases
void test_factorial(void) {
    // Normal cases
    printf("Testing factorial...\n");
    printf("  factorial(5) = %d (expected: 120) %s\n",
           factorial(5),
           factorial(5) == 120 ? "PASS" : "FAIL");

    printf("  factorial(0) = %d (expected: 1) %s\n",
           factorial(0),
           factorial(0) == 1 ? "PASS" : "FAIL");

    printf("  factorial(1) = %d (expected: 1) %s\n",
           factorial(1),
           factorial(1) == 1 ? "PASS" : "FAIL");

    // Edge cases
    printf("  factorial(-1) = %d (expected: -1) %s\n",
           factorial(-1),
           factorial(-1) == -1 ? "PASS" : "FAIL");
}

// String reversal function
void reverse_string(char *str) {
    if (str == NULL) return;

    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

void test_reverse_string(void) {
    printf("Testing reverse_string...\n");

    char test1[] = "hello";
    reverse_string(test1);
    printf("  reverse('hello') = %s (expected: 'olleh') %s\n",
           test1,
           strcmp(test1, "olleh") == 0 ? "PASS" : "FAIL");

    char test2[] = "a";
    reverse_string(test2);
    printf("  reverse('a') = %s (expected: 'a') %s\n",
           test2,
           strcmp(test2, "a") == 0 ? "PASS" : "FAIL");

    char test3[] = ";
    reverse_string(test3);
    printf("  reverse('') = '%s' (expected: '') %s\n",
           test3,
           strcmp(test3, ") == 0 ? "PASS" : "FAIL");
}

int main(void) {
    test_factorial();
    printf("\n");
    test_reverse_string();

    return 0;
}
```

## Memory Testing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Memory leak detec.stdlib.stdion helper
typedef struct {
    void *ptr;
    size_t size;
    const char *file;
    int line;
} Allocation;

#define MAX_ALLOCATIONS 1000
static Allocation allocations[MAX_ALLOCATIONS];
static int allocation_count = 0;

void *test_malloc(size_t size, const char *file, int line) {
    void *ptr = malloc(size);
    if (ptr != NULL && allocation_count < MAX_ALLOCATIONS) {
        allocations[allocation_count].ptr = ptr;
        allocations[allocation_count].size = size;
        allocations[allocation_count].file = file;
        allocations[allocation_count].line = line;
        allocation_count++;
    }
    return ptr;
}

void test_free(void *ptr) {
    if (ptr == NULL) return;

    free(ptr);

    // Remove from tracking
    for (int i = 0; i < allocation_count; i++) {
        if (allocations[i].ptr == ptr) {
            allocations[i].ptr = NULL;
            break;
        }
    }
}

void check_memory_leaks(void) {
    printf("\n=== Memory Leak Check ===\n");
    int leaks = 0;
    for (int i = 0; i < allocation_count; i++) {
        if (allocations[i].ptr != NULL) {
            printf("Leak: %p (%zu bytes) at %s:%d\n",
                   allocations[i].ptr,
                   allocations[i].size,
                   allocations[i].file,
                   allocations[i].line);
            leaks++;
        }
    }

    if (leaks == 0) {
        printf("No memory leaks detected!\n");
    } else {
        printf("Total leaks: %d\n", leaks);
    }
}

// Override malloc/free for testing
#define MALLOC(size) test_malloc(size, __FILE__, __LINE__)
#define FREE(ptr) test_free(ptr)

// Test function that might leak
void process_data(void) {
    char *data = MALLOC(100);
    if (data != NULL) {
        strcpy(data, "test data");
        // Intentional leak for testing
        // FREE(data);  // Comment out to test leak detec.stdlib.stdion
    }
}

int main(void) {
    process_data();

    // Check for leaks at exit
    atexit(check_memory_leaks);

    return 0;
}
```

## Boundary Value Testing

```c
#include <stdio.h>
#include <limits.h>

int clamp(int value, int min_val, int max_val) {
    if (value < min_val) return min_val;
    if (value > max_val) return max_val;
    return value;
}

void test_clamp(void) {
    printf("Testing clamp() with boundary values...\n");

    // Normal cases
    printf("  clamp(5, 0, 10) = %d (expected: 5) %s\n",
           clamp(5, 0, 10),
           clamp(5, 0, 10) == 5 ? "PASS" : "FAIL");

    // Lower boundary
    printf("  clamp(-5, 0, 10) = %d (expected: 0) %s\n",
           clamp(-5, 0, 10),
           clamp(-5, 0, 10) == 0 ? "PASS" : "FAIL");

    printf("  clamp(0, 0, 10) = %d (expected: 0) %s\n",
           clamp(0, 0, 10),
           clamp(0, 0, 10) == 0 ? "PASS" : "FAIL");

    // Upper boundary
    printf("  clamp(15, 0, 10) = %d (expected: 10) %s\n",
           clamp(15, 0, 10),
           clamp(15, 0, 10) == 10 ? "PASS" : "FAIL");

    printf("  clamp(10, 0, 10) = %d (expected: 10) %s\n",
           clamp(10, 0, 10),
           clamp(10, 0, 10) == 10 ? "PASS" : "FAIL");

    // Extreme values
    printf("  clamp(INT_MIN, -100, 100) = %d (expected: -100) %s\n",
           clamp(INT_MIN, -100, 100),
           clamp(INT_MIN, -100, 100) == -100 ? "PASS" : "FAIL");

    printf("  clamp(INT_MAX, -100, 100) = %d (expected: 100) %s\n",
           clamp(INT_MAX, -100, 100),
           clamp(INT_MAX, -100, 100) == 100 ? "PASS" : "FAIL");
}

int main(void) {
    test_clamp();
    return 0;
}
```

## Property-Based Testing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Generate random integer in range
int random_int(int min, int max) {
    return min + rand() % (max - min + 1);
}

// Test property: abs(x) >= 0
void test_abs_property(void) {
    printf("Testing abs(x) >= 0 property...\n");

    for (int i = 0; i < 1000; i++) {
        int x = random_int(-10000, 10000);
        int result = abs(x);

        if (result < 0) {
            printf("  FAIL: abs(%d) = %d\n", x, result);
            return;
        }
    }
    printf("  PASS: All 1000 cases satisfied property\n");
}

// Test property: reversing string twice returns original
void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

void test_reverse_property(void) {
    printf("Testing reverse(reverse(x)) = x property...\n");

    for (int i = 0; i < 100; i++) {
        char str[100];
        int len = random_int(1, 50);

        for (int j = 0; j < len; j++) {
            str[j] = 'a' + random_int(0, 25);
        }
        str[len] = '\0';

        char original[100];
        strcpy(original, str);

        reverse_string(str);
        reverse_string(str);

        if (strcmp(str, original) != 0) {
            printf("  FAIL: '%s' != '%s'\n", str, original);
            return;
        }
    }
    printf("  PASS: All 100 cases satisfied property\n");
}

int main(void) {
    srand(time(NULL));
    test_abs_property();
    test_reverse_property();
    return 0;
}
```

## Integration Testing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple database simulation
typedef struct {
    char name[50];
    int id;
} Record;

Record database[100];
int db_count = 0;

void add_record(const char *name, int id) {
    if (db_count < 100) {
        strncpy(database[db_count].name, name, 49);
        database[db_count].name[49] = '\0';
        database[db_count].id = id;
        db_count++;
    }
}

Record *find_record(int id) {
    for (int i = 0; i < db_count; i++) {
        if (database[i].id == id) {
            return &database[i];
        }
    }
    return NULL;
}

// Integration test
void test_database_integration(void) {
    printf("Testing database integration...\n");

    // Setup
    add_record("Alice", 1);
    add_record("Bob", 2);
    add_record("Charlie", 3);

    // Test
    Record *r1 = find_record(1);
    Record *r2 = find_record(2);
    Record *r3 = find_record(99);  // Non-existent

    int pass = 1;

    if (r1 == NULL || strcmp(r1->name, "Alice") != 0) {
        printf("  FAIL: Record 1 not found correctly\n");
        pass = 0;
    }

    if (r2 == NULL || strcmp(r2->name, "Bob") != 0) {
        printf("  FAIL: Record 2 not found correctly\n");
        pass = 0;
    }

    if (r3 != NULL) {
        printf("  FAIL: Non-existent record found\n");
        pass = 0;
    }

    if (pass) {
        printf("  PASS: All integration tests passed\n");
    }
}

int main(void) {
    test_database_integration();
    return 0;
}
```

## Test Organization

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Test suite structure
typedef struct {
    const char *name;
    void (*test_func)(void);
    int passed;
    int failed;
} TestSuite;

void run_test_suite(TestSuite *suite) {
    printf("\n=== %s ===\n", suite->name);
    suite->passed = 0;
    suite->failed = 0;

    suite->test_func();

    printf("Results: %d passed, %d failed\n",
           suite->passed, suite->failed);
}

// Math test suite
void test_math_operations(void);
TestSuite math_suite = {
    "Math Operations",
    test_math_operations,
    0, 0
};

void test_math_operations(void) {
    // Tests here
    printf("  Testing addition...\n");
    if (2 + 2 == 4) {
        printf("    PASS\n");
        math_suite.passed++;
    } else {
        printf("    FAIL\n");
        math_suite.failed++;
    }

    printf("  Testing multiplication...\n");
    if (3 * 4 == 12) {
        printf("    PASS\n");
        math_suite.passed++;
    } else {
        printf("    FAIL\n");
        math_suite.failed++;
    }
}

// String test suite
void test_string_operations(void);
TestSuite string_suite = {
    "String Operations",
    test_string_operations,
    0, 0
};

void test_string_operations(void) {
    char str1[] = "hello";
    char str2[] = "world";

    printf("  Testing strlen...\n");
    if (strlen(str1) == 5) {
        printf("    PASS\n");
        string_suite.passed++;
    } else {
        printf("    FAIL\n");
        string_suite.failed++;
    }

    printf("  Testing strcmp...\n");
    if (strcmp(str1, str2) != 0) {
        printf("    PASS\n");
        string_suite.passed++;
    } else {
        printf("    FAIL\n");
        string_suite.failed++;
    }
}

int main(void) {
    run_test_suite(&math_suite);
    run_test_suite(&string_suite);

    printf("\n=== Overall Summary ===\n");
    printf("Math: %d passed, %d failed\n",
           math_suite.passed, math_suite.failed);
    printf("Strings: %d passed, %d failed\n",
           string_suite.passed, string_suite.failed);

    int total_passed = math_suite.passed + string_suite.passed;
    int total_failed = math_suite.failed + string_suite.failed;
    printf("Total: %d passed, %d failed\n", total_passed, total_failed);

    return (total_failed > 0) ? 1 : 0;
}
```

## Best Practices

### Write Testable Code

```c
// BAD - Hard to test
void process_user_input(void) {
    printf("Enter value: ");
    int value;
    scanf("%d", &value);
    printf("Result: %d\n", value * 2);
}

// GOOD - Easy to test
int process_value(int value) {
    return value * 2;
}

void test_process_value(void) {
    ASSERT_EQ(4, process_value(2));
    ASSERT_EQ(0, process_value(0));
    ASSERT_EQ(-4, process_value(-2));
}
```

### Test Edge Cases

```c
// Always test boundary conditions
void test_sort(void) {
    // Normal cases
    test_sort_array(data, 10);

    // Edge cases
    test_sort_array(NULL, 0);      // Empty
    test_sort_array(data, 1);      // Single element
    test_sort_array(data, 10000);  // Large
    test_sort_array(data, -1);     // Invalid
}
```

### Keep Tests Independent

```c
// Each test should be independent
TEST(test1) {
    // Setup
    int *data = malloc(100);
    // Test
    // Cleanup
    free(data);
}

TEST(test2) {
    // Independent setup
    int *data = malloc(100);
    // Test
    // Cleanup
    free(data);
}
```

## Common Pitfalls

### 1. Not Testing Error Cases

```c
// WRONG - Only testing success cases
int result = function(5);
ASSERT(result == 10);

// CORRECT - Test both success and failure
ASSERT(function(5) == 10);  // Success
ASSERT(function(-1) == -1); // Error case
```

### 2. brittle Tests

```c
// WRONG - Depends on exact values
ASSERT(system_time == 1234567890);

// CORRECT - Test relative behavior
ASSERT(system_time >= start_time);
ASSERT(system_time <= end_time);
```

### 3. No Test Isolation

```c
// WRONG - Tests share state
static int global_var;

TEST(test1) { global_var = 5; }
TEST(test2) { /* depends on global_var */ }

// CORRECT - Isolated tests
TEST(test1) {
    int local_var = 5;
}
```

> **Note**: Good testing requires discipline and continuous effort. Automate your tests, run them frequently (e.g., with each commit), and maintain high test coverage. Consider using established testing frameworks like Unity, CMocka, or Check for larger projects.
