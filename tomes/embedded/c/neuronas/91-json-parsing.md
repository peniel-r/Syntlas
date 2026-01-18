---
id: 91-json-parsing
title: JSON Parsing
category: algorithms
difficulty: advanced
tags:
  - json
  - parsing
  - data-format
keywords:
  - JSON
  - parsing
  - data structures
  - serialization
use_cases:
  - Data exchange
  - Configuration files
  - API communication
  - Data serialization
prerequisites:
  - strings
  - datastructures
  - memory-management
related:
  - string-algorithms
  - file-operations
next_topics:
  - xml-parsing
---

# JSON Parsing

JSON (JavaScript Object Notation) is a lightweight data interchange format.

## Simple JSON Value Parser

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef enum {
    JSON_NULL,
    JSON_BOOL,
    JSON_NUMBER,
    JSON_STRING,
    JSON_ARRAY,
    JSON_OBJECT
} JSONType;

typedef struct JSONValue {
    JSONType type;
    union {
        int bool_val;
        double number_val;
        char *string_val;
        struct {
            struct JSONValue *values;
            int count;
        } array_val;
        struct {
            char **keys;
            struct JSONValue *values;
            int count;
        } object_val;
    };
} JSONValue;

JSONValue json_parse_null(const char **json) {
    if (strncmp(*json, "null", 4) == 0) {
        *json += 4;
        return (JSONValue){JSON_NULL};
    }
    return (JSONValue){JSON_NULL};
}

JSONValue json_parse_bool(const char **json) {
    if (strncmp(*json, "true", 4) == 0) {
        *json += 4;
        return (JSONValue){JSON_BOOL, .bool_val = 1};
    }
    if (strncmp(*json, "false", 5) == 0) {
        *json += 5;
        return (JSONValue){JSON_BOOL, .bool_val = 0};
    }
    return (JSONValue){JSON_NULL};
}

JSONValue json_parse_number(const char **json) {
    const char *start = *json;

    // Parse sign
    if (**json == '-') (*json)++;

    // Parse integer part
    while (isdigit((unsigned char)**json)) (*json)++;

    // Parse decimal part
    if (**json == '.') {
        (*json)++;
        while (isdigit((unsigned char)**json)) (*json)++;
    }

    // Parse exponent
    if (**json == 'e' || **json == 'E') {
        (*json)++;
        if (**json == '+' || **json == '-') (*json)++;
        while (isdigit((unsigned char)**json)) (*json)++;
    }

    char *end;
    double value = strtod(start, &end);
    return (JSONValue){JSON_NUMBER, .number_val = value};
}

void json_skip_whitespace(const char **json) {
    while (isspace((unsigned char)**json)) (*json)++;
}

JSONValue json_parse_string(const char **json) {
    if (**json != '"') {
        return (JSONValue){JSON_NULL};
    }

    (*json)++;  // Skip opening quote

    int length = 0;
    int capacity = 16;
    char *value = malloc(capacity);

    while (**json != '"' && **json != '\0') {
        if (length + 1 >= capacity) {
            capacity *= 2;
            value = realloc(value, capacity);
        }

        // Handle escape sequences
        if (**json == '\\') {
            (*json)++;
            if (**json == 'n') value[length++] = '\n';
            else if (**json == 't') value[length++] = '\t';
            else if (**json == 'r') value[length++] = '\r';
            else if (**json == '\\') value[length++] = '\\';
            else if (**json == '"') value[length++] = '"';
            else value[length++] = **json;
        } else {
            value[length++] = **json;
        }
        (*json)++;
    }

    value[length] = '\0';
    (*json)++;  // Skip closing quote

    return (JSONValue){JSON_STRING, .string_val = value};
}

JSONValue json_parse_array(const char **json);
JSONValue json_parse_object(const char **json);

JSONValue json_parse_value(const char **json) {
    json_skip_whitespace(json);

    if (**json == 'n') return json_parse_null(json);
    if (**json == 't' || **json == 'f') return json_parse_bool(json);
    if (**json == '-' || isdigit((unsigned char)**json)) return json_parse_number(json);
    if (**json == '"') return json_parse_string(json);
    if (**json == '[') return json_parse_array(json);
    if (**json == '{') return json_parse_object(json);

    return (JSONValue){JSON_NULL};
}

JSONValue json_parse_array(const char **json) {
    if (**json != '[') {
        return (JSONValue){JSON_NULL};
    }

    (*json)++;  // Skip opening bracket

    int count = 0;
    int capacity = 4;
    JSONValue *values = malloc(capacity * sizeof(JSONValue));

    while (**json != ']' && **json != '\0') {
        json_skip_whitespace(json);

        if (**json == ']') break;

        JSONValue val = json_parse_value(json);
        if (count >= capacity) {
            capacity *= 2;
            values = realloc(values, capacity * sizeof(JSONValue));
        }
        values[count++] = val;

        json_skip_whitespace(json);

        if (**json == ',') (*json)++;
    }

    (*json)++;  // Skip closing bracket

    JSONValue result = {
        .type = JSON_ARRAY,
        .array_val = {values, count}
    };
    return result;
}

JSONValue json_parse_object(const char **json) {
    if (**json != '{') {
        return (JSONValue){JSON_NULL};
    }

    (*json)++;  // Skip opening brace

    int count = 0;
    int capacity = 4;
    char **keys = malloc(capacity * sizeof(char *));
    JSONValue *values = malloc(capacity * sizeof(JSONValue));

    while (**json != '}' && **json != '\0') {
        json_skip_whitespace(json);

        if (**json == '}') break;

        // Parse key
        JSONValue key_val = json_parse_string(json);
        keys[count] = key_val.string_val;

        json_skip_whitespace(json);

        if (**json != ':') break;
        (*json)++;

        json_skip_whitespace(json);

        // Parse value
        values[count] = json_parse_value(json);
        count++;

        json_skip_whitespace(json);

        if (**json == ',') (*json)++;
    }

    (*json)++;  // Skip closing brace

    JSONValue result = {
        .type = JSON_OBJECT,
        .object_val = {keys, values, count}
    };
    return result;
}

void json_free(JSONValue *value) {
    if (value == NULL) return;

    switch (value->type) {
        case JSON_STRING:
            free(value->string_val);
            break;
        case JSON_ARRAY:
            for (int i = 0; i < value->array_val.count; i++) {
                json_free(&value->array_val.values[i]);
            }
            free(value->array_val.values);
            break;
        case JSON_OBJECT:
            for (int i = 0; i < value->object_val.count; i++) {
                free(value->object_val.keys[i]);
                json_free(&value->object_val.values[i]);
            }
            free(value->object_val.keys);
            free(value->object_val.values);
            break;
        default:
            break;
    }
}

void json_print(JSONValue *value, int indent) {
    switch (value->type) {
        case JSON_NULL:
            printf("null");
            break;
        case JSON_BOOL:
            printf("%s", value->bool_val ? "true" : "false");
            break;
        case JSON_NUMBER:
            printf("%g", value->number_val);
            break;
        case JSON_STRING:
            printf("\"%s\"", value->string_val);
            break;
        case JSON_ARRAY:
            printf("[");
            for (int i = 0; i < value->array_val.count; i++) {
                json_print(&value->array_val.values[i], indent + 2);
                if (i < value->array_val.count - 1) {
                    printf(", ");
                }
            }
            printf("]");
            break;
        case JSON_OBJECT:
            printf("{");
            for (int i = 0; i < value->object_val.count; i++) {
                printf("\n%*s", indent + 2, "");
                printf("\"%s\": ", value->object_val.keys[i]);
                json_print(&value->object_val.values[i], indent + 2);
                if (i < value->object_val.count - 1) {
                    printf(",");
                }
            }
            printf("\n%*s}", indent, "");
            break;
    }
}

int main(void) {
    const char *json_str = "{\"name\":\"John\",\"age\":30,\"active\":true,\"scores\":[85,92,78]}";

    const char *json_ptr = json_str;
    JSONValue value = json_parse_value(&json_ptr);

    printf("Parsed JSON:\n");
    json_print(&value, 0);
    printf("\n");

    json_free(&value);

    return 0;
}
```

## JSON Generator

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *data;
    int length;
    int capacity;
} JSONBuilder;

void json_builder_init(JSONBuilder *builder) {
    builder->capacity = 256;
    builder->data = malloc(builder->capacity);
    builder->length = 0;
    builder->data[0] = '\0';
}

void json_builder_append(JSONBuilder *builder, const char *str) {
    int len = strlen(str);
    if (builder->length + len + 1 >= builder->capacity) {
        builder->capacity *= 2;
        builder->data = realloc(builder->data, builder->capacity);
    }
    strcat(builder->data + builder->length, str);
    builder->length += len;
}

void json_builder_free(JSONBuilder *builder) {
    free(builder->data);
    builder->data = NULL;
    builder->length = 0;
    builder->capacity = 0;
}

void json_object_start(JSONBuilder *builder) {
    json_builder_append(builder, "{");
}

void json_object_end(JSONBuilder *builder) {
    // Remove trailing comma if present
    if (builder->length > 0 && builder->data[builder->length - 1] == ',') {
        builder->data[builder->length - 1] = '\0';
        builder->length--;
    }
    json_builder_append(builder, "}");
}

void json_array_start(JSONBuilder *builder) {
    json_builder_append(builder, "[");
}

void json_array_end(JSONBuilder *builder) {
    if (builder->length > 0 && builder->data[builder->length - 1] == ',') {
        builder->data[builder->length - 1] = '\0';
        builder->length--;
    }
    json_builder_append(builder, "]");
}

void json_key(JSONBuilder *builder, const char *key) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "\"%s\":", key);
    json_builder_append(builder, buffer);
}

void json_string(JSONBuilder *builder, const char *value) {
    char buffer[512];
    snprintf(buffer, sizeof(buffer), "\"%s\",", value);
    json_builder_append(builder, buffer);
}

void json_number(JSONBuilder *builder, int value) {
    char buffer[64];
    snprintf(buffer, sizeof(buffer), "%d,", value);
    json_builder_append(builder, buffer);
}

void json_bool(JSONBuilder *builder, int value) {
    const char *str = value ? "true," : "false,";
    json_builder_append(builder, str);
}

void json_null(JSONBuilder *builder) {
    json_builder_append(builder, "null,");
}

int main(void) {
    JSONBuilder builder;
    json_builder_init(&builder);

    json_object_start(&builder);

    json_key(&builder, "name");
    json_string(&builder, "John Doe");

    json_key(&builder, "age");
    json_number(&builder, 30);

    json_key(&builder, "active");
    json_bool(&builder, 1);

    json_key(&builder, "scores");
    json_array_start(&builder);
    json_number(&builder, 85);
    json_number(&builder, 92);
    json_number(&builder, 78);
    json_array_end(&builder);

    json_object_end(&builder);

    printf("Generated JSON:\n%s\n", builder.data);

    json_builder_free(&builder);
    return 0;
}
```

## Best Practices

### Use Established Libraries

```c
// For production, use established JSON libraries:
// - cJSON (lightweight)
// - Jansson (simple)
// - json-c (comprehensive)
// - RapidJSON (C++, header-only)
```

### Validate Input

```c
// Always validate JSON before using
JSONValue value = json_parse(&json_str);
if (value.type == JSON_NULL && !expected_null) {
    fprintf(stderr, "Failed to parse JSON\n");
    return 1;
}
```

### Handle Memory Properly

```c
// Always free JSON values when done
JSONValue value = json_parse(&json_str);
// Use value...
json_free(&value);
```

## Common Pitfalls

### 1. Memory Leaks

```c
// WRONG - Not freeing nested values
JSONValue value = json_parse(&json_str);
json_free(&value);  // Only frees top level

// CORRECT - Free all nested values
void json_free_recursive(JSONValue *value) {
    // Recursively free all nested values
}
```

### 2. Buffer Overflow

```c
// WRONG - No bounds checking
char buffer[256];
sprintf(buffer, "%s", json_string);  // Might overflow

// CORRECT - Use snprintf
snprintf(buffer, sizeof(buffer), "%s", json_string);
```

### 3. Not Handling Escape Sequences

```c
// WRONG - Not handling \n, \t, \", etc.
if (*json != '"') {
    buffer[i++] = *json++;
}

// CORRECT - Handle escape sequences
if (*json == '\\') {
    json++;
    if (*json == 'n') buffer[i++] = '\n';
    else if (*json == 't') buffer[i++] = '\t';
    // ...
} else {
    buffer[i++] = *json++;
}
```

> **Note: Implementing a full JSON parser from scratch is complex and error-prone. For production code, use established JSON libraries. The examples above demonstrate the basic principles but lack full validation and error handling.
