---
id: 88-file-descriptors
title: File Descriptors
category: system
difficulty: intermediate
tags:
  - file-descriptors
  - dup
  - pipe
  - redirection
keywords:
  - file descriptor
  - dup
  - dup2
  - pipe
  - redirection
use_cases:
  - File I/O
  - Process communication
  - Output redirection
  - Input/output control
prerequisites:
  - file-operations
  - process-management
related:
  - file-operations
  - inter-process-communication
next_topics:
  - terminal-control
---

# File Descriptors

File descriptors are low-level handles for I/O operations.

## Basic File Descriptor Operations

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(void) {
    // Open file (low-level)
    int fd = open("data.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("open failed");
        return 1;
    }

    // Write to file descriptor
    const char *text = "Hello, file descriptor!\n";
    ssize_t bytes_written = write(fd, text, strlen(text));
    if (bytes_written == -1) {
        perror("write failed");
        close(fd);
        return 1;
    }

    printf("Wrote %zd bytes\n", bytes_written);

    // Close file descriptor
    close(fd);

    return 0;
}
```

## Standard File Descriptors

```c
#include <unistd.h>
#include <string.h>

int main(void) {
    // Standard file descriptors
    // STDIN_FILENO  = 0  (stdin)
    // STDOUT_FILENO = 1  (stdout)
    // STDERR_FILENO = 2  (stderr)

    const char *msg = "Hello, stdout!\n";
    write(STDOUT_FILENO, msg, strlen(msg));

    const char *error = "Error message to stderr\n";
    write(STDERR_FILENO, error, strlen(error));

    return 0;
}
```

## File Descriptor Duplication

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
    // Open file
    int fd1 = open("data.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd1 == -1) {
        perror("open failed");
        return 1;
    }

    // Duplicate file descriptor
    int fd2 = dup(fd1);
    if (fd2 == -1) {
        perror("dup failed");
        close(fd1);
        return 1;
    }

    printf("fd1 = %d, fd2 = %d\n", fd1, fd2);

    // Both descriptors point to same file
    write(fd1, "From fd1\n", 10);
    write(fd2, "From fd2\n", 10);

    close(fd1);
    close(fd2);

    return 0;
}
```

## dup2 - Redirection

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
    // Open file for output
    int fd = open("output.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("open failed");
        return 1;
    }

    // Redirect stdout to file
    dup2(fd, STDOUT_FILENO);

    // This output goes to file
    printf("This goes to output.txt\n");
    fprintf(stderr, "This still goes to stderr\n");

    // Close file descriptor
    close(fd);

    return 0;
}
```

## Pipe with File Descriptors

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(void) {
    int pipefd[2];
    pid_t pid;
    char write_msg[] = "Hello through pipe!";
    char read_msg[100];

    // Create pipe
    if (pipe(pipefd) == -1) {
        perror("pipe failed");
        return 1;
    }

    // Fork process
    pid = fork();

    if (pid == 0) {
        // Child - read from pipe
        close(pipefd[1]);  // Close write end

        ssize_t bytes = read(pipefd[0], read_msg, sizeof(read_msg));
        if (bytes > 0) {
            read_msg[bytes] = '\0';
            printf("Child received: %s\n", read_msg);
        }

        close(pipefd[0]);
    } else {
        // Parent - write to pipe
        close(pipefd[0]);  // Close read end

        write(pipefd[1], write_msg, strlen(write_msg) + 1);

        close(pipefd[1]);
        wait(NULL);
    }

    return 0;
}
```

## File Descriptor Flags

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
    int fd = open("data.txt", O_RDONLY);
    if (fd == -1) {
        perror("open failed");
        return 1;
    }

    // Get file descriptor flags
    int flags = fcntl(fd, F_GETFL);
    if (flags == -1) {
        perror("fcntl failed");
        close(fd);
        return 1;
    }

    printf("File flags: %d\n", flags);

    // Check if O_NONBLOCK is set
    if (flags & O_NONBLOCK) {
        printf("Non-blocking mode\n");
    } else {
        printf("Blocking mode\n");
    }

    // Set non-blocking mode
    flags |= O_NONBLOCK;
    if (fcntl(fd, F_SETFL, flags) == -1) {
        perror("fcntl failed");
    }

    close(fd);
    return 0;
}
```

## Closing All File Descriptors

```c
#include <unistd.h>
#include <limits.h>

void close_all_fds_except(int *except_fds, int count) {
    // Close all file descriptors except specified ones
    for (int fd = 0; fd < sysconf(_SC_OPEN_MAX); fd++) {
        int keep = 0;
        for (int i = 0; i < count; i++) {
            if (fd == except_fds[i]) {
                keep = 1;
                break;
            }
        }
        if (!keep) {
            close(fd);
        }
    }
}

int main(void) {
    int keep_fds[] = {STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO};
    close_all_fds_except(keep_fds, 3);
    return 0;
}
```

## File Descriptor Passing (Unix Domain Sockets)

```c
// sender.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define SOCKET_PATH "/tmp/fd_socket"
#define FD_TO_SEND "/tmp/test.txt"

int main(void) {
    int sockfd, client_fd;
    struct sockaddr_un server_addr;

    // Open file to send
    int file_fd = open(FD_TO_SEND, O_RDONLY);
    if (file_fd == -1) {
        perror("open failed");
        return 1;
    }

    // Create Unix domain socket
    sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket failed");
        close(file_fd);
        return 1;
    }

    server_addr.sun_family = AF_UNIX;
    strcpy(server_addr.sun_path, SOCKET_PATH);

    bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    listen(sockfd, 1);

    printf("Waiting for receiver...\n");
    client_fd = accept(sockfd, NULL, NULL);
    if (client_fd == -1) {
        perror("accept failed");
        close(sockfd);
        close(file_fd);
        return 1;
    }

    // Send file descriptor
    struct msghdr msg = {0};
    char iov_data[1];
    struct iovec iov = {.iov_base = iov_data, .iov_len = 1};

    char control_data[CMSG_SPACE(sizeof(int))];
    struct cmsghdr *cmsg = (struct cmsghdr *)control_data;
    cmsg->cmsg_len = CMSG_LEN(sizeof(int));
    cmsg->cmsg_level = SOL_SOCKET;
    cmsg->cmsg_type = SCM_RIGHTS;
    *(int *)CMSG_DATA(cmsg) = file_fd;

    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    msg.msg_control = control_data;
    msg.msg_controllen = sizeof(control_data);

    if (sendmsg(client_fd, &msg, 0) == -1) {
        perror("sendmsg failed");
    } else {
        printf("File descriptor sent\n");
    }

    close(client_fd);
    close(sockfd);
    close(file_fd);
    unlink(SOCKET_PATH);

    return 0;
}
```

```c
// receiver.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define SOCKET_PATH "/tmp/fd_socket"

int main(void) {
    int sockfd;
    struct sockaddr_un server_addr;

    sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket failed");
        return 1;
    }

    server_addr.sun_family = AF_UNIX;
    strcpy(server_addr.sun_path, SOCKET_PATH);

    if (connect(sockfd, (struct sockaddr *)&server_addr,
                sizeof(server_addr)) == -1) {
        perror("connect failed");
        close(sockfd);
        return 1;
    }

    // Receive file descriptor
    struct msghdr msg = {0};
    char iov_data[1];
    struct iovec iov = {.iov_base = iov_data, .iov_len = 1};

    char control_data[256];
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    msg.msg_control = control_data;
    msg.msg_controllen = sizeof(control_data);

    if (recvmsg(sockfd, &msg, 0) == -1) {
        perror("recvmsg failed");
        close(sockfd);
        return 1;
    }

    struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
    if (cmsg && cmsg->cmsg_type == SCM_RIGHTS) {
        int received_fd = *(int *)CMSG_DATA(cmsg);
        printf("Received file descriptor: %d\n", received_fd);

        // Use received file descriptor
        char buffer[1024];
        ssize_t bytes = read(received_fd, buffer, sizeof(buffer) - 1);
        if (bytes > 0) {
            buffer[bytes] = '\0';
            printf("File contents: %s\n", buffer);
        }
        close(received_fd);
    }

    close(sockfd);
    return 0;
}
```

## Best Practices

### Always Close File Descriptors

```c
// GOOD - Always close
int fd = open("file.txt", O_RDONLY);
if (fd >= 0) {
    // Use fd...
    close(fd);
}

// AVOID - Forgetting to close
int fd = open("file.txt", O_RDONLY);
// Use fd...
// Forgot to close!
```

### Check Return Values

```c
// GOOD - Check all operations
int fd = open("file.txt", O_RDONLY);
if (fd == -1) {
    perror("open failed");
    return 1;
}

ssize_t bytes = read(fd, buffer, size);
if (bytes == -1) {
    perror("read failed");
    close(fd);
    return 1;
}
```

### Use dup2 for Redirection

```c
// GOOD - dup2 closes target if needed
int fd = open("output.txt", O_WRONLY);
dup2(fd, STDOUT_FILENO);  // Redirects stdout

// AVOID - Using dup manually
int old_stdout = dup(STDOUT_FILENO);
close(STDOUT_FILENO);
int new_stdout = dup(fd);  // More complex
```

## Common Pitfalls

### 1. File Descriptor Leaks

```c
// WRONG - Leak file descriptors
while (1) {
    int fd = open("file.txt", O_RDONLY);
    // Forgot to close fd!
}

// CORRECT - Always close
while (1) {
    int fd = open("file.txt", O_RDONLY);
    if (fd >= 0) {
        // Use fd...
        close(fd);
    }
}
```

### 2. Using Closed Descriptors

```c
// WRONG - Using closed fd
int fd = open("file.txt", O_RDONLY);
close(fd);
read(fd, buffer, size);  // Undefined behavior!

// CORRECT - Check if still open
int fd = open("file.txt", O_RDONLY);
close(fd);
// Don't use fd anymore
```

### 3. Ignoring dup/dup2 Errors

```c
// WRONG - Not checking return value
dup2(fd, STDOUT_FILENO);

// CORRECT - Check return value
if (dup2(fd, STDOUT_FILENO) == -1) {
    perror("dup2 failed");
    close(fd);
    return 1;
}
```

> **Note: File descriptors are a limited resource. Always close them when done. Be careful with descriptor redirection and duplication. Use appropriate flags for your I/O requirements.
