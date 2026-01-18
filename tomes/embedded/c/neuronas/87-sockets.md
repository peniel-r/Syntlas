---
id: "c.network.sockets_advanced"
title: Socket Programming
category: system
difficulty: advanced
tags:
  - sockets
  - tcp
  - udp
  - networking
keywords:
  - socket
  - tcp
  - udp
  - bind
  - listen
  - accept
use_cases:
  - Network communication
  - Client-server applications
  - Distributed systems
  - Network protocols
prerequisites:
  - 
  - 
  - 
related:
  - 
  - c.ipc.main
next_topics:
  - c.stdlib.fd
---

# Socket Programming

Sockets provide a mechanism for inter-process communication over networks.

## TCP Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Set socket options
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    // Bind socket to address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(server_fd);
        return 1;
    }

    // Listen for connec.stdlib.stdions
    if (listen(server_fd, 5) == -1) {
        perror("Listen failed");
        close(server_fd);
        return 1;
    }

    printf("Server listening on port %d\n", PORT);

    // Accept connec.stdlib.stdion
    client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
    if (client_fd == -1) {
        perror("Accept failed");
        close(server_fd);
        return 1;
    }

    printf("Client connected\n");

    // Receive data
    ssize_t bytes_received = recv(client_fd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);

        // Send response
        const char *response = "Hello from server!";
        send(client_fd, response, strlen(response), 0);
    }

    close(client_fd);
    close(server_fd);

    return 0;
}
```

## TCP Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 8080
#define SERVER_IP "127.0.0.1"
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];

    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr) <= 0) {
        perror("Invalid address");
        close(sockfd);
        return 1;
    }

    // Connect to server
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Connec.stdlib.stdion failed");
        close(sockfd);
        return 1;
    }

    printf("Connected to server\n");

    // Send data
    const char *message = "Hello from client!";
    send(sockfd, message, strlen(message), 0);
    printf("Sent: %s\n", message);

    // Receive response
    ssize_t bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    close(sockfd);
    return 0;
}
```

## UDP Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Bind socket
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(sockfd);
        return 1;
    }

    printf("UDP server listening on port %d\n", PORT);

    while (1) {
        // Receive data
        ssize_t bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                       (struct sockaddr *)&client_addr,
                                       &addr_len);
        if (bytes_received > 0) {
            buffer[bytes_received] = '\0';
            printf("Received from %s:%d: %s\n",
                   inet_ntoa(client_addr.sin_addr),
                   ntohs(client_addr.sin_port),
                   buffer);

            // Send response
            const char *response = "ACK";
            sendto(sockfd, response, strlen(response), 0,
                  (struct sockaddr *)&client_addr, addr_len);
        }
    }

    close(sockfd);
    return 0;
}
```

## UDP Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 8080
#define SERVER_IP "127.0.0.1"
#define BUFFER_SIZE 1024

int main(void) {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];

    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("Socket creation failed");
        return 1;
    }

    // Configure server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr);

    // Send data
    const char *message = "Hello via UDP!";
    sendto(sockfd, message, strlen(message), 0,
          (struct sockaddr *)&server_addr, sizeof(server_addr));
    printf("Sent: %s\n", message);

    // Receive response
    socklen_t addr_len = sizeof(server_addr);
    ssize_t bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                     (struct sockaddr *)&server_addr,
                                     &addr_len);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    close(sockfd);
    return 0;
}
```

## Non-Blocking I/O with select()

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/select.h>

#define PORT 8080
#define MAX_CLIENTS 10

int main(void) {
    int server_fd, client_fds[MAX_CLIENTS] = {0}, max_sd, new_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[1024];
    fd_set read_fds;

    // Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket failed");
        return 1;
    }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    listen(server_fd, 5);

    printf("Server listening on port %d\n", PORT);

    while (1) {
        FD_ZERO(&read_fds);
        FD_SET(server_fd, &read_fds);
        max_sd = server_fd;

        // Add client sockets to set
        for (int i = 0; i < MAX_CLIENTS; i++) {
            if (client_fds[i] > 0) {
                FD_SET(client_fds[i], &read_fds);
                if (client_fds[i] > max_sd) {
                    max_sd = client_fds[i];
                }
            }
        }

        // Wait for activity
        int activity = select(max_sd + 1, &read_fds, NULL, NULL, NULL);

        if (activity < 0) {
            perror("select error");
            break;
        }

        // New connec.stdlib.stdion
        if (FD_ISSET(server_fd, &read_fds)) {
            new_socket = accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
            if (new_socket < 0) {
                perror("accept failed");
                continue;
            }

            printf("New connec.stdlib.stdion\n");

            // Add to client array
            for (int i = 0; i < MAX_CLIENTS; i++) {
                if (client_fds[i] == 0) {
                    client_fds[i] = new_socket;
                    break;
                }
            }
        }

        // Check clients for data
        for (int i = 0; i < MAX_CLIENTS; i++) {
            int sd = client_fds[i];
            if (sd > 0 && FD_ISSET(sd, &read_fds)) {
                int valread = read(sd, buffer, 1024);
                if (valread == 0) {
                    // Client disconnected
                    close(sd);
                    client_fds[i] = 0;
                } else if (valread > 0) {
                    buffer[valread] = '\0';
                    printf("Received: %s\n", buffer);
                    send(sd, buffer, valread, 0);
                }
            }
        }
    }

    close(server_fd);
    return 0;
}
```

## Socket Options

```c
#include <sys/socket.h>

// Reuse address (allows restarting server quickly)
int reuse = 1;
setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));

// Set send buffer size
int send_buf = 65536;
setsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &send_buf, sizeof(send_buf));

// Set receive buffer size
int recv_buf = 65536;
setsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &recv_buf, sizeof(recv_buf));

// Set timeout
struct timeval timeout = {.tv_sec = 10, .tv_usec = 0};
setsockopt(sockfd, SOL_SOCKET, SO_Rc.stdlib.timeO, &timeout, sizeof(timeout));
setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));

// Enable keep-alive
int keepalive = 1;
setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &keepalive, sizeof(keepalive));
```

## Best Practices

### Always Check Return Values

```c
// GOOD - Check all operations
sockfd = socket(AF_INET, SOCK_STREAM, 0);
if (sockfd == -1) {
    perror("Socket failed");
    return 1;
}

if (connect(sockfd, ...) == -1) {
    perror("Connec.stdlib.stdion failed");
    close(sockfd);
    return 1;
}
```

### Handle Partial Sends/Receives

```c
// Handle partial sends
size_t total_sent = 0;
while (total_sent < data_size) {
    ssize_t sent = send(sockfd, data + total_sent,
                     data_size - total_sent, 0);
    if (sent <= 0) break;
    total_sent += sent;
}
```

### Set Timeouts

```c
// Prevent blocking forever
struct timeval timeout = {.tv_sec = 30, .tv_usec = 0};
setsockopt(sockfd, SOL_SOCKET, SO_Rc.stdlib.timeO, &timeout, sizeof(timeout));
setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
```

## Common Pitfalls

### 1. Network Byte Order

```c
// WRONG - Using host byte order
server_addr.sin_port = 8080;

// CORRECT - Convert to network byte order
server_addr.sin_port = htons(8080);
```

### 2. Not Closing Sockets

```c
// WRONG - Resource leak
sockfd = socket(...);
// Forgot to close!

// CORRECT - Always close
sockfd = socket(...);
// Use socket...
close(sockfd);
```

### 3. Ignoring Return Values

```c
// WRONG - send/recv might fail
send(sockfd, data, size, 0);
recv(sockfd, buffer, size, 0);

// CORRECT - Check return values
ssize_t sent = send(sockfd, data, size, 0);
if (sent < 0) {
    // Handle error
}
```

> **Note: Socket programming requires careful error handling and resource management. Always validate input data, handle partial data transfers, and implement timeout mechanisms. Consider using established networking libraries for production applications.
