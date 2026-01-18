## ADDED Requirements

### Requirement: Tome Validation

The system SHALL validate tomes against the NEURONA_SPEC, checking:

- tome.json structure and required fields
- Neurona frontmatter compliance
- Neural connection integrity (no broken links)
- Required quality indicators

#### Scenario: Valid tome validation

- **WHEN** `syntlas validate-tome ./my-tome` is executed
- **THEN** all neuronas are checked against the spec
- **AND** a success message is displayed

#### Scenario: Invalid tome detection

- **WHEN** a tome contains invalid frontmatter
- **THEN** specific errors with file paths and line numbers are reported

---

### Requirement: Tome Installation

The system SHALL install tomes from multiple sources:

- tar.gz archives
- Git repository URLs
- Local filesystem paths
- HTTP/HTTPS URLs

#### Scenario: Install from git

- **WHEN** `syntlas install https://github.com/user/zig-tome.git`
- **THEN** the tome is cloned and installed to ~/.config/syntlas/tomes/

#### Scenario: Install from archive

- **WHEN** `syntlas install ./python-tome.tar.gz`
- **THEN** the archive is extracted and installed

---

### Requirement: Tome Storage Management

The system SHALL manage installed tomes in ~/.config/syntlas/tomes/, supporting:

- Version tracking
- Listing installed tomes
- Uninstalling tomes
- Updating tomes from source

#### Scenario: List installed tomes

- **WHEN** `syntlas list --tomes` is executed
- **THEN** all installed tomes with versions are displayed

#### Scenario: Uninstall tome

- **WHEN** `syntlas uninstall python-tome` is executed
- **THEN** the tome is removed from storage

---

### Requirement: Embedded Tome Bundling

The system SHALL bundle core tomes into the binary at build time:

- Compressed storage to minimize binary size
- Extraction on first run
- Total binary size <15MB with 5 embedded tomes

#### Scenario: First run extraction

- **WHEN** Syntlas runs for the first time
- **THEN** embedded tomes are extracted to the tomes directory

---

### Requirement: Multi-Tome Search

The system SHALL search across multiple installed tomes simultaneously:

- Cross-tome result aggregation
- Namespace prefixing for disambiguation
- Priority ordering based on tome relevance
- Search overhead <5ms for multi-tome queries

#### Scenario: Cross-tome search

- **WHEN** user has Python and Zig tomes installed
- **AND** searches for "memory management"
- **THEN** results from both tomes are returned with tome prefixes

---

### Requirement: Tome Metadata Parsing

The system SHALL parse tome.json metadata containing:

- Version, author, license
- Supported languages/topics
- Dependencies on other tomes
- Minimum Syntlas version

#### Scenario: Metadata display

- **WHEN** `syntlas info python-tome` is executed
- **THEN** tome metadata is displayed (author, version, license)
