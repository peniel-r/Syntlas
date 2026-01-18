---
id: "c.stdlib.getenv"
title: "Environment Variables (getenv, setenv, putenv)"
category: stdlib
difficulty: beginner
tags: [c, stdlib, environment, getenv, setenv]
keywords: [getenv, setenv, putenv, unsetenv, environ]
use_cases: [configuration, path handling, system integration]
prerequisites: ["c.strings"]
related: ["c.stdlib.system"]
next_topics: ["c.stdlib.process"]
---

# Environment Variables

## getenv - Read Environment Variable

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Read PATH environment variable
    const char* path = getenv("PATH");
    if (path != NULL) {
        printf("PATH: %s\n", path);
    }

    // Read HOME environment variable
    const char* home = getenv("HOME");
    if (home != NULL) {
        printf("HOME: %s\n", home);
    }

    // Try non-existent variable
    const char* missing = getenv("NONEXISTENT");
    if (missing == NULL) {
        printf("Variable does not exist\n");
    }

    return 0;
}
```

## setenv - Set Environment Variable

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Set new variable
    if (setenv("MY_VAR", "hello", 1) == 0) {
        printf("Set MY_VAR\n");
    }

    // Read it back
    const char* value = getenv("MY_VAR");
    if (value != NULL) {
        printf("MY_VAR: %s\n", value);
    }

    // Overwrite existing variable
    if (setenv("MY_VAR", "world", 1) == 0) {
        printf("Updated MY_VAR\n");
    }

    value = getenv("MY_VAR");
    printf("MY_VAR now: %s\n", value);

    // Don't overwrite (overwrite=0)
    if (setenv("MY_VAR", "new_value", 0) == 0) {
        printf("Tried to set (no overwrite)\n");
    }

    value = getenv("MY_VAR");
    printf("MY_VAR still: %s\n", value);

    return 0;
}
```

## putenv - Add to Environment

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // putenv takes "NAME=value" format
    // Note: The string is used directly, don't free it!
    static char my_env[] = "PUTENV_VAR=test_value";

    if (putenv(my_env) == 0) {
        printf("Added PUTENV_VAR\n");
    }

    const char* value = getenv("PUTENV_VAR");
    if (value != NULL) {
        printf("PUTENV_VAR: %s\n", value);
    }

    return 0;
}
```

## unsetenv - Remove Variable

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Set a variable
    setenv("TEMP_VAR", "value", 1);

    const char* value = getenv("TEMP_VAR");
    printf("Before: %s\n", value);

    // Remove it
    if (unsetenv("TEMP_VAR") == 0) {
        printf("Removed TEMP_VAR\n");
    }

    value = getenv("TEMP_VAR");
    if (value == NULL) {
        printf("Variable is now NULL\n");
    }

    return 0;
}
```

## Configuration from Environment

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    const char* host;
    int port;
    const char* database;
} Config;

Config load_config(void) {
    Config config;

    config.host = getenv("DB_HOST");
    if (config.host == NULL) {
        config.host = "localhost";
    }

    const char* port_str = getenv("DB_PORT");
    if (port_str != NULL) {
        config.port = atoi(port_str);
    } else {
        config.port = 5432;
    }

    config.database = getenv("DB_NAME");
    if (config.database == NULL) {
        config.database = "mydb";
    }

    return config;
}

int main() {
    Config config = load_config();

    printf("Configuration:\n");
    printf("  Host: %s\n", config.host);
    printf("  Port: %d\n", config.port);
    printf("  Database: %s\n", config.database);

    return 0;
}
```

## Path Resolution

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* find_program(const char* program) {
    const char* path = getenv("PATH");
    if (path == NULL) {
        return NULL;
    }

    char path_copy[4096];
    strncpy(path_copy, path, sizeof(path_copy));

    char* dir = strtok(path_copy, ":");
    while (dir != NULL) {
        char full_path[512];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir, program);

        // Check if file exists (pseudo-code)
        FILE* f = fopen(full_path, "r");
        if (f != NULL) {
            fclose(f);
            printf("Found: %s\n", full_path);
            return program;
        }

        dir = strtok(NULL, ":");
    }

    return NULL;
}

int main() {
    const char* program = "ls";
    if (find_program(program) != NULL) {
        printf("Program found in PATH\n");
    } else {
        printf("Program not found\n");
    }

    return 0;
}
```

## Debug Mode from Environment

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool is_debug_mode(void) {
    const char* debug = getenv("DEBUG");
    if (debug != NULL) {
        return strcmp(debug, "1") == 0 ||
               strcmp(debug, "true") == 0 ||
               strcmp(debug, "yes") == 0;
    }
    return false;
}

void debug_print(const char* message) {
    if (is_debug_mode()) {
        fprintf(stderr, "[DEBUG] %s\n", message);
    }
}

int main() {
    printf("Normal output\n");
    debug_print("This is a debug message");

    return 0;
}
```

## Default Values

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* get_env_or_default(const char* name, const char* default_value) {
    const char* value = getenv(name);
    return (value != NULL) ? value : default_value;
}

int main() {
    const char* editor = get_env_or_default("EDITOR", "vi");
    const char* browser = get_env_or_default("BROWSER", "firefox");

    printf("Editor: %s\n", editor);
    printf("Browser: %s\n", browser);

    return 0;
}
```

## Environment Variable with Fallback

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* find_config_file(void) {
    // Check XDG_CONFIG_HOME first
    const char* xdg = getenv("XDG_CONFIG_HOME");
    if (xdg != NULL) {
        static char path[512];
        snprintf(path, sizeof(path), "%s/myapp/config", xdg);
        return path;
    }

    // Fallback to HOME
    const char* home = getenv("HOME");
    if (home != NULL) {
        static char path[512];
        snprintf(path, sizeof(path), "%s/.config/myapp/config", home);
        return path;
    }

    // Last resort
    return "/etc/myapp/config";
}

int main() {
    const char* config = find_config_file();
    printf("Config file: %s\n", config);

    return 0;
}
```

## Temporary Directory

```c
#include <stdio.h>
#include <stdlib.h>

const char* get_temp_dir(void) {
    // Check TMPDIR first (Unix)
    const char* tmp = getenv("TMPDIR");
    if (tmp != NULL) {
        return tmp;
    }

    // Check TEMP (Windows)
    tmp = getenv("TEMP");
    if (tmp != NULL) {
        return tmp;
    }

    // Default to /tmp
    return "/tmp";
}

int main() {
    const char* temp_dir = get_temp_dir();
    printf("Temporary directory: %s\n", temp_dir);

    return 0;
}
```

## Log Level from Environment

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    LOG_ERROR,
    LOG_WARN,
    LOG_INFO,
    LOG_DEBUG
} LogLevel;

LogLevel get_log_level(void) {
    const char* level = getenv("LOG_LEVEL");

    if (level == NULL) {
        return LOG_INFO;
    }

    if (strcmp(level, "ERROR") == 0) return LOG_ERROR;
    if (strcmp(level, "WARN") == 0) return LOG_WARN;
    if (strcmp(level, "INFO") == 0) return LOG_INFO;
    if (strcmp(level, "DEBUG") == 0) return LOG_DEBUG;

    return LOG_INFO;
}

int main() {
    LogLevel level = get_log_level();

    const char* level_names[] = {"ERROR", "WARN", "INFO", "DEBUG"};
    printf("Log level: %s\n", level_names[level]);

    return 0;
}
```

> **Note**: Environment variables are inherited by child processes. Changes made by `setenv` don't affect the parent process.
