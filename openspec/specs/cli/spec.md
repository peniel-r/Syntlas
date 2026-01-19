# cli Specification

## Purpose
TBD - created by archiving change add-cli-output. Update Purpose after archive.
## Requirements
### Requirement: CLI Command Interface

The system SHALL provide a command-line interface with the following commands:

- `search <query>` - Search neuronas
- `docs <neurona-id>` - View full neurona documentation
- `snippet <neurona-id>` - Extract code snippets
- `install <source>` - Install tome
- `list [--tomes|--neuronas]` - List items
- `create-tome <path>` - Create new tome
- `validate-tome <path>` - Validate tome

#### Scenario: Basic search command

- **WHEN** `syntlas search "async await"` is executed
- **THEN** matching neuronas are displayed with relevance scores

#### Scenario: View documentation

- **WHEN** `syntlas docs py.async.basics` is executed
- **THEN** the full neurona content is displayed

---

### Requirement: Text Output Formatting

The system SHALL format text output for terminal display:

- Syntax highlighting for code blocks
- Terminal width-aware wrapping
- Paging for long output
- Color-coded result metadata

#### Scenario: Syntax highlighted code

- **WHEN** a Python code snippet is displayed
- **THEN** keywords are highlighted according to theme

---

### Requirement: JSON Output Formatting

The system SHALL provide JSON output via --json flag:

- Structured schema for all command outputs
- Search results with scores and metadata
- Streaming support for large result sets
- Agent-friendly format

#### Scenario: JSON search output

- **WHEN** `syntlas search "async" --json` is executed
- **THEN** results are returned as valid JSON array

---

### Requirement: Color Themes

The system SHALL support color themes:

- Built-in themes (Monokai, Solarized Dark/Light)
- User-configurable themes via config file
- NO_COLOR environment variable support
- Terminal capability detection

#### Scenario: Theme selection

- **WHEN** user sets theme: "solarized-dark" in config
- **THEN** all output uses Solarized Dark colors

---

### Requirement: Help System

The system SHALL provide comprehensive help:

- --help flag for all commands
- `syntlas help <command>` for detailed help
- Shell completion scripts (bash, zsh, fish, pwsh)
- Generated man page

#### Scenario: Command help

- **WHEN** `syntlas search --help` is executed
- **THEN** search command usage and options are displayed

---

### Requirement: Error Handling

The system SHALL provide user-friendly error messages:

- Actionable error descriptions
- Suggestions for resolution
- --debug flag for verbose output
- Exit codes for scripting

#### Scenario: Invalid command error

- **WHEN** user runs `syntlas serach` (typo)
- **THEN** error message suggests "Did you mean: search?"

