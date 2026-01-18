---
id: "c.stdlib.process"
title: "Process Management"
category: stdlib
difficulty: advanced
tags: [c, process, fork, exec, pid]
keywords: [fork, exec, waitpid, getpid, ppid]
use_cases: [multi-processing, subprocess management, system calls]
prerequisites: ["c.stdlib.system"]
related: ["c.stdlib.signal"]
next_topics: ["c.stdlib.threads"]
---

# Process Management

## fork - Create Process

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == -1) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {
        // Child process
        printf("Child process (PID: %d)\n", getpid());
        return 0;
    } else {
        // Parent process
        printf("Parent process (PID: %d)\n", getpid());
        printf("Created child with PID: %d\n", pid);

        int status;
        waitpid(pid, &status, 0);

        printf("Child exited with status: %d\n", WEXITSTATUS(status));
    }

    return 0;
}
```

## exec - Execute Program

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    printf("Before exec\n");

    // Execute ls command
    char* args[] = {"ls", "-l", NULL};
    execvp("ls", args);

    // This line will not be reached if exec succeeds
    perror("exec failed");
    return 1;
}
```

## fork + exec

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == -1) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {
        // Child process - execute command
        char* args[] = {"ls", "-l", NULL};
        execvp("ls", args);
        perror("exec failed");
        return 1;
    } else {
        // Parent process - wait for child
        int status;
        waitpid(pid, &status, 0);
        printf("Child exited with status: %d\n", WEXITSTATUS(status));
    }

    return 0;
}
```

## wait - Wait for Child

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        printf("Child process\n");
        return 42;
    } else if (pid > 0) {
        int status;
        wait(&status);

        printf("Child exited\n");
        printf("Exit status: %d\n", WEXITSTATUS(status));

        if (WIFEXITED(status)) {
            printf("Normal termination\n");
        } else if (WIFSIGNALED(status)) {
            printf("Killed by signal: %d\n", WTERMSIG(status));
        }
    }

    return 0;
}
```

## getpid - Get Process ID

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main() {
    pid_t pid = getpid();
    pid_t ppid = getppid();

    printf("Process ID: %d\n", pid);
    printf("Parent process ID: %d\n", ppid);

    return 0;
}
```

## exec Variants

```c
#include <stdio.h>
#include <unistd.h>

int main() {
    // execl - list of arguments
    char* args1[] = {"ls", "-l", NULL};
    execl("/bin/ls", "ls", "-l", NULL);

    // execv - array of arguments
    char* args2[] = {"ls", "-l", NULL};
    execv("/bin/ls", args2);

    // execvp - search in PATH
    char* args3[] = {"ls", "-l", NULL};
    execvp("ls", args3);

    // execlp - search in PATH, list of arguments
    execlp("ls", "ls", "-l", NULL);

    perror("exec failed");
    return 1;
}
```

## Pipe Communication

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main() {
    int pipefd[2];
    pid_t pid;

    if (pipe(pipefd) == -1) {
        perror("pipe failed");
        return 1;
    }

    pid = fork();

    if (pid == -1) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {
        // Child process - read from pipe
        close(pipefd[1]);

        char buffer[1024];
        read(pipefd[0], buffer, sizeof(buffer));
        printf("Child received: %s\n", buffer);

        close(pipefd[0]);
    } else {
        // Parent process - write to pipe
        close(pipefd[0]);

        const char* message = "Hello from parent";
        write(pipefd[1], message, strlen(message) + 1);

        close(pipefd[1]);
        wait(NULL);
    }

    return 0;
}
```

## Process Group

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        // Create new process group
        setpgid(0, 0);

        printf("Child PID: %d, PGID: %d\n", getpid(), getpgrp());
        sleep(2);
        return 0;
    } else {
        wait(NULL);
        printf("Child finished\n");
    }

    return 0;
}
```

## Environment Variables in exec

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    // Prepare environment
    char* env[] = {
        "PATH=/bin:/usr/bin",
        "HOME=/home/user",
        NULL
    };

    // Execute with custom environment
    char* args[] = {"env", NULL};
    execle("/usr/bin/env", "env", args, env);

    perror("exec failed");
    return 1;
}
```

## Zombie Processes

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

void sigchld_handler(int sig) {
    int status;
    pid_t pid;

    // Reap all zombie children
    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        printf("Reaped zombie process: %d\n", pid);
    }
}

int main() {
    // Register SIGCHLD handler
    signal(SIGCHLD, sigchld_handler);

    // Create child processes
    for (int i = 0; i < 3; i++) {
        pid_t pid = fork();
        if (pid == 0) {
            return 0;
        }
    }

    // Wait a bit
    sleep(1);

    return 0;
}
```

## Process Hierarchy

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

void print_hierarchy(int depth) {
    printf("%*sPID %d, PPID %d\n", depth * 2, ", getpid(), getppid());
}

int main() {
    pid_t pid1 = fork();

    if (pid1 == 0) {
        // Level 1 child
        print_hierarchy(1);

        pid_t pid2 = fork();

        if (pid2 == 0) {
            // Level 2 child
            print_hierarchy(2);
            return 0;
        }

        wait(NULL);
        return 0;
    }

    print_hierarchy(0);
    wait(NULL);
    return 0;
}
```

## Orphan Processes

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        // Child - become orphan
        printf("Child PID: %d, PPID: %d\n", getpid(), getppid());

        // Kill parent to create orphan
        kill(getppid(), SIGTERM);

        sleep(2);

        // Check new parent (usually init/systemd)
        printf("After parent death - New PPID: %d\n", getppid());
        return 0;
    } else {
        wait(NULL);
    }

    return 0;
}
```

## Process Status

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        return 42;
    } else {
        int status;
        waitpid(pid, &status, 0);

        printf("Process exited\n");

        if (WIFEXITED(status)) {
            printf("Exit code: %d\n", WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            printf("Terminated by signal: %d\n", WTERMSIG(status));
        } else if (WIFSTOPPED(status)) {
            printf("Stopped by signal: %d\n", WSTOPSIG(status));
        }

        if (WCOREDUMP(status)) {
            printf("Core dumped\n");
        }
    }

    return 0;
}
```

## Multiple Children

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    const int num_children = 3;

    for (int i = 0; i < num_children; i++) {
        pid_t pid = fork();

        if (pid == 0) {
            // Child process
            printf("Child %d (PID: %d)\n", i, getpid());
            return i;
        }
    }

    // Wait for all children
    int status;
    pid_t pid;
    int count = 0;

    while ((pid = wait(&status)) != -1 && count < num_children) {
        printf("Child %d (PID %d) exited\n", WEXITSTATUS(status), pid);
        count++;
    }

    return 0;
}
```

## exec with I/O Redirectionn

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    // Redirect stdout to file
    int fd = open("output.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("open failed");
        return 1;
    }

    dup2(fd, STDOUT_FILENO);
    close(fd);

    // Execute command (output goes to file)
    char* args[] = {"ls", "-l", NULL};
    execvp("ls", args);

    perror("exec failed");
    return 1;
}
```

> **Note**: Process management is Unix-specific. Windows uses different APIs (CreateProcess, WaitForSingleObject).
