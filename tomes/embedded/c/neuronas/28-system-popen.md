---
id: "c.stdlib.system"
title: "System Commands (system, popen)"
category: stdlib
difficulty: intermediate
tags: [c, stdlib, system, popen, subprocess, shell]
keywords: [system, popen, pclose, subprocess, shell command]
use_cases: [automation, system integration, external tools]
prerequisites: ["c.stdlib.stdio", "c.stdlib.string"]
related: ["c.stdlib.getenv"]
next_topics: ["c.stdlib.process"]
---

# System Commands

## system - Execute Shell Command

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Execute simple command
    int result = system("ls -l");

    if (result == -1) {
        printf("Failed to execute command\n");
    } else {
        printf("Command executed with exit code: %d\n", WEXITSTATUS(result));
    }

    return 0;
}
```

## system - String Construc.stdlib.stdion

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    const char* filename = "test.txt";

    // Build command string
    char command[256];
    snprintf(command, sizeof(command), "rm %s", filename);

    printf("Executing: %s\n", command);
    int result = system(command);

    if (result == -1) {
        perror("system failed");
    }

    return 0;
}
```

## Checking Command Success

```c
#include <stdio.h>
#include <stdlib.h>

bool command_success(const char* cmd) {
    int result = system(cmd);

    if (result == -1) {
        return false;
    }

    return WIFEXITED(result) && (WEXITSTATUS(result) == 0);
}

int main() {
    if (command_success("ls /nonexistent")) {
        printf("Command succeeded\n");
    } else {
        printf("Command failed\n");
    }

    if (command_success("echo 'Hello'")) {
        printf("Command succeeded\n");
    } else {
        printf("Command failed\n");
    }

    return 0;
}
```

## popen - Read Command Output

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Open a pipe to read command output
    FILE* pipe = popen("ls -l", "r");

    if (pipe == NULL) {
        perror("popen failed");
        return 1;
    }

    // Read output line by line
    char buffer[256];
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        printf("%s", buffer);
    }

    // Close pipe and get exit status
    int status = pclose(pipe);

    if (status == -1) {
        perror("pclose failed");
    } else {
        printf("Exit status: %d\n", WEXITSTATUS(status));
    }

    return 0;
}
```

## popen - Write to Command

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Open a pipe to write to command
    FILE* pipe = popen("grep 'error'", "w");

    if (pipe == NULL) {
        perror("popen failed");
        return 1;
    }

    // Write data to command
    fprintf(pipe, "This is an error message\n");
    fprintf(pipe, "This is a normal message\n");
    fprintf(pipe, "Another error here\n");

    // Close pipe
    int status = pclose(pipe);

    printf("Exit status: %d\n", WEXITSTATUS(status));

    return 0;
}
```

## popen - Capture Output into Buffer

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* read_command_output(const char* cmd) {
    FILE* pipe = popen(cmd, "r");
    if (pipe == NULL) {
        return NULL;
    }

    // Read output
    char buffer[256];
    char* result = NULL;
    size_t size = 0;

    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        size_t len = strlen(buffer);
        char* new_result = realloc(result, size + len + 1);

        if (new_result == NULL) {
            free(result);
            pclose(pipe);
            return NULL;
        }

        result = new_result;
        strcpy(result + size, buffer);
        size += len;
    }

    pclose(pipe);

    if (result != NULL) {
        result[size] = '\0';
    }

    return result;
}

int main() {
    char* output = read_command_output("echo 'Hello, World!'");

    if (output != NULL) {
        printf("Output: %s", output);
        free(output);
    }

    return 0;
}
```

## Get System Information

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* hostname;
    char* os;
    char* kernel;
} SystemInfo;

SystemInfo get_system_info(void) {
    SystemInfo info = {NULL, NULL, NULL};

    // Get hostname
    FILE* pipe = popen("hostname", "r");
    if (pipe != NULL) {
        char buffer[256];
        if (fgets(buffer, sizeof(buffer), pipe) != NULL) {
            buffer[strcspn(buffer, "\n")] = '\0';
            info.hostname = strdup(buffer);
        }
        pclose(pipe);
    }

    // Get OS
    pipe = popen("uname -s", "r");
    if (pipe != NULL) {
        char buffer[256];
        if (fgets(buffer, sizeof(buffer), pipe) != NULL) {
            buffer[strcspn(buffer, "\n")] = '\0';
            info.os = strdup(buffer);
        }
        pclose(pipe);
    }

    // Get kernel version
    pipe = popen("uname -r", "r");
    if (pipe != NULL) {
        char buffer[256];
        if (fgets(buffer, sizeof(buffer), pipe) != NULL) {
            buffer[strcspn(buffer, "\n")] = '\0';
            info.kernel = strdup(buffer);
        }
        pclose(pipe);
    }

    return info;
}

void free_system_info(SystemInfo* info) {
    free(info->hostname);
    free(info->os);
    free(info->kernel);
}

int main() {
    SystemInfo info = get_system_info();

    printf("System Information:\n");
    if (info.hostname != NULL) {
        printf("  Hostname: %s\n", info.hostname);
    }
    if (info.os != NULL) {
        printf("  OS: %s\n", info.os);
    }
    if (info.kernel != NULL) {
        printf("  Kernel: %s\n", info.kernel);
    }

    free_system_info(&info);

    return 0;
}
```

## Process List

```c
#include <stdio.h>
#include <stdlib.h>

void print_process_list(void) {
    FILE* pipe = popen("ps aux", "r");
    if (pipe == NULL) {
        perror("popen failed");
        return;
    }

    printf("Running processes:\n");
    char buffer[256];
    int count = 0;

    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        printf("%s", buffer);
        count++;
    }

    pclose(pipe);
    printf("\nTotal processes: %d\n", count - 1);
}

int main() {
    print_process_list();
    return 0;
}
```

## Disk Usage Check

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    double used_gb;
    double total_gb;
    double percent;
} DiskUsage;

DiskUsage get_disk_usage(const char* path) {
    DiskUsage usage = {0.0, 0.0, 0.0};

    char command[256];
    snprintf(command, sizeof(command), "df -B1 %s | tail -1", path);

    FILE* pipe = popen(command, "r");
    if (pipe == NULL) {
        return usage;
    }

    char line[256];
    if (fgets(line, sizeof(line), pipe) != NULL) {
        unsigned long total, used;
        sscanf(line, "%*s %lu %lu", &total, &used);

        usage.total_gb = total / (1024.0 * 1024.0 * 1024.0);
        usage.used_gb = used / (1024.0 * 1024.0 * 1024.0);
        usage.percent = (used * 100.0) / total;
    }

    pclose(pipe);

    return usage;
}

int main() {
    DiskUsage usage = get_disk_usage("/");

    printf("Disk Usage (/):\n");
    printf("  Used: %.2f GB\n", usage.used_gb);
    printf("  Total: %.2f GB\n", usage.total_gb);
    printf("  Percentage: %.1f%%\n", usage.percent);

    return 0;
}
```

## Network Check

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool check_internet(void) {
    FILE* pipe = popen("ping -c 1 8.8.8.8 > /dev/null 2>&1", "r");
    if (pipe == NULL) {
        return false;
    }

    int status = pclose(pipe);

    return (status != -1) && (WEXITSTATUS(status) == 0);
}

int main() {
    if (check_internet()) {
        printf("Internet connec.stdlib.stdion available\n");
    } else {
        printf("No internet connec.stdlib.stdion\n");
    }

    return 0;
}
```

## File Count

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int count_files(const char* directory) {
    char command[512];
    snprintf(command, sizeof(command), "find %s -type f | wc -l", directory);

    FILE* pipe = popen(command, "r");
    if (pipe == NULL) {
        return -1;
    }

    char buffer[256];
    int count = 0;

    if (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        count = atoi(buffer);
    }

    pclose(pipe);

    return count;
}

int main() {
    const char* dir = "/tmp";

    int files = count_files(dir);
    if (files >= 0) {
        printf("Files in %s: %d\n", dir, files);
    } else {
        printf("Error counting files\n");
    }

    return 0;
}
```

## Command Timeout

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool run_with_timeout(const char* cmd, int timeout_seconds) {
    char command[512];
    snprintf(command, sizeof(command), "timeout %d %s", timeout_seconds, cmd);

    int result = system(command);

    if (result == -1) {
        return false;
    }

    return WEXITSTATUS(result) == 0;
}

int main() {
    if (run_with_timeout("sleep 2", 3)) {
        printf("Command completed\n");
    } else {
        printf("Command failed or timed out\n");
    }

    return 0;
}
```

> **Warning**: `system()` and `popen()` can be security risks if used with untrusted input. Use safer alternatives when possible.
