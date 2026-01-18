## ADDED Requirements

### Requirement: Vector Search (Optional)

When enabled, the system SHALL provide semantic vector search:

- Embedding-based similarity matching
- Hybrid ranking (text + vector)
- Natural language query understanding

#### Scenario: Semantic search

- **WHEN** user searches "how to handle errors gracefully"
- **THEN** semantically similar neuronas are returned
- **EVEN IF** exact keywords don't match

---

### Requirement: Interactive TUI Mode (Optional)

When enabled, the system SHALL provide an interactive terminal UI:

- Real-time search input
- Keyboard navigation
- Inline result preview
- Vim-style keybindings

#### Scenario: Interactive search

- **WHEN** user runs `syntlas --tui`
- **THEN** an interactive search interface is displayed

---

### Requirement: Editor Integrations (Optional)

When requested, the system SHALL provide editor plugins:

- Vim/Neovim plugin
- VSCode extension
- JetBrains plugin
- In-editor search and preview

#### Scenario: Vim plugin search

- **WHEN** user invokes :Syntlas search
- **THEN** results are displayed in Vim buffer

---

### Requirement: LSP Server (Optional)

When implemented, the system SHALL provide an LSP server for editor integration:

- Hover documentation
- Code completion with Syntlas results
- Go-to-definition for neurona references

#### Scenario: Hover documentation

- **WHEN** cursor hovers over a known API
- **THEN** Syntlas documentation is shown

---

### Requirement: Learning Path Generator (Optional)

When enabled, the system SHALL generate learning paths from the neural graph:

- Analyze prerequisite relationships
- Generate ordered topic sequence
- Track user progress
- Recommend next topics

#### Scenario: Learning path generation

- **WHEN** user requests path to "advanced async"
- **THEN** ordered list of prerequisite topics is generated

---

### Requirement: Continuous Improvement

The system SHALL incorporate alpha feedback:

- Bug fix prioritization
- Performance optimization based on usage
- Documentation improvements based on confusion points

#### Scenario: Bug fix release

- **WHEN** critical bug is reported in alpha
- **THEN** fix is released within 1 week

