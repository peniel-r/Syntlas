---
id: "c.stdlib.stdbool"
title: "Boolean Type (stdbool.h)"
category: stdlib
difficulty: beginner
tags: [c, stdbool, bool, true, false, logical]
keywords: [bool, true, false, logical, conditional]
use_cases: [flags, state management, conditions]
prerequisites: []
related: ["c.controlflow"]
next_topics: ["c.stdlib.stdint"]
---

# Boolean Type

## Basic Boolean Usage

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    bool flag = true;
    bool running = false;

    printf("flag: %s\n", flag ? "true" : "false");
    printf("running: %s\n", running ? "true" : "false");

    return 0;
}
```

## Boolean with Conditions

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    bool is_valid = true;
    bool is_active = false;

    if (is_valid && is_active) {
        printf("Both conditions true\n");
    } else {
        printf("At least one condition false\n");
    }

    return 0;
}
```

## Boolean 

```c
#include <stdio.h>
#include <stdbool.h>

bool is_even(int number) {
    return number % 2 == 0;
}

bool is_positive(int number) {
    return number > 0;
}

int main() {
    int value = 10;

    if (is_even(value)) {
        printf("%d is even\n", value);
    }

    if (is_positive(value)) {
        printf("%d is positive\n", value);
    }

    return 0;
}
```

## Boolean Toggle

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    bool state = false;

    printf("Initial: %s\n", state ? "true" : "false");

    // Toggle
    state = !state;
    printf("After toggle: %s\n", state ? "true" : "false");

    // Toggle again
    state = !state;
    printf("After second toggle: %s\n", state ? "true" : "false");

    return 0;
}
```

## Boolean State Machine

```c
#include <stdio.h>
#include <stdbool.h>

typedef enum {
    STATE_IDLE,
    STATE_RUNNING,
    STATE_PAUSED,
    STATE_STOPPED
} State;

bool should_transition(State current, State next) {
    // Define valid transitions
    switch (current) {
        case STATE_IDLE:
            return next == STATE_RUNNING;
        case STATE_RUNNING:
            return next == STATE_PAUSED || next == STATE_STOPPED;
        case STATE_PAUSED:
            return next == STATE_RUNNING || next == STATE_STOPPED;
        case STATE_STOPPED:
            return next == STATE_IDLE;
        default:
            return false;
    }
}

int main() {
    State current = STATE_IDLE;
    State next = STATE_RUNNING;

    if (should_transition(current, next)) {
        printf("Valid transition: IDLE -> RUNNING\n");
    }

    return 0;
}
```

## Boolean Flags

```c
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    bool verbose;
    bool debug;
    bool quiet;
} Options;

Options parse_options(int argc, char* argv[]) {
    Options opts = {false, false, false};

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            opts.verbose = true;
        } else if (strcmp(argv[i], "-d") == 0 || strcmp(argv[i], "--debug") == 0) {
            opts.debug = true;
        } else if (strcmp(argv[i], "-q") == 0 || strcmp(argv[i], "--quiet") == 0) {
            opts.quiet = true;
        }
    }

    return opts;
}

int main(int argc, char* argv[]) {
    Options opts = parse_options(argc, argv);

    printf("Options:\n");
    printf("  Verbose: %s\n", opts.verbose ? "true" : "false");
    printf("  Debug: %s\n", opts.debug ? "true" : "false");
    printf("  Quiet: %s\n", opts.quiet ? "true" : "false");

    return 0;
}
```

## Boolean Comparison

```c
#include <stdio.h>
#include <stdbool.h>

bool strings_equal(const char* a, const char* b) {
    return strcmp(a, b) == 0;
}

bool ranges_overlap(int a1, int a2, int b1, int b2) {
    return !(a2 < b1 || b2 < a1);
}

int main() {
    const char* str1 = "hello";
    const char* str2 = "hello";

    printf("Strings equal: %s\n", strings_equal(str1, str2) ? "true" : "false");

    printf("Ranges overlap: %s\n", ranges_overlap(1, 5, 3, 7) ? "true" : "false");

    return 0;
}
```

## Boolean Logic Gates

```c
#include <stdio.h>
#include <stdbool.h>

bool AND(bool a, bool b) {
    return a && b;
}

bool OR(bool a, bool b) {
    return a || b;
}

bool NOT(bool a) {
    return !a;
}

bool XOR(bool a, bool b) {
    return a != b;
}

bool NAND(bool a, bool b) {
    return !(a && b);
}

bool NOR(bool a, bool b) {
    return !(a || b);
}

int main() {
    bool a = true, b = false;

    printf("a = %s, b = %s\n", a ? "T" : "F", b ? "T" : "F");
    printf("AND: %s\n", AND(a, b) ? "T" : "F");
    printf("OR: %s\n", OR(a, b) ? "T" : "F");
    printf("NOT a: %s\n", NOT(a) ? "T" : "F");
    printf("XOR: %s\n", XOR(a, b) ? "T" : "F");
    printf("NAND: %s\n", NAND(a, b) ? "T" : "F");
    printf("NOR: %s\n", NOR(a, b) ? "T" : "F");

    return 0;
}
```

## Boolean Input Validation

```c
#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>

bool is_valid_email(const char* email) {
    if (email == NULL || *email == '\0') {
        return false;
    }

    bool has_at = false;
    bool has_dot_after_at = false;
    int at_pos = 0;

    // Find '@' position
    for (int i = 0; email[i] != '\0'; i++) {
        if (email[i] == '@') {
            if (has_at) return false;  // Multiple @ symbols
            has_at = true;
            at_pos = i;
        }
    }

    if (!has_at) return false;

    // Check for dot after @
    for (int i = at_pos; email[i] != '\0'; i++) {
        if (email[i] == '.' && i > at_pos + 1) {
            has_dot_after_at = true;
            break;
        }
    }

    return has_at && has_dot_after_at;
}

int main() {
    const char* emails[] = {
        "user@example.com",
        "invalid.email",
        "@invalid.com",
        "user@domain",
        "valid.user@example.org"
    };

    for (int i = 0; i < 5; i++) {
        printf("%s: %s\n", emails[i],
               is_valid_email(emails[i]) ? "valid" : "invalid");
    }

    return 0;
}
```

## Boolean Array

```c
#include <stdio.h>
#include <stdbool.h>

void print_bool_array(const bool* arr, size_t size) {
    printf("[");
    for (size_t i = 0; i < size; i++) {
        printf("%s", arr[i] ? "true" : "false");
        if (i < size - 1) printf(", ");
    }
    printf("]\n");
}

int main() {
    bool flags[] = {true, false, true, true, false};
    size_t size = sizeof(flags) / sizeof(flags[0]);

    print_bool_array(flags, size);

    return 0;
}
```

## Boolean with Return Values

```c
#include <stdio.h>
#include <stdbool.h>

bool divide(int a, int b, int* result) {
    if (b == 0) {
        return false;
    }

    *result = a / b;
    return true;
}

int main() {
    int x = 10, y = 2;
    int result;

    if (divide(x, y, &result)) {
        printf("%d / %d = %d\n", x, y, result);
    } else {
        printf("Division by zero\n");
    }

    return 0;
}
```

> **Note**: `true` expands to `1`, `false` to `0`. They are of type `int` but `stdbool.h` provides semantic clarity.
