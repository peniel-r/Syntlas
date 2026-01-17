## ADDED Requirements

### Requirement: Core Language Tomes

The system SHALL include embedded tomes for 5 core programming languages:

- C (ISO C standard, common patterns)
- C++ (C++17/20 STL, modern idioms)
- Python (3.12 stdlib, best practices)
- Rust (stdlib, ownership, async)
- Zig (stdlib, comptime, patterns)

#### Scenario: Embedded tome availability

- **WHEN** Syntlas is installed fresh
- **THEN** all 5 core language tomes are available without additional installation

---

### Requirement: Tome Content Quality

Each embedded tome SHALL meet minimum quality standards:

- 100-500 neurons per tome
- All NEURONA_SPEC fields populated
- Valid neural connection graph (no broken links)
- Tested search quality

#### Scenario: Tome validation passes

- **WHEN** `syntlas validate-tome --embedded` is executed
- **THEN** all embedded tomes pass validation

---

### Requirement: Neural Connection Graph

Embedded tomes SHALL establish meaningful neural connections:

- Prerequisites form learning paths
- Related topics enable discovery
- Next topics guide progression
- Connection weights reflect importance

#### Scenario: Learning path traversal

- **WHEN** user views "py.async.basics"
- **THEN** prerequisites include "py.functions.generators"
- **AND** next_topics include "py.async.advanced"

---

### Requirement: Binary Size Constraint

All embedded tomes combined SHALL fit within the binary size constraint:

- Total binary size <15MB with all embedded tomes
- Compression applied at build time
- Extraction on first run

#### Scenario: Binary size verification

- **WHEN** release binary is built with embedded tomes
- **THEN** binary size is verified to be <15MB

---

### Requirement: Search Quality for Embedded Content

Searches against embedded tomes SHALL return highly relevant results:

- Common queries return expected results
- Fuzzy matching handles typos
- Graph expansion surfaces related content

#### Scenario: Python async search

- **WHEN** user searches "python async await"
- **THEN** top results include async/await neurons from Python tome
