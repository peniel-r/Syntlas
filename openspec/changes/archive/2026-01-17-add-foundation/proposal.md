# Change: Foundation - Core Data Structures and Build System

## Why

Syntlas requires a solid foundation of core data structures, parsers, and build configuration before any search or indexing functionality can be implemented. This phase establishes the Neurona data model, YAML frontmatter parsing, and project configuration.

## What Changes

- Define Neurona, Synapse, and Activation data structures in Zig
- Implement YAML frontmatter parser for Markdown files
- Create Markdown content extractor
- Set up build.zig with dependencies
- Implement configuration management (~/.config/syntlas/)
- Establish test framework infrastructure

## Impact

- Affected specs: `foundation`
- Affected code: `src/core/`, `src/config/`, `src/tome/parser.zig`, `build.zig`
- Dependencies: None (this is the first phase)
