---
id: "c.patterns.logging"
title:  Best Practices
category: bestpractices
difficulty: intermediate
tags:
  - 
  - debug
  - output
  - 
keywords:
  - 
  - debug output
  - error 
  - log levels
  - fprintf
use_cases:
  - Debugging
  - Error tracking
  - Application monitoring
  - Diagnostics
prerequisites:
  - c.stdlib.stdio
  - c.preprocessor
  - 
related:
  - 
  - c.stdlib.stdio
  - 
next_topics:
  - c.bestpractices.security
---

#  Best Practices

Proper  is essential for debugging, monitoring, and maintaining C applications.

## Basic  with c.preprocessor.macros

```c
#include <stdio.h>

// Simple  c.preprocessor.macros
#define LOG_INFO(msg) printf("[INFO] %s\n", msg)
#define LOG_WARNING(msg) printf("[WARNING] %s\n", msg)
#define LOG_ERROR(msg) fprintf(stderr, "[ERROR] %s\n", msg)

int main(void) {
    LOG_INFO("Application started");
    LOG_WARNING("This is a warning");
    LOG_ERROR("Something went wrong");

    return 0;
}
```

## Log Levels

```c
#include <stdio.h>

typedef enum {
    LOG_LEVEL_DEBUG = 0,
    LOG_LEVEL_INFO,
    LOG_LEVEL_WARNING,
    LOG_LEVEL_ERROR,
    LOG_LEVEL_CRITICAL
} LogLevel;

static LogLevel current_log_level = LOG_LEVEL_INFO;

const char *log_level_string(LogLevel level) {
    switch (level) {
        case LOG_LEVEL_DEBUG:    return "DEBUG";
        case LOG_LEVEL_INFO:     return "INFO";
        case LOG_LEVEL_WARNING:  return "WARNING";
        case LOG_LEVEL_ERROR:    return "ERROR";
        case LOG_LEVEL_CRITICAL: return "CRITICAL";
        default:                 return "UNKNOWN";
    }
}

void log_message(LogLevel level, const char *format, ...) {
    if (level < current_log_level) {
        return;
    }

    va_list args;
    va_start(args, format);

    FILE *output = (level >= LOG_LEVEL_ERROR) ? stderr : stdout;
    fprintf(output, "[%s] ", log_level_string(level));
    vfprintf(output, format, args);
    fprintf(output, "\n");

    va_end(args);
}

int main(void) {
    log_message(LOG_LEVEL_DEBUG, "This won't show (level too low)");
    log_message(LOG_LEVEL_INFO, "Application started");
    log_message(LOG_LEVEL_WARNING, "This is a warning");
    log_message(LOG_LEVEL_ERROR, "Error code: %d", 404);
    log_message(LOG_LEVEL_CRITICAL, "System failure!");

    return 0;
}
```

## Timestamp 

```c
#include <stdio.h>
#include <time.h>

void log_with_timestamp(const char *level, const char *message) {
    time_t now = time(NULL);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S",
             localtime(&now));

    printf("[%s] [%s] %s\n", timestamp, level, message);
}

int main(void) {
    log_with_timestamp("INFO", "Application started");
    log_with_timestamp("DEBUG", "Processing data");
    log_with_timestamp("ERROR", "Failed to open file");

    return 0;
}
```

## File 

```c
#include <stdio.h>
#include <time.h>

typedef struct {
    FILE *file;
    const char *filename;
    int to_console;
    int to_file;
} Logger;

Logger *logger_create(const char *filename, int to_console, int to_file) {
    Logger *logger = malloc(sizeof(Logger));
    if (logger == NULL) return NULL;

    logger->filename = filename;
    logger->to_console = to_console;
    logger->to_file = to_file;

    if (to_file) {
        logger->file = fopen(filename, "a");
        if (logger->file == NULL) {
            fprintf(stderr, "Failed to open log file: %s\n", filename);
            free(logger);
            return NULL;
        }
    }

    return logger;
}

void logger_log(Logger *logger, const char *level, const char *format, ...) {
    time_t now = time(NULL);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S",
             localtime(&now));

    va_list args;
    va_start(args, format);

    // Format the message
    char message[1024];
    vsnprintf(message, sizeof(message), format, args);

    // Write to console
    if (logger->to_console) {
        FILE *output = (strcmp(level, "ERROR") == 0 ||
                        strcmp(level, "CRITICAL") == 0) ? stderr : stdout;
        fprintf(output, "[%s] [%s] %s\n", timestamp, level, message);
    }

    // Write to file
    if (logger->to_file && logger->file != NULL) {
        fprintf(logger->file, "[%s] [%s] %s\n", timestamp, level, message);
        fflush(logger->file);  // Ensure immediate write
    }

    va_end(args);
}

void logger_destroy(Logger *logger) {
    if (logger->to_file && logger->file != NULL) {
        fclose(logger->file);
    }
    free(logger);
}

int main(void) {
    Logger *logger = logger_create("app.log", 1, 1);
    if (logger == NULL) {
        return 1;
    }

    logger_log(logger, "INFO", "Application started");
    logger_log(logger, "DEBUG", "Initializing components");
    logger_log(logger, "WARNING", "Low memory: %d MB", 128);
    logger_log(logger, "ERROR", "Connec.stdlib.stdion failed: %s", "timeout");

    logger_destroy(logger);
    return 0;
}
```

## Conditional  (Debug Builds)

```c
#include <stdio.h>

// Debug  (only compiled in debug builds)
#ifdef DEBUG
    #define LOG_DEBUG(msg, ...) \
        printf("[DEBUG] [%s:%d] " msg "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
    #define LOG_DEBUG(msg, ...) ((void)0)
#endif

// Always log info
#define LOG_INFO(msg, ...) \
    printf("[INFO] " msg "\n", ##__VA_ARGS__)

// Always log errors
#define LOG_ERROR(msg, ...) \
    fprintf(stderr, "[ERROR] [%s:%d] " msg "\n", __FILE__, __LINE__, ##__VA_ARGS__)

int main(void) {
    LOG_DEBUG("Variable value: %d", 42);
    LOG_INFO("Application started");
    LOG_ERROR("Error occurred: %s", "file not found");

    return 0;
}
```

## Structured 

```c
#include <stdio.h>
#include <time.h>

typedef struct {
    const char *timestamp;
    const char *level;
    const char *component;
    const char *message;
    int thread_id;
} LogEntry;

void log_structured(const char *component, const char *level,
                    const char *format, ...) {
    time_t now = time(NULL);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S",
             localtime(&now));

    va_list args;
    va_start(args, format);

    char message[512];
    vsnprintf(message, sizeof(message), format, args);

    // JSON-like structured output
    printf("{\"timestamp\":\"%s\",\"level\":\"%s\",\"component\":\"%s\",\"message\":\"%s\",\"thread_id\":%d}\n",
           timestamp, level, component, message, 0);

    va_end(args);
}

int main(void) {
    log_structured("main", "INFO", "Application started");
    log_structured("database", "ERROR", "Connec.stdlib.stdion failed: %s", "timeout");
    log_structured("network", "DEBUG", "Packet size: %d bytes", 1024);

    return 0;
}
```

## Rotating Log Files

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LOG_SIZE 1048576  // 1 MB

typedef struct {
    FILE *file;
    char filename[256];
    long current_size;
} RotatingLogger;

RotatingLogger *rotating_logger_create(const char *filename) {
    RotatingLogger *logger = malloc(sizeof(RotatingLogger));
    if (logger == NULL) return NULL;

    strncpy(logger->filename, filename, sizeof(logger->filename) - 1);

    logger->file = fopen(filename, "a");
    if (logger->file == NULL) {
        free(logger);
        return NULL;
    }

    // Get current file size
    fseek(logger->file, 0, SEEK_END);
    logger->current_size = ftell(logger);

    return logger;
}

void rotating_logger_log(RotatingLogger *logger, const char *message) {
    if (logger->file == NULL) return;

    // Check if rotation needed
    if (logger->current_size > MAX_LOG_SIZE) {
        fclose(logger->file);

        // Rotate: rename current to .old
        char old_filename[512];
        snprintf(old_filename, sizeof(old_filename), "%s.old", logger->filename);
        rename(logger->filename, old_filename);

        // Create new log file
        logger->file = fopen(logger->filename, "a");
        logger->current_size = 0;
    }

    if (logger->file != NULL) {
        time_t now = time(NULL);
        char timestamp[20];
        strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S",
                 localtime(&now));

        fprintf(logger->file, "[%s] %s\n", timestamp, message);
        fflush(logger->file);
        logger->current_size = ftell(logger->file);
    }
}

void rotating_logger_destroy(RotatingLogger *logger) {
    if (logger->file != NULL) {
        fclose(logger->file);
    }
    free(logger);
}

int main(void) {
    RotatingLogger *logger = rotating_logger_create("rotating.log");
    if (logger == NULL) {
        return 1;
    }

    for (int i = 0; i < 1000; i++) {
        rotating_logger_log(logger, "This is a log message");
    }

    rotating_logger_destroy(logger);
    return 0;
}
```

## Performance 

```c
#include <stdio.h>
#include <time.h>

typedef struct {
    clock_t start;
    const char *name;
} Timer;

Timer timer_start(const char *name) {
    printf("[%s] Starting...\n", name);
    Timer t = {clock(), name};
    return t;
}

void timer_stop(Timer *t) {
    clock_t end = clock();
    double elapsed = ((double)(end - t->start)) / CLOCKS_PER_SEC;
    printf("[%s] Completed in %.6f seconds\n", t->name, elapsed);
}

int main(void) {
    Timer t1 = timer_start("Task 1");
    // Simulate work
    for (volatile int i = 0; i < 1000000; i++);
    timer_stop(&t1);

    Timer t2 = timer_start("Task 2");
    // Simulate work
    for (volatile int i = 0; i < 2000000; i++);
    timer_stop(&t2);

    return 0;
}
```

## Function Entry/Exit 

```c
#include <stdio.h>

#define LOG_FUNc.stdlib.stdioN_ENTRY() \
    printf("[ENTER] %s (%s:%d)\n", __func__, __FILE__, __LINE__)

#define LOG_FUNc.stdlib.stdioN_EXIT() \
    printf("[EXIT] %s (%s:%d)\n", __func__, __FILE__, __LINE__)

int compute_sum(int a, int b) {
    LOG_FUNc.stdlib.stdioN_ENTRY();
    int result = a + b;
    LOG_FUNc.stdlib.stdioN_EXIT();
    return result;
}

int main(void) {
    int sum = compute_sum(10, 20);
    printf("Sum: %d\n", sum);
    return 0;
}
```

## Error Context 

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>

void log_error_context(const char *operation, int error_code) {
    fprintf(stderr, "[ERROR] Operation failed: %s\n", operation);
    fprintf(stderr, "  Error code: %d\n", error_code);
    fprintf(stderr, "  Description: %s\n", strerror(error_code));
    fprintf(stderr, "  Location: %s:%d\n", __FILE__, __LINE__);
}

int main(void) {
    FILE *file = fopen("nonexistent.txt", "r");
    if (file == NULL) {
        log_error_context("Opening file", errno);
        return 1;
    }

    fclose(file);
    return 0;
}
```

## Thread-Safe  (Basic)

```c
#include <stdio.h>
#include <time.h>
#include <pthread.h>

typedef struct {
    pthread_mutex_t mutex;
    FILE *file;
} ThreadSafeLogger;

ThreadSafeLogger *thread_safe_logger_create(const char *filename) {
    ThreadSafeLogger *logger = malloc(sizeof(ThreadSafeLogger));
    if (logger == NULL) return NULL;

    pthread_mutex_init(&logger->mutex, NULL);
    logger->file = fopen(filename, "a");

    return logger;
}

void thread_safe_logger_log(ThreadSafeLogger *logger, const char *message) {
    time_t now = time(NULL);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S",
             localtime(&now));

    pthread_mutex_lock(&logger->mutex);
    fprintf(logger->file, "[%s] [%lu] %s\n",
            timestamp, (unsigned long)pthread_self(), message);
    fflush(logger->file);
    pthread_mutex_unlock(&logger->mutex);
}

void thread_safe_logger_destroy(ThreadSafeLogger *logger) {
    if (logger->file != NULL) {
        fclose(logger->file);
    }
    pthread_mutex_destroy(&logger->mutex);
    free(logger);
}
```

## Best Practices

### Use Appropriate Log Levels

```c
// DEBUG - Detailed information for diagnosing problems
LOG_DEBUG("Processing item %d of %d", current, total);

// INFO - General information about program execution
LOG_INFO("Server started on port %d", port);

// WARNING - Something unexpected but not critical
LOG_WARNING("High memory usage: %d MB", memory_usage);

// ERROR - Error occurred but program continues
LOG_ERROR("Failed to process request: %s", error_msg);

// CRITICAL - Serious error, program may not continue
LOG_CRITICAL("Database connec.stdlib.stdion lost");
```

### Include Context in Messages

```c
// GOOD - Include relevant context
LOG_ERROR("Failed to open file '%s': %s", filename, strerror(errno));

// BAD - Vague message
LOG_ERROR("Failed to open file");
```

### Avoid  in Tight c.controlflow

```c
// BAD -  in performance-critical loop
for (int i = 0; i < 1000000; i++) {
    LOG_DEBUG("Processing item %d", i);  // Too slow
}

// GOOD - Log summary
for (int i = 0; i < 1000000; i++) {
    process_item(i);
}
LOG_DEBUG("Processed %d items", 1000000);
```

### Flush Important Logs

```c
// Flush critical logs immediately
LOG_CRITICAL("System failure detected!");
fflush(log_file);
```

> **Note**:  can significantly impact performance, especially in production. Always use conditional  for debug logs, consider asynchronous  for high-performance applications, and rotate log files to prevent disk space issues.
