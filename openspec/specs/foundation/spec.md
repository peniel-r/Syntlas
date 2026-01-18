# foundation Specification

## Purpose

TBD - created by archiving change add-foundation. Update Purpose after archive.

## Requirements

### Requirement: Neurona Data Structure

The system SHALL define a Neurona struct as the atomic unit of knowledge containing:

- Unique identifier (hierarchical dotted notation)
- Title and category metadata
- Difficulty level and tags
- Neural connections (prerequisites, related, next_topics)
- Quality indicators and search weights
- Content file path and offset

#### Scenario: Parse neurona from markdown file

- **WHEN** a markdown file with YAML frontmatter is processed
- **THEN** all metadata fields are extracted into a Neurona struct
- **AND** the struct is validated for required fields

#### Scenario: Missing required field

- **WHEN** a markdown file lacks a required field (id, title)
- **THEN** an error is returned with the specific field name

---

### Requirement: YAML Frontmatter Parsing

The system SHALL parse YAML frontmatter from Markdown files according to the NEURONA_SPEC.md format, supporting:

- All 10 core metadata sections
- Nested structures for connections and use_cases
- Arrays for tags, keywords, and platforms

#### Scenario: Valid frontmatter extraction

- **WHEN** a markdown file with valid YAML frontmatter is parsed
- **THEN** all fields are correctly typed and populated

#### Scenario: Invalid YAML syntax

- **WHEN** a markdown file contains malformed YAML
- **THEN** a descriptive parse error with line number is returned

---

### Requirement: Configuration Management

The system SHALL manage user configuration via:

- Config file at ~/.config/syntlas/config.yaml
- Default values for all settings
- Runtime overrides via environment variables

#### Scenario: Load user configuration

- **WHEN** Syntlas starts
- **THEN** configuration is loaded from the user's config file
- **AND** missing values use defaults

#### Scenario: Environment variable override

- **WHEN** SYNTLAS_* environment variable is set
- **THEN** it overrides the corresponding config file value

---

### Requirement: Build System Configuration

The system SHALL provide a Zig build configuration supporting:

- Debug and ReleaseFast optimization modes
- Cross-compilation for Linux, macOS, and Windows
- Dependency management via build.zig.zon

#### Scenario: Cross-platform build

- **WHEN** `zig build -Dtarget=x86_64-linux` is executed
- **THEN** a Linux binary is produced
