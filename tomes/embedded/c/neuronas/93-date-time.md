---
id: 93-date-time
title: Date and Time
category: stdlib
difficulty: intermediate
tags:
  - time
  - datetime
  - timezone
keywords:
  - time
  - date
  - time.h
  - tm
  - timezone
use_cases:
  - Timestamps
  - Date calculations
  - Time formatting
  - Scheduling
prerequisites:
  - stdio
  - strings
related:
  - time-functions
  - stdio
next_topics:
  - localization
---

# Date and Time

C provides comprehensive date and time manipulation functions.

## Current Time

```c
#include <stdio.h>
#include <time.h>

int main(void) {
    // Get current time
    time_t now = time(NULL);
    if (now == (time_t)-1) {
        perror("time() failed");
        return 1;
    }

    printf("Current time (time_t): %ld\n", (long)now);
    printf("Current time (ctime): %s", ctime(&now));

    return 0;
}
```

## Time to String Formatting

```c
#include <stdio.h>
#include <time.h>

int main(void) {
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);

    // Format time
    char buffer[80];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", tm_info);
    printf("Formatted time: %s\n", buffer);

    // Various format options
    strftime(buffer, sizeof(buffer), "%A, %B %d, %Y", tm_info);
    printf("Full date: %s\n", buffer);

    strftime(buffer, sizeof(buffer), "%H:%M:%S", tm_info);
    printf("Time: %s\n", buffer);

    strftime(buffer, sizeof(buffer), "%a %b %e %H:%M:%S %Z %Y", tm_info);
    printf("asctime format: %s\n", buffer);

    return 0;
}
```

## String to Time

```c
#include <stdio.h>
#include <time.h>
#include <string.h>

int main(void) {
    const char *time_str = "2024-01-15 14:30:00";

    struct tm tm_info = {0};
    char *result = strptime(time_str, "%Y-%m-%d %H:%M:%S", &tm_info);

    if (result != NULL) {
        time_t time = mktime(&tm_info);
        printf("Parsed time: %ld\n", (long)time);
        printf("As string: %s", ctime(&time));
    } else {
        printf("Failed to parse time\n");
    }

    return 0;
}
```

## Time Calculations

```c
#include <stdio.h>
#include <time.h>

void add_days(time_t *time, int days) {
    *time += days * 24 * 60 * 60;
}

void add_hours(time_t *time, int hours) {
    *time += hours * 60 * 60;
}

void add_minutes(time_t *time, int minutes) {
    *time += minutes * 60;
}

int days_between(time_t t1, time_t t2) {
    return (int)(difftime(t2, t1) / (24 * 60 * 60));
}

int main(void) {
    time_t now = time(NULL);

    printf("Current time: %s", ctime(&now));

    // Add 7 days
    time_t future = now;
    add_days(&future, 7);
    printf("7 days later: %s", ctime(&future));

    // Add 3 hours
    time_t in_3_hours = now;
    add_hours(&in_3_hours, 3);
    printf("3 hours later: %s", ctime(&in_3_hours));

    // Days between
    time_t past = now - (30 * 24 * 60 * 60);  // 30 days ago
    int days = days_between(past, now);
    printf("Days between: %d\n", days);

    return 0;
}
```

## High-Resolution Time

```c
#include <stdio.h>
#include <time.h>

void print_high_resolution(void) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);

    printf("High-resolution time:\n");
    printf("  Seconds: %ld\n", (long)ts.tv_sec);
    printf("  Nanoseconds: %ld\n", (long)ts.tv_nsec);
}

void measure_time(void) {
    struct timespec start, end;
    double elapsed;

    clock_gettime(CLOCK_MONOTONIC, &start);

    // Simulate work
    for (volatile int i = 0; i < 10000000; i++);

    clock_gettime(CLOCK_MONOTONIC, &end);

    elapsed = (end.tv_sec - start.tv_sec) +
              (end.tv_nsec - start.tv_nsec) / 1e9;

    printf("Elapsed time: %.6f seconds\n", elapsed);
}

int main(void) {
    print_high_resolution();
    printf("\n");

    measure_time();

    return 0;
}
```

## Time Zones

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void print_time_in_timezone(const char *timezone_name) {
    // Set timezone
    if (setenv("TZ", timezone_name, 1) != 0) {
        fprintf(stderr, "Failed to set timezone\n");
        return;
    }
    tzset();

    // Get current time
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);

    // Format with timezone
    char buffer[100];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S %Z", tm_info);

    printf("%s: %s\n", timezone_name, buffer);
}

int main(void) {
    time_t now = time(NULL);

    // UTC
    setenv("TZ", "UTC", 1);
    tzset();
    struct tm *utc_time = gmtime(&now);
    char buffer[80];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S UTC", utc_time);
    printf("UTC: %s\n", buffer);

    printf("\nDifferent time zones:\n");
    print_time_in_timezone("America/New_York");
    print_time_in_timezone("America/Los_Angeles");
    print_time_in_timezone("Europe/London");
    print_time_in_timezone("Asia/Tokyo");

    return 0;
}
```

## Time Difference

```c
#include <stdio.h>
#include <time.h>

void time_diff(time_t t1, time_t t2) {
    double diff = difftime(t2, t1);
    int seconds = (int)diff;
    int minutes = seconds / 60;
    int hours = minutes / 60;
    int days = hours / 24;

    printf("Time difference:\n");
    printf("  Total seconds: %.0f\n", diff);
    printf("  %d days, %d hours, %d minutes, %d seconds\n",
           days, hours % 24, minutes % 60, seconds % 60);
}

int main(void) {
    time_t now = time(NULL);

    // 1 hour ago
    time_t one_hour_ago = now - 3600;
    time_diff(one_hour_ago, now);

    printf("\n");

    // 1 week ago
    time_t one_week_ago = now - (7 * 24 * 3600);
    time_diff(one_week_ago, now);

    return 0;
}
```

## Time Components

```c
#include <stdio.h>
#include <time.h>

void print_time_components(time_t time) {
    struct tm *tm_info = localtime(&time);

    printf("Time components:\n");
    printf("  Year: %d\n", tm_info->tm_year + 1900);
    printf("  Month: %d\n", tm_info->tm_mon + 1);
    printf("  Day: %d\n", tm_info->tm_mday);
    printf("  Hour: %d\n", tm_info->tm_hour);
    printf("  Minute: %d\n", tm_info->tm_min);
    printf("  Second: %d\n", tm_info->tm_sec);
    printf("  Day of week: %d (0=Sunday)\n", tm_info->tm_wday);
    printf("  Day of year: %d\n", tm_info->tm_yday + 1);
    printf("  Daylight savings: %d\n", tm_info->tm_isdst);
}

int main(void) {
    time_t now = time(NULL);
    print_time_components(now);

    return 0;
}
```

## Sleep and Delays

```c
#include <stdio.h>
#include <unistd.h>
#include <time.h>

void sleep_seconds(unsigned int seconds) {
    sleep(seconds);
}

void sleep_ms(unsigned int milliseconds) {
    usleep(milliseconds * 1000);
}

void sleep_ns(long nanoseconds) {
    struct timespec ts = {
        .tv_sec = nanoseconds / 1000000000,
        .tv_nsec = nanoseconds % 1000000000
    };
    nanosleep(&ts, NULL);
}

int main(void) {
    printf("Starting...\n");

    sleep_seconds(1);
    printf("Slept 1 second\n");

    sleep_ms(500);
    printf("Slept 500 milliseconds\n");

    sleep_ns(100000000);  // 100ms
    printf("Slept 100 nanoseconds\n");

    printf("Done!\n");
    return 0;
}
```

## Time Parsing and Validation

```c
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdbool.h>

bool is_valid_date(int year, int month, int day) {
    if (year < 1900 || year > 2100) return false;
    if (month < 1 || month > 12) return false;

    int days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    // Check leap year for February
    if (month == 2) {
        if ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0)) {
            days_in_month[1] = 29;
        }
    }

    return day >= 1 && day <= days_in_month[month - 1];
}

bool parse_date(const char *date_str, int *year, int *month, int *day) {
    struct tm tm_info = {0};
    char *result = strptime(date_str, "%Y-%m-%d", &tm_info);

    if (result == NULL || *result != '\0') {
        return false;
    }

    *year = tm_info.tm_year + 1900;
    *month = tm_info.tm_mon + 1;
    *day = tm_info.tm_mday;

    return is_valid_date(*year, *month, *day);
}

int main(void) {
    const char *dates[] = {
        "2024-01-15",
        "2024-02-29",  // Leap year
        "2023-02-29",  // Invalid
        "2024-13-01",  // Invalid month
        "2024-00-15"   // Invalid month
    };

    for (int i = 0; i < 5; i++) {
        int year, month, day;
        if (parse_date(dates[i], &year, &month, &day)) {
            printf("%s: Valid (%d-%02d-%02d)\n", dates[i], year, month, day);
        } else {
            printf("%s: Invalid\n", dates[i]);
        }
    }

    return 0;
}
```

## Best Practices

### Use time_t for Calculations

```c
// GOOD - Use time_t for arithmetic
time_t future = now + (7 * 24 * 60 * 60);

// AVOID - Manual date calculations
// Prone to errors with leap years, month lengths, etc.
```

### Handle Time Zones Properly

```c
// GOOD - Set timezone consistently
setenv("TZ", "UTC", 1);
tzset();
time_t now = time(NULL);
struct tm *utc = gmtime(&now);
```

### Check Return Values

```c
// GOOD - Check time operations
time_t now = time(NULL);
if (now == (time_t)-1) {
    perror("time() failed");
    return 1;
}

struct tm *tm = localtime(&now);
if (tm == NULL) {
    perror("localtime() failed");
    return 1;
}
```

## Common Pitfalls

### 1. Buffer Overflow

```c
// WRONG - Not checking strftime return
char buffer[10];
strftime(buffer, sizeof(buffer), "%Y-%m-%d", tm);
// Might truncate

// CORRECT - Check return value
size_t len = strftime(buffer, sizeof(buffer), "%Y-%m-%d", tm);
if (len == 0 || len >= sizeof(buffer)) {
    printf("Buffer too small\n");
}
```

### 2. Modifying tm Structure

```c
// WRONG - Modifying tm directly
tm->tm_mon = 12;  // Invalid (should be 0-11)
tm->tm_mday = 32; // Invalid

// CORRECT - Use mktime for validation
tm->tm_mon = 11;
tm->tm_mday = 31;
time_t t = mktime(tm);
if (t == (time_t)-1) {
    printf("Invalid date\n");
}
```

### 3. Ignoring Time Zones

```c
// WRONG - Not considering timezone
time_t now = time(NULL);
struct tm *tm = localtime(&now);
// Assumes local timezone

// CORRECT - Explicit timezone handling
setenv("TZ", "UTC", 1);
tzset();
struct tm *utc = gmtime(&now);
```

> **Note: Date and time handling can be complex due to time zones, leap years, and daylight savings. Always use library functions for calculations. Validate user input properly. Consider timezone settings when working with dates.
