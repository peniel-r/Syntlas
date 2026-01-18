---
id: 90-configuration-parsing
title: Configuration File Parsing
category: system
difficulty: intermediate
tags:
  - configuration
  - parsing
  - file-io
  - config-files
keywords:
  - configuration file
  - INI parsing
  - JSON parsing
  - config parsing
use_cases:
  - Application configuration
  - Settings management
  - Configurable behavior
  - User preferences
prerequisites:
  - file-operations
  - strings
  - string-functions
related:
  - command-line-parsing
  - file-operations
next_topics:
  - json-parsing
---

# Configuration File Parsing

Configuration files allow applications to be customized without code changes.

## Simple Key-Value Parser

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE 256
#define MAX_KEY 64
#define MAX_VALUE 128

typedef struct {
    char key[MAX_KEY];
    char value[MAX_VALUE];
} ConfigEntry;

typedef struct {
    ConfigEntry entries[100];
    int count;
} Config;

void trim_whitespace(char *str) {
    // Trim leading
    while (isspace((unsigned char)*str)) {
        str++;
    }

    // Trim trailing
    char *end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) {
        end--;
    }
    *(end + 1) = '\0';
}

int parse_config(const char *filename, Config *config) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        return 0;
    }

    config->count = 0;
    char line[MAX_LINE];

    while (fgets(line, sizeof(line), file) && config->count < 100) {
        trim_whitespace(line);

        // Skip empty lines and comments
        if (line[0] == '\0' || line[0] == '#') {
            continue;
        }

        // Parse key=value
        char *equals = strchr(line, '=');
        if (equals != NULL) {
            *equals = '\0';

            strncpy(config->entries[config->count].key, line, MAX_KEY - 1);
            strncpy(config->entries[config->count].value, equals + 1, MAX_VALUE - 1);

            trim_whitespace(config->entries[config->count].key);
            trim_whitespace(config->entries[config->count].value);

            config->count++;
        }
    }

    fclose(file);
    return 1;
}

const char *get_config_value(Config *config, const char *key) {
    for (int i = 0; i < config->count; i++) {
        if (strcmp(config->entries[i].key, key) == 0) {
            return config->entries[i].value;
        }
    }
    return NULL;
}

int main(void) {
    Config config;

    if (parse_config("config.txt", &config)) {
        printf("Configuration loaded (%d entries)\n", config.count);

        const char *host = get_config_value(&config, "host");
        const char *port = get_config_value(&config, "port");
        const char *debug = get_config_value(&config, "debug");

        printf("Host: %s\n", host ? host : "not found");
        printf("Port: %s\n", port ? port : "not found");
        printf("Debug: %s\n", debug ? debug : "not found");
    } else {
        printf("Failed to load configuration\n");
    }

    return 0;
}

/*
config.txt:
host = localhost
port = 8080
debug = true

# This is a comment
timeout = 30
*/
```

## INI File Parser

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE 256
#define MAX_SECTION 64
#define MAX_KEY 64
#define MAX_VALUE 128

typedef struct {
    char section[MAX_SECTION];
    char key[MAX_KEY];
    char value[MAX_VALUE];
} INIEntry;

typedef struct {
    INIEntry entries[200];
    int count;
} INIConfig;

void trim_whitespace(char *str) {
    while (isspace((unsigned char)*str)) {
        str++;
    }
    char *end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) {
        end--;
    }
    *(end + 1) = '\0';
}

int parse_ini(const char *filename, INIConfig *config) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        return 0;
    }

    config->count = 0;
    char current_section[MAX_SECTION] = "";
    char line[MAX_LINE];

    while (fgets(line, sizeof(line), file) && config->count < 200) {
        trim_whitespace(line);

        // Skip comments and empty lines
        if (line[0] == '#' || line[0] == '\0') {
            continue;
        }

        // Parse section [section]
        if (line[0] == '[' && line[strlen(line) - 1] == ']') {
            line[strlen(line) - 1] = '\0';
            strncpy(current_section, line + 1, MAX_SECTION - 1);
            continue;
        }

        // Parse key=value
        char *equals = strchr(line, '=');
        if (equals != NULL) {
            *equals = '\0';

            strncpy(config->entries[config->count].section, current_section, MAX_SECTION - 1);
            strncpy(config->entries[config->count].key, line, MAX_KEY - 1);
            strncpy(config->entries[config->count].value, equals + 1, MAX_VALUE - 1);

            trim_whitespace(config->entries[config->count].section);
            trim_whitespace(config->entries[config->count].key);
            trim_whitespace(config->entries[config->count].value);

            config->count++;
        }
    }

    fclose(file);
    return 1;
}

const char *get_ini_value(INIConfig *config, const char *section, const char *key) {
    for (int i = 0; i < config->count; i++) {
        if (strcmp(config->entries[i].section, section) == 0 &&
            strcmp(config->entries[i].key, key) == 0) {
            return config->entries[i].value;
        }
    }
    return NULL;
}

int main(void) {
    INIConfig config;

    if (parse_ini("config.ini", &config)) {
        printf("INI configuration loaded (%d entries)\n", config.count);

        const char *host = get_ini_value(&config, "server", "host");
        const char *port = get_ini_value(&config, "server", "port");
        const char *user = get_ini_value(&config, "database", "user");

        printf("Server host: %s\n", host ? host : "not found");
        printf("Server port: %s\n", port ? port : "not found");
        printf("Database user: %s\n", user ? user : "not found");
    } else {
        printf("Failed to load INI configuration\n");
    }

    return 0;
}

/*
config.ini:
[server]
host = localhost
port = 8080

[database]
host = db.example.com
port = 5432
user = admin
password = secret
*/
```

## Configuration with Data Types

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    char *key;
    union {
        int int_val;
        float float_val;
        bool bool_val;
        char *str_val;
    };
    enum { INT, FLOAT, BOOL, STRING } type;
} ConfigValue;

ConfigValue create_int_config(char *key, int value) {
    ConfigValue cv = {0};
    cv.key = strdup(key);
    cv.int_val = value;
    cv.type = INT;
    return cv;
}

ConfigValue create_float_config(char *key, float value) {
    ConfigValue cv = {0};
    cv.key = strdup(key);
    cv.float_val = value;
    cv.type = FLOAT;
    return cv;
}

ConfigValue create_bool_config(char *key, bool value) {
    ConfigValue cv = {0};
    cv.key = strdup(key);
    cv.bool_val = value;
    cv.type = BOOL;
    return cv;
}

ConfigValue create_string_config(char *key, char *value) {
    ConfigValue cv = {0};
    cv.key = strdup(key);
    cv.str_val = strdup(value);
    cv.type = STRING;
    return cv;
}

void print_config_value(ConfigValue *cv) {
    if (cv == NULL) return;

    printf("%s = ", cv->key);

    switch (cv->type) {
        case INT:
            printf("%d", cv->int_val);
            break;
        case FLOAT:
            printf("%.2f", cv->float_val);
            break;
        case BOOL:
            printf("%s", cv->bool_val ? "true" : "false");
            break;
        case STRING:
            printf("\"%s\"", cv->str_val);
            break;
    }
    printf("\n");
}

int main(void) {
    ConfigValue configs[5];
    int count = 0;

    configs[count++] = create_string_config("name", "MyApp");
    configs[count++] = create_int_config("version", 2);
    configs[count++] = create_float_config("ratio", 0.75);
    configs[count++] = create_bool_config("enabled", true);
    configs[count++] = create_int_config("max_connections", 100);

    printf("Configuration:\n");
    for (int i = 0; i < count; i++) {
        print_config_value(&configs[i]);
    }

    // Cleanup
    for (int i = 0; i < count; i++) {
        free(configs[i].key);
        if (configs[i].type == STRING) {
            free(configs[i].str_val);
        }
    }

    return 0;
}
```

## Environment Variable Configuration

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *value;
    char *default_value;
} ConfigVar;

ConfigVar config_var(const char *name, const char *default_val) {
    ConfigVar cv;
    cv.default_value = strdup(default_val);
    char *env_val = getenv(name);
    cv.value = env_val ? strdup(env_val) : strdup(default_val);
    return cv;
}

int main(void) {
    // Load configuration from environment variables
    ConfigVar host = config_var("APP_HOST", "localhost");
    ConfigVar port = config_var("APP_PORT", "8080");
    ConfigVar debug = config_var("APP_DEBUG", "false");

    printf("Configuration:\n");
    printf("  Host: %s (default: %s)\n", host.value, host.default_value);
    printf("  Port: %s (default: %s)\n", port.value, port.default_value);
    printf("  Debug: %s (default: %s)\n", debug.value, debug.default_value);

    // Cleanup
    free(host.value);
    free(host.default_value);
    free(port.value);
    free(port.default_value);
    free(debug.value);
    free(debug.default_value);

    return 0;
}
```

## Configuration File Writing

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char key[64];
    char value[128];
} ConfigEntry;

int write_config(const char *filename, ConfigEntry *entries, int count) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        return 0;
    }

    fprintf(file, "# Configuration file\n");
    fprintf(file, "# Generated automatically\n\n");

    for (int i = 0; i < count; i++) {
        fprintf(file, "%s = %s\n", entries[i].key, entries[i].value);
    }

    fclose(file);
    return 1;
}

int main(void) {
    ConfigEntry entries[5] = {
        {"host", "localhost"},
        {"port", "8080"},
        {"timeout", "30"},
        {"debug", "true"},
        {"max_connections", "100"}
    };

    if (write_config("config.txt", entries, 5)) {
        printf("Configuration written to config.txt\n");
    } else {
        printf("Failed to write configuration\n");
    }

    return 0;
}
```

## Best Practices

### Validate Configuration Values

```c
// GOOD - Validate configuration
int get_port(Config *config) {
    const char *port_str = get_config_value(config, "port");
    if (port_str == NULL) {
        return 8080;  // Default
    }

    int port = atoi(port_str);
    if (port < 1 || port > 65535) {
        fprintf(stderr, "Invalid port: %s\n", port_str);
        return 8080;
    }

    return port;
}
```

### Provide Defaults

```c
// GOOD - Always have defaults
const char *get_config(Config *config, const char *key, const char *default_val) {
    const char *val = get_config_value(config, key);
    return val ? val : default_val;
}
```

### Handle Errors Gracefully

```c
// GOOD - Don't crash on config errors
if (!parse_config("config.txt", &config)) {
    fprintf(stderr, "Warning: Using default configuration\n");
    use_default_config();
}
```

## Common Pitfalls

### 1. Buffer Overflow

```c
// WRONG - No bounds checking
strcpy(config->key, input_key);

// CORRECT - Bounded copy
strncpy(config->key, input_key, MAX_KEY - 1);
config->key[MAX_KEY - 1] = '\0';
```

### 2. Not Handling Missing Values

```c
// WRONG - Might crash
printf("Port: %s\n", get_config_value(&config, "port"));

// CORRECT - Check for NULL
const char *port = get_config_value(&config, "port");
printf("Port: %s\n", port ? port : "default");
```

### 3. Type Mismatches

```c
// WRONG - Assuming integer
int value = atoi(get_config_value(&config, "port"));

// CORRECT - Validate type
const char *port_str = get_config_value(&config, "port");
for (int i = 0; port_str[i] != '\0'; i++) {
    if (!isdigit(port_str[i])) {
        fprintf(stderr, "Invalid port: %s\n", port_str);
        return -1;
    }
}
int port = atoi(port_str);
```

> **Note: Configuration parsing requires careful validation and error handling. Always provide sensible defaults. Validate input values. Consider using established configuration libraries for complex requirements.
