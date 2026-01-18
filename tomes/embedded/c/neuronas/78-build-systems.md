---
id: "c.build.systems"
title: Build Systems
category: tools
difficulty: intermediate
tags:
  - make
  - cmake
  - build
  - 
keywords:
  - make
  - cmake
  - build system
  - 
  - dependencies
use_cases:
  - Automating builds
  - Managing dependencies
  - Cross-
  - Project organization
prerequisites:
  - c.preprocessor
  - 
  - command-line
related:
  - c.preprocessor
  - 
next_topics:
  - 
---

# Build Systems

Build systems automate the  process, manage dependencies, and ensure efficient rebuilding.

## Basic Makefile

```makefile
# Simple Makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c11
TARGET = program
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

# Default target
all: $(TARGET)

# Link object files
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Phony targets (not actual files)
.PHONY: all clean run
```

```bash
# Build the project
make

# Clean build artifacts
make clean

# Run the program
make run
```

## Advanced Makefile with Debug/Release

```makefile
# Makefile with debug and release modes
CC = gcc
TARGET = myapp

# Source files
SRCS = main.c utils.c parser.c network.c
OBJS = $(SRCS:.c=.o)

# Debug configuration
DEBUG_CFLAGS = -Wall -Wextra -g -O0 -DDEBUG

# Release configuration
RELEASE_CFLAGS = -Wall -Wextra -O2 -DNDEBUG

# Default to debug mode
CFLAGS = $(DEBUG_CFLAGS)

# Targets
debug: CFLAGS = $(DEBUG_CFLAGS)
debug: $(TARGET)

release: CFLAGS = $(RELEASE_CFLAGS)
release: $(TARGET)
	strip $(TARGET)  # Remove symbols from release

# Build target
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^
	@echo "Build complete: $(TARGET) ($(CFLAGS))"

#  rule
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Generate dependencies
-include $(OBJS:.o=.d)

%.d: %.c
	@$(CC) -MM $< > $@

# Clean
clean:
	rm -f $(OBJS) $(TARGET) *.d

# Install
install: $(TARGET)
	install -m 755 $(TARGET) /usr/local/bin/

# Phony
.PHONY: all debug release clean install
```

## Makefile with Library Support

```makefile
# Makefile for library + executable
CC = gcc
AR = ar
RANLIB = ranlib

# Library name and version
LIB_NAME = mylib
LIB_VERSION = 1.0.0
LIB_STATIC = lib$(LIB_NAME).a
LIB_SHARED = lib$(LIB_NAME).so.$(LIB_VERSION)

# Sources
LIB_SRCS = libutil.c libparser.c
LIB_OBJS = $(LIB_SRCS:.c=.o)

APP_SRCS = main.c
APP_OBJS = $(APP_SRCS:.c=.o)

CFLAGS = -Wall -Wextra -fPIC -I.

# Default target
all: $(LIB_STATIC) $(LIB_SHARED) app

# Build static library
$(LIB_STATIC): $(LIB_OBJS)
	$(AR) rcs $@ $^
	$(RANLIB) $@

# Build shared library
$(LIB_SHARED): $(LIB_OBJS)
	$(CC) -shared -Wl,-soname,lib$(LIB_NAME).so -o $@ $^
	ln -sf $@ lib$(LIB_NAME).so

# Build executable
app: $(APP_OBJS) $(LIB_STATIC)
	$(CC) -o $@ $(APP_OBJS) -L. -l$(LIB_NAME)

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(LIB_OBJS) $(APP_OBJS) $(LIB_STATIC) $(LIB_SHARED)
	rm -f lib$(LIB_NAME).so app

# Install
install: all
	install -m 644 $(LIB_STATIC) /usr/local/lib/
	install -m 755 $(LIB_SHARED) /usr/local/lib/
	ln -sf $(LIB_SHARED) /usr/local/lib/lib$(LIB_NAME).so
	install -m 644 libutil.h /usr/local/include/

.PHONY: all clean install
```

## CMake Basics

```cmake
# CMakeLists.txt - Basic CMake project
cmake_minimum_required(VERSION 3.10)
project(MyApp VERSION 1.0.0)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Add executable
add_executable(myapp main.c utils.c)

# Set compiler warnings
if(MSVC)
    target_compile_options(myapp PRIVATE /W4)
else()
    target_compile_options(myapp PRIVATE -Wall -Wextra)
endif()

# Installation
install(TARGETS myapp DESTINATION bin)
```

```bash
# Build with CMake
mkdir build
cd build
cmake ..
cmake --build .
```

## CMake with Multiple Targets

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0)

set(CMAKE_C_STANDARD 11)

# Sources
set(LIB_SOURCES libutil.c libparser.c)
set(APP_SOURCES main.c)

# Create static library
add_library(mylib STATIC ${LIB_SOURCES})

# Create shared library
add_library(mylib_shared SHARED ${LIB_SOURCES})
set_target_properties(mylib_shared PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# Create executable
add_executable(myapp ${APP_SOURCES})

# Link library to executable
target_link_libraries(myapp PRIVATE mylib)

# Include directories
target_include_directories(mylib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

# Installation
install(TARGETS mylib mylib_shared myapp
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(FILES libutil.h libparser.h DESTINATION include)
```

## CMake with Debug/Release

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0)

set(CMAKE_C_STANDARD 11)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# Compiler flags
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

# Executable
add_executable(myapp main.c utils.c)

# Installation rules for different builds
install(TARGETS myapp
    RUNTIME DESTINATION bin
    CONFIGURATIONS Release
)
```

```bash
# Debug build
cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build .

# Release build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build .
```

## CMake with External Dependencies

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0)

set(CMAKE_C_STANDARD 11)

# Find required packages
find_package(Threads REQUIRED)
find_package(PkgConfig REQUIRED)

# Find optional packages
pkg_check_modules(JSONC json-c)
pkg_check_modules(OPENSSL openssl)

# Executable
add_executable(myapp main.c)

# Link required packages
target_link_libraries(myapp PRIVATE Threads::Threads)

# Link optional packages if found
if(JSONC_FOUND)
    target_compile_definitions(myapp PRIVATE HAVE_JSONC)
    target_include_directories(myapp PRIVATE ${JSONC_INCLUDE_DIRS})
    target_link_libraries(myapp PRIVATE ${JSONC_LIBRARIES})
    message(STATUS "JSON-C support enabled")
endif()

if(OPENSSL_FOUND)
    target_compile_definitions(myapp PRIVATE HAVE_OPENSSL)
    target_include_directories(myapp PRIVATE ${OPENSSL_INCLUDE_DIRS})
    target_link_libraries(myapp PRIVATE ${OPENSSL_LIBRARIES})
    message(STATUS "OpenSSL support enabled")
endif()
```

## CMake with Testing

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0)

set(CMAKE_C_STANDARD 11)

# Enable testing
enable_testing()

# Main library
add_library(mylib STATIC lib.c)

# Test executable
add_executable(tests test.c)
target_link_libraries(tests PRIVATE mylib)

# Add test
add_test(NAME basic_tests COMMAND tests)

# Multiple test suites
add_executable(test_utils test_utils.c)
target_link_libraries(test_utils PRIVATE mylib)
add_test(NAME utils_tests COMMAND test_utils)

add_executable(test_parser test_parser.c)
target_link_libraries(test_parser PRIVATE mylib)
add_test(NAME parser_tests COMMAND test_parser)
```

```bash
# Run tests
cd build
ctest --verbose

# Run specific test
ctest -R utils_tests --verbose
```

## Makefile Pattern Rules

```makefile
# Pattern rules for generic 
CC = gcc
CFLAGS = -Wall -Wextra

# Generic rule for .c -> .o
%.o: %.c
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Generic rule for .cpp -> .o
%.o: %.cpp
	@echo "Compiling $<..."
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Generic rule for generating dependency files
%.d: %.c
	@echo "Generating dependencies for $<..."
	@$(CC) -MM $< > $@

# Include all dependency files
-include $(wildcard *.d)
```

## Makefile with Automatic Dependencies

```makefile
# Makefile with automatic dependency generation
CC = gcc
CFLAGS = -Wall -Wextra -MMD -MP
TARGET = myapp

# Find all C source files
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

# Link
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Include generated dependencies
-include $(OBJS:.o=.d)

# Clean
clean:
	rm -f $(OBJS) $(TARGET) *.d

.PHONY: clean
```

## Cross- with CMake

```cmake
cmake_minimum_required(VERSION 3.10)
project(CrossCompileTest C)

set(CMAKE_C_STANDARD 11)

# System information
message(STATUS "System: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Compiler: ${CMAKE_C_COMPILER}")

# Conditional 
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Building for Linux")
    add_definitions(-DPLATFORM_LINUX)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Building for Windows")
    add_definitions(-DPLATFORM_WINDOWS)
endif()

# Executable
add_executable(myapp main.c)
```

```bash
# Cross-compile for ARM
cmake -DCMAKE_TOOLCHAIN_FILE=arm-toolchain.cmake ..

# arm-toolchain.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH /usr/arm-linux-gnueabihf)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```

## Makefile Variables and 

```makefile
# Variables
CC = gcc
CFLAGS = -Wall -Wextra
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

# 
# Substitution: $(patsubst pattern,replacement,text)
OBJS = $(patsubst %.c,%.o,$(SOURCES))

# Filter: $(filter pattern...,text)
C_SOURCES = $(filter %.c,$(SOURCES))

# Notdir: $(notdir text)
FILES = $(notdir $(SOURCES))

# Addprefix: $(addprefix prefix,names...)
BUILD_OBJS = $(addprefix build/,$(OBJECTS))

# Addsuffix: $(addsuffix suffix,names...)
BACKUP_FILES = $(addsuffix .backup,$(SOURCES))

# Wildcard: $(wildcard pattern...)
HEADERS = $(wildcard *.h)

# Shell command
COMMIT_HASH = $(shell git rev-parse --short HEAD)
CFLAGS += -DGIT_COMMIT=\"$(COMMIT_HASH)\"
```

## Best Practices

### Organize 

```makefile
# Good structure with clear sec.stdlib.stdions

# === Configuration ===
CC = gcc
CFLAGS = -Wall -Wextra

# === Sources ===
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

# === Targets ===
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# === Cleanup ===
clean:
	rm -f $(OBJS) $(TARGET)

# === Phony ===
.PHONY: all clean
```

### Use CMake for Cross-Platform

```cmake
# Use CMake for portability
if(WIN32)
    # Windows-specific
elseif(UNIX)
    # Unix-specific
endif()

# Use generator expressions
$<CONFIG:Debug>
$<CONFIG:Release>
```

### Separate Build and Source

```bash
# Always use out-of-source builds
mkdir build
cd build
cmake ..
make

# Keeps source directory clean
```

## Common Pitfalls

### 1. Hardcoding Paths

```makefile
# WRONG - Hardcoded paths
/usr/local/include

# CORRECT - Use variables
INCLUDE_DIR = /usr/local/include
```

### 2. Not Handling Dependencies

```makefile
# WRONG - No dependencies
main.o: main.c
	$(CC) -c main.c

# CORRECT - With dependencies
main.o: main.c utils.h
	$(CC) -c main.c
```

### 3. Forcing Rebuilds Unnecessarily

```makefile
# WRONG - Always rebuilds
all:
	$(CC) -o app *.c

# CORRECT - Only rebuilds changed files
all: $(OBJS)
	$(CC) -o app $(OBJS)
```

> **Note**: Choose the right build system for your project size and requirements. Make is simple and powerful but can become complex for large projects. CMake provides better cross-platform support and modern features. Always maintain clean, well-documented build configurations.
