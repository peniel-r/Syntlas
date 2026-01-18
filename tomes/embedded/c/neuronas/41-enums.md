---
id: "c.patterns.enums"
title: "Enumerations"
category: patterns
difficulty: beginner
tags: [c, enum, enumeration, constants]
keywords: [enum, enumeration, constants, switch]
use_cases: [state machines, options, error codes]
prerequisites: []
related: ["c.patterns.structs"]
next_topics: ["c.controlflow"]
---

# Enumerations

## Basic Enum

```c
#include <stdio.h>

enum Color {
    RED,
    GREEN,
    BLUE
};

int main() {
    enum Color c = RED;

    printf("Color: %d\n", c);

    return 0;
}
```

## Enum with Values

```c
#include <stdio.h>

enum HttpStatus {
    OK = 200,
    NOT_FOUND = 404,
    SERVER_ERROR = 500
};

int main() {
    enum HttpStatus status = OK;

    printf("Status: %d\n", status);

    return 0;
}
```

## Enum in Switch

```c
#include <stdio.h>

enum Day {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
};

const char* get_day_name(enum Day day) {
    switch (day) {
        case MONDAY:    return "Monday";
        case TUESDAY:   return "Tuesday";
        case WEDNESDAY: return "Wednesday";
        case THURSDAY:  return "Thursday";
        case FRIDAY:    return "Friday";
        case SATURDAY:  return "Saturday";
        case SUNDAY:    return "Sunday";
        default:        return "Unknown";
    }
}

int main() {
    enum Day today = WEDNESDAY;

    printf("Today is: %s\n", get_day_name(today));

    return 0;
}
```

## Enum as Bit Flags

```c
#include <stdio.h>

enum Permissions {
    READ  = 1 << 0,  // 1
    WRITE = 1 << 1,  // 2
    EXEC  = 1 << 2   // 4
};

void print_permissions(int perms) {
    printf("Permissions: ");

    if (perms & READ)  printf("READ ");
    if (perms & WRITE) printf("WRITE ");
    if (perms & EXEC)  printf("EXEC");

    printf("\n");
}

int main() {
    int perms = READ | WRITE;

    print_permissions(perms);

    // Add EXEC
    perms |= EXEC;
    print_permissions(perms);

    // Remove WRITE
    perms &= ~WRITE;
    print_permissions(perms);

    return 0;
}
```

## Scoped Enum (C11)

```c
#include <stdio.h>

enum Color {
    COLOR_RED,
    COLOR_GREEN,
    COLOR_BLUE
};

int main() {
    enum Color c = COLOR_RED;

    printf("Color: %d\n", c);

    return 0;
}
```

## Enum for Error Codes

```c
#include <stdio.h>

enum ErrorCode {
    SUCCESS = 0,
    INVALID_INPUT,
    FILE_NOT_FOUND,
    PERMISSION_DENIED
};

const char* error_string(enum ErrorCode code) {
    switch (code) {
        case SUCCESS:           return "Success";
        case INVALID_INPUT:     return "Invalid input";
        case FILE_NOT_FOUND:    return "File not found";
        case PERMISSION_DENIED: return "Permission denied";
        default:              return "Unknown error";
    }
}

int main() {
    enum ErrorCode error = FILE_NOT_FOUND;

    printf("Error %d: %s\n", error, error_string(error));

    return 0;
}
```

## Enum for States

```c
#include <stdio.h>

enum State {
    STATE_IDLE,
    STATE_RUNNING,
    STATE_PAUSED,
    STATE_STOPPED
};

const char* state_string(enum State state) {
    switch (state) {
        case STATE_IDLE:    return "Idle";
        case STATE_RUNNING: return "Running";
        case STATE_PAUSED: return "Paused";
        case STATE_STOPPED: return "Stopped";
        default:          return "Unknown";
    }
}

int main() {
    enum State state = STATE_RUNNING;

    printf("Current state: %s\n", state_string(state));

    return 0;
}
```

## Enum Size

```c
#include <stdio.h>

enum SmallEnum {
    A = 0,
    B = 1
};

enum LargeEnum {
    BIG = 1000000000
};

int main() {
    printf("sizeof(SmallEnum): %zu\n", sizeof(enum SmallEnum));
    printf("sizeof(LargeEnum): %zu\n", sizeof(enum LargeEnum));

    return 0;
}
```

## Enum as Array Index

```c
#include <stdio.h>

enum Fruit {
    FRUIT_APPLE,
    FRUIT_BANANA,
    FRUIT_CHERRY,
    FRUIT_COUNT
};

const char* fruit_names[FRUIT_COUNT] = {
    "Apple",
    "Banana",
    "Cherry"
};

int main() {
    enum Fruit f = FRUIT_BANANA;

    printf("Fruit: %s\n", fruit_names[f]);

    for (int i = 0; i < FRUIT_COUNT; i++) {
        printf("%d: %s\n", i, fruit_names[i]);
    }

    return 0;
}
```

## Enum Comparison

```c
#include <stdio.h>

enum Level {
    LEVEL_LOW,
    LEVEL_MEDIUM,
    LEVEL_HIGH
};

int main() {
    enum Level current = LEVEL_MEDIUM;
    enum Level threshold = LEVEL_HIGH;

    if (current < threshold) {
        printf("Current level below threshold\n");
    } else if (current == threshold) {
        printf("Current level at threshold\n");
    } else {
        printf("Current level above threshold\n");
    }

    return 0;
}
```

## Enum Iteration

```c
#include <stdio.h>

enum Weekday {
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    WEEKDAY_COUNT
};

const char* weekday_names[WEEKDAY_COUNT] = {
    "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday"
};

int main() {
    for (enum Weekday day = SUNDAY; day < WEEKDAY_COUNT; day++) {
        printf("%d: %s\n", day, weekday_names[day]);
    }

    return 0;
}
```

## Enum with Base Type

```c
#include <stdio.h>
#include <stdint.h>

enum Enum8 : uint8_t {
    E8_A = 0,
    E8_B = 255
};

enum Enum32 : uint32_t {
    E32_X = 0,
    E32_Y = 0xFFFFFFFF
};

int main() {
    printf("sizeof(Enum8): %zu\n", sizeof(enum Enum8));
    printf("sizeof(Enum32): %zu\n", sizeof(enum Enum32));

    return 0;
}
```

## Enum in Struct

```c
#include <stdio.h>

enum Color {
    COLOR_RED,
    COLOR_GREEN,
    COLOR_BLUE
};

typedef struct {
    enum Color color;
    int intensity;
} Pixel;

int main() {
    Pixel p = {COLOR_RED, 100};

    printf("Pixel: color=%d, intensity=%d\n", p.color, p.intensity);

    return 0;
}
```

## Enum to String Conversion

```c
#include <stdio.h>

enum Mode {
    MODE_READ,
    MODE_WRITE,
    MODE_APPEND
};

const char* mode_to_string(enum Mode mode) {
    switch (mode) {
        case MODE_READ:   return "READ";
        case MODE_WRITE:  return "WRITE";
        case MODE_APPEND: return "APPEND";
        default:        return "UNKNOWN";
    }
}

int main() {
    enum Mode mode = MODE_WRITE;

    printf("Mode: %s\n", mode_to_string(mode));

    return 0;
}
```

## Enum Validation

```c
#include <stdio.h>
#include <stdbool.h>

enum Status {
    STATUS_OK,
    STATUS_WARNING,
    STATUS_ERROR
};

bool is_valid_status(enum Status status) {
    return status == STATUS_OK ||
           status == STATUS_WARNING ||
           status == STATUS_ERROR;
}

int main() {
    enum Status s1 = STATUS_OK;
    enum Status s2 = 99;  // Invalid

    printf("s1 valid: %d\n", is_valid_status(s1));
    printf("s2 valid: %d\n", is_valid_status(s2));

    return 0;
}
```

## Enum Forward Declaration

```c
#include <stdio.h>

enum Color;

typedef struct {
    enum Color color;
    int value;
} ColoredItem;

enum Color {
    COLOR_RED,
    COLOR_GREEN,
    COLOR_BLUE
};

int main() {
    ColoredItem item = {COLOR_RED, 42};

    printf("Item: color=%d, value=%d\n", item.color, item.value);

    return 0;
}
```

> **Note**: Enum values are `int` by default. Use `enum Name` type for type safety.
