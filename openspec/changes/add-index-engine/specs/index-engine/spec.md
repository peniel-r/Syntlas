## ADDED Requirements

### Requirement: Inverted Index

The system SHALL maintain an inverted index mapping keywords to neurona identifiers, supporting:

- Hash-based O(1) keyword lookup
- Term frequency weighting
- Case-insensitive matching

#### Scenario: Keyword search

- **WHEN** a user searches for "async"
- **THEN** all neuronas containing "async" are returned in <10ms

#### Scenario: Multi-word query

- **WHEN** a user searches for "async await"
- **THEN** neuronas matching both terms are ranked higher

---

### Requirement: Graph Index

The system SHALL maintain a graph index representing Synaptics via adjacency lists, supporting:

- Prerequisite relationships
- Related topic connections
- Next topic recommendations
- Synapse weights (0-100)

#### Scenario: Prerequisite lookup

- **WHEN** a neurona "py.async.coroutines" has prerequisite "py.functions.generators"
- **THEN** the prerequisite is retrievable via graph traversal

#### Scenario: Weighted connections

- **WHEN** traversing connections
- **THEN** higher-weighted connections are prioritized

---

### Requirement: Metadata Index

The system SHALL maintain bitmap indices for faceted filtering, supporting:

- Category filtering (concept, tutorial, reference, etc.)
- Difficulty filtering (beginner, intermediate, advanced, expert)
- Tag-based filtering
- Boolean operations (AND, OR, NOT)

#### Scenario: Faceted filter query

- **WHEN** user filters by "difficulty:beginner AND category:tutorial"
- **THEN** only matching neuronas are returned in <3ms

---

### Requirement: Index Persistence

The system SHALL persist indices to disk in a binary format, supporting:

- Fast save/load operations (<50ms for 10,000 neuronas)
- Version headers for compatibility
- Incremental updates

#### Scenario: Index load on startup

- **WHEN** Syntlas starts with cached indices
- **THEN** indices are loaded from disk in <50ms

#### Scenario: Index rebuild

- **WHEN** a tome is modified
- **THEN** affected index entries are updated incrementally

---

### Requirement: Memory Mapping

The system SHALL support memory-mapped file access for large indices, enabling:

- Lazy loading of cold data
- Memory footprint <20MB for 10,000 neuronas
- Cross-platform support (Linux, macOS, Windows)

#### Scenario: Large dataset handling

- **WHEN** index exceeds available RAM
- **THEN** memory mapping allows access without full loading
