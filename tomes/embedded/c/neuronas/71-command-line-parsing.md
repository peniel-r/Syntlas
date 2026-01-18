---
id: 71-command-line-parsing
title: Command Line Parsing
category: system
difficulty: intermediate
tags:
  - command-line
  - arguments
  - getopt
  - options
keywords:
  - argc
  - argv
  - getopt
  - getopt_long
  - arguments
use_cases:
  - CLI tools
  - Configuration via command line
  - Script parameters
  - Tool arguments
prerequisites:
  - functions
  - arrays
  - pointers
related:
  - string-functions
  - file-operations
next_topics:
  - logging
---

# Command Line Parsing

Command line parsing enables your C programs to accept arguments and options from the command line.

## Basic Command Line Arguments

```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    // argc: argument count
    // argv: argument vector (array of strings)

    printf("Program name: %s\n", argv[0]);
    printf("Argument count: %d\n", argc);

    for (int i = 1; i < argc; i++) {
        printf("Argument %d: %s\n", i, argv[i]);
    }

    return 0;
}
```

## Simple Argument Parser

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *input_file;
    char *output_file;
    int verbose;
    int count;
} Config;

void print_usage(const char *program_name) {
    printf("Usage: %s [OPTIONS]\n", program_name);
    printf("Options:\n");
    printf("  -i <file>    Input file\n");
    printf("  -o <file>    Output file\n");
    printf("  -v           Verbose mode\n");
    printf("  -n <number>  Count\n");
    printf("  -h           Help\n");
}

Config parse_arguments(int argc, char *argv[]) {
    Config config = {NULL, NULL, 0, 1};

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-i") == 0 && i + 1 < argc) {
            config.input_file = argv[++i];
        } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            config.output_file = argv[++i];
        } else if (strcmp(argv[i], "-v") == 0) {
            config.verbose = 1;
        } else if (strcmp(argv[i], "-n") == 0 && i + 1 < argc) {
            config.count = atoi(argv[++i]);
        } else if (strcmp(argv[i], "-h") == 0) {
            print_usage(argv[0]);
            exit(0);
        } else {
            fprintf(stderr, "Unknown option: %s\n", argv[i]);
            print_usage(argv[0]);
            exit(1);
        }
    }

    return config;
}

int main(int argc, char *argv[]) {
    Config config = parse_arguments(argc, argv);

    if (config.verbose) {
        printf("Verbose mode enabled\n");
        printf("Input: %s\n", config.input_file ? config.input_file : "none");
        printf("Output: %s\n", config.output_file ? config.output_file : "none");
        printf("Count: %d\n", config.count);
    }

    return 0;
}
```

## Using getopt() (POSIX)

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    int opt;
    int verbose = 0;
    char *filename = NULL;
    int count = 1;

    // getopt: a - option without argument
    // b: - option with required argument
    // :: - option with optional argument
    while ((opt = getopt(argc, argv, "ab:vf:c:")) != -1) {
        switch (opt) {
            case 'a':
                printf("Option a selected\n");
                break;
            case 'b':
                printf("Option b with argument: %s\n", optarg);
                break;
            case 'v':
                verbose = 1;
                break;
            case 'f':
                filename = optarg;
                break;
            case 'c':
                count = atoi(optarg);
                break;
            case '?':
                fprintf(stderr, "Unknown option: -%c\n", optopt);
                return 1;
            default:
                abort();
        }
    }

    // Remaining arguments (after options)
    if (optind < argc) {
        printf("Non-option arguments: ");
        while (optind < argc) {
            printf("%s ", argv[optind++]);
        }
        printf("\n");
    }

    if (verbose) {
        printf("Verbose mode\n");
        printf("Filename: %s\n", filename ? filename : "none");
        printf("Count: %d\n", count);
    }

    return 0;
}
```

## Using getopt_long()

```c
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

void print_help(const char *program_name) {
    printf("Usage: %s [OPTIONS] [FILES...]\n", program_name);
    printf("\nOptions:\n");
    printf("  -h, --help           Show this help\n");
    printf("  -v, --verbose        Verbose output\n");
    printf("  -f, --file FILE      Input file\n");
    printf("  -o, --output FILE    Output file\n");
    printf("  -c, --count NUM      Repeat count\n");
    printf("  -V, --version        Show version\n");
}

int main(int argc, char *argv[]) {
    static struct option long_options[] = {
        {"help",    no_argument,       0, 'h'},
        {"verbose", no_argument,       0, 'v'},
        {"file",    required_argument, 0, 'f'},
        {"output",  required_argument, 0, 'o'},
        {"count",   required_argument, 0, 'c'},
        {"version", no_argument,       0, 'V'},
        {0, 0, 0, 0}
    };

    int verbose = 0;
    char *input_file = NULL;
    char *output_file = NULL;
    int count = 1;
    int opt;

    while ((opt = getopt_long(argc, argv, "hvf:o:c:V",
                              long_options, NULL)) != -1) {
        switch (opt) {
            case 'h':
                print_help(argv[0]);
                return 0;
            case 'v':
                verbose = 1;
                break;
            case 'f':
                input_file = optarg;
                break;
            case 'o':
                output_file = optarg;
                break;
            case 'c':
                count = atoi(optarg);
                break;
            case 'V':
                printf("Program version 1.0.0\n");
                return 0;
            case '?':
                fprintf(stderr, "Try '%s --help' for more information.\n", argv[0]);
                return 1;
            default:
                abort();
        }
    }

    if (verbose) {
        printf("Configuration:\n");
        printf("  Input: %s\n", input_file ? input_file : "stdin");
        printf("  Output: %s\n", output_file ? output_file : "stdout");
        printf("  Count: %d\n", count);
    }

    // Process remaining arguments
    if (optind < argc) {
        printf("Processing files:\n");
        for (int i = optind; i < argc; i++) {
            printf("  %s\n", argv[i]);
        }
    }

    return 0;
}
```

## Custom Argument Parser with Validation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    char *input;
    char *output;
    int threads;
    int buffer_size;
    bool verbose;
    bool quiet;
} Args;

bool validate_args(Args *args) {
    if (args->threads < 1 || args->threads > 16) {
        fprintf(stderr, "Error: Threads must be between 1 and 16\n");
        return false;
    }

    if (args->buffer_size < 256 || args->buffer_size > 1048576) {
        fprintf(stderr, "Error: Buffer size must be between 256 and 1MB\n");
        return false;
    }

    if (args->verbose && args->quiet) {
        fprintf(stderr, "Error: Cannot use both --verbose and --quiet\n");
        return false;
    }

    return true;
}

Args parse_args(int argc, char *argv[]) {
    Args args = {
        .input = NULL,
        .output = NULL,
        .threads = 1,
        .buffer_size = 4096,
        .verbose = false,
        .quiet = false
    };

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--input") == 0 || strcmp(argv[i], "-i") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "Error: --input requires argument\n");
                exit(1);
            }
            args.input = argv[i];
        } else if (strcmp(argv[i], "--output") == 0 || strcmp(argv[i], "-o") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "Error: --output requires argument\n");
                exit(1);
            }
            args.output = argv[i];
        } else if (strcmp(argv[i], "--threads") == 0 || strcmp(argv[i], "-t") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "Error: --threads requires argument\n");
                exit(1);
            }
            args.threads = atoi(argv[i]);
        } else if (strcmp(argv[i], "--buffer") == 0 || strcmp(argv[i], "-b") == 0) {
            if (++i >= argc) {
                fprintf(stderr, "Error: --buffer requires argument\n");
                exit(1);
            }
            args.buffer_size = atoi(argv[i]);
        } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
            args.verbose = true;
        } else if (strcmp(argv[i], "--quiet") == 0 || strcmp(argv[i], "-q") == 0) {
            args.quiet = true;
        } else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            printf("Usage: %s [OPTIONS]\n", argv[0]);
            printf("\nOptions:\n");
            printf("  -i, --input FILE      Input file\n");
            printf("  -o, --output FILE     Output file\n");
            printf("  -t, --threads NUM     Number of threads (1-16)\n");
            printf("  -b, --buffer SIZE     Buffer size (256-1048576)\n");
            printf("  -v, --verbose         Verbose output\n");
            printf("  -q, --quiet           Quiet mode\n");
            printf("  -h, --help            Show this help\n");
            exit(0);
        } else {
            fprintf(stderr, "Error: Unknown option: %s\n", argv[i]);
            fprintf(stderr, "Try '%s --help' for more information.\n", argv[0]);
            exit(1);
        }
    }

    return args;
}

int main(int argc, char *argv[]) {
    Args args = parse_args(argc, argv);

    if (!validate_args(&args)) {
        return 1;
    }

    if (!args.quiet) {
        printf("Configuration:\n");
        printf("  Input: %s\n", args.input ? args.input : "stdin");
        printf("  Output: %s\n", args.output ? args.output : "stdout");
        printf("  Threads: %d\n", args.threads);
        printf("  Buffer: %d bytes\n", args.buffer_size);
        if (args.verbose) {
            printf("  Verbose mode enabled\n");
        }
    }

    return 0;
}
```

## Parsing Flags and Boolean Options

```c
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

typedef struct {
    bool force;
    bool recursive;
    bool verbose;
    bool dry_run;
} Flags;

Flags parse_flags(int argc, char *argv[]) {
    Flags flags = {false, false, false, false};

    for (int i = 1; i < argc; i++) {
        // Single character flags
        if (strcmp(argv[i], "-f") == 0) flags.force = true;
        else if (strcmp(argv[i], "-r") == 0) flags.recursive = true;
        else if (strcmp(argv[i], "-v") == 0) flags.verbose = true;
        else if (strcmp(argv[i], "-n") == 0) flags.dry_run = true;

        // Long flags
        else if (strcmp(argv[i], "--force") == 0) flags.force = true;
        else if (strcmp(argv[i], "--recursive") == 0) flags.recursive = true;
        else if (strcmp(argv[i], "--verbose") == 0) flags.verbose = true;
        else if (strcmp(argv[i], "--dry-run") == 0) flags.dry_run = true;

        // Combined flags (e.g., -rfv)
        else if (argv[i][0] == '-' && argv[i][1] != '-') {
            for (int j = 1; argv[i][j] != '\0'; j++) {
                switch (argv[i][j]) {
                    case 'f': flags.force = true; break;
                    case 'r': flags.recursive = true; break;
                    case 'v': flags.verbose = true; break;
                    case 'n': flags.dry_run = true; break;
                }
            }
        }
    }

    return flags;
}

int main(int argc, char *argv[]) {
    Flags flags = parse_flags(argc, argv);

    printf("Flags:\n");
    printf("  Force: %s\n", flags.force ? "yes" : "no");
    printf("  Recursive: %s\n", flags.recursive ? "yes" : "no");
    printf("  Verbose: %s\n", flags.verbose ? "yes" : "no");
    printf("  Dry run: %s\n", flags.dry_run ? "yes" : "no");

    return 0;
}
```

## Parsing Numeric Ranges

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct {
    int start;
    int end;
    bool valid;
} Range;

Range parse_range(const char *str) {
    Range range = {-1, -1, false};

    // Check if string contains a dash
    char *dash = strchr(str, '-');
    if (dash == NULL) {
        // Single number
        range.start = atoi(str);
        range.end = range.start;
    } else {
        // Range like "10-20"
        *dash = '\0';  // Temporarily split string
        range.start = atoi(str);
        range.end = atoi(dash + 1);
    }

    // Validate
    if (range.start >= 0 && range.end >= range.start) {
        range.valid = true;
    }

    return range;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <range>\n", argv[0]);
        printf("Examples:\n");
        printf("  %s 5\n", argv[0]);
        printf("  %s 10-20\n", argv[0]);
        return 1;
    }

    Range range = parse_range(argv[1]);

    if (!range.valid) {
        fprintf(stderr, "Invalid range: %s\n", argv[1]);
        return 1;
    }

    if (range.start == range.end) {
        printf("Single value: %d\n", range.start);
    } else {
        printf("Range: %d to %d\n", range.start, range.end);
        printf("Values: ");
        for (int i = range.start; i <= range.end; i++) {
            printf("%d ", i);
        }
        printf("\n");
    }

    return 0;
}
```

## Key-Value Argument Pairs

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_KV_PAIRS 16

typedef struct {
    char *key;
    char *value;
} KeyValue;

typedef struct {
    KeyValue pairs[MAX_KV_PAIRS];
    int count;
} KeyValueMap;

void add_pair(KeyValueMap *map, char *key, char *value) {
    if (map->count < MAX_KV_PAIRS) {
        map->pairs[map->count].key = key;
        map->pairs[map->count].value = value;
        map->count++;
    }
}

char *get_value(KeyValueMap *map, const char *key) {
    for (int i = 0; i < map->count; i++) {
        if (strcmp(map->pairs[i].key, key) == 0) {
            return map->pairs[i].value;
        }
    }
    return NULL;
}

KeyValueMap parse_key_value_pairs(int argc, char *argv[]) {
    KeyValueMap map = {0};

    for (int i = 1; i < argc; i++) {
        // Check for key=value format
        char *equals = strchr(argv[i], '=');
        if (equals != NULL) {
            *equals = '\0';  // Split string
            add_pair(&map, argv[i], equals + 1);
        }
    }

    return map;
}

int main(int argc, char *argv[]) {
    KeyValueMap map = parse_key_value_pairs(argc, argv);

    printf("Key-value pairs:\n");
    for (int i = 0; i < map.count; i++) {
        printf("  %s = %s\n", map.pairs[i].key, map.pairs[i].value);
    }

    printf("\nLooking up specific values:\n");
    char *value;
    if ((value = get_value(&map, "host")) != NULL)
        printf("  host = %s\n", value);
    if ((value = get_value(&map, "port")) != NULL)
        printf("  port = %s\n", value);

    return 0;
}

// Usage: ./program host=localhost port=8080 debug=true
```

## Best Practices

### Provide Help and Version

```c
// Always include help option
if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
    print_help(argv[0]);
    exit(0);
}

// Always include version option
if (strcmp(argv[i], "-V") == 0 || strcmp(argv[i], "--version") == 0) {
    printf("%s version 1.0.0\n", argv[0]);
    exit(0);
}
```

### Validate Input

```c
// Always validate numeric input
if (count < 1 || count > 1000) {
    fprintf(stderr, "Error: Count must be between 1 and 1000\n");
    return 1;
}

// Validate required arguments
if (input_file == NULL) {
    fprintf(stderr, "Error: Input file is required\n");
    return 1;
}
```

### Handle Missing Arguments

```c
// Check before accessing next argument
if (strcmp(argv[i], "-f") == 0) {
    if (i + 1 >= argc || argv[i + 1][0] == '-') {
        fprintf(stderr, "Error: -f requires a filename\n");
        return 1;
    }
    filename = argv[++i];
}
```

> **Note**: For portable code, consider avoiding getopt_long() on non-POSIX systems like Windows. Use a custom parser or cross-platform libraries instead. Always validate user input and provide helpful error messages.
