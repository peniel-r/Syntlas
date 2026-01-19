# Change: CLI & Output - Complete Command-Line Interface

## Why

The CLI is the primary user interface for Syntlas. This phase implements all commands (search, docs, snippet, install, list, create-tome, validate-tome), output formatters (text, JSON), and user experience features like syntax highlighting and color themes.

## What Changes

- Implement CLI command parser with all commands
- Build text output formatter with syntax highlighting
- Build JSON output formatter (agent-friendly)
- Add color themes (Monokai, Solarized, etc.)
- Create optional interactive/TUI mode
- Implement help system and documentation
- Add error handling with user-friendly messages

## Impact

- Affected specs: `cli`
- Affected code: `src/cli/`, `src/output/`, `src/main.zig`
- Dependencies: Phase 3 (Search Algorithm) must be complete

