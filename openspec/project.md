# Project Context

## Purpose

**Syntlas** is a terminal application for navigating programming language documentation, use cases, and code snippets. It treats documentation as a **neural network** (the Neurona System), enabling intelligent search and navigation through interconnected knowledge nodes.

**Core Goals:**

- Sub-10ms search performance
- Offline-first architecture
- Dual interface: Human-readable Markdown + Machine-queryable JSON
- True decentralization (no required registry)
- AI agent-friendly structured output

**Motto:** *Your programming language atlas for the terminal*

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| **Language** | Zig 0.15.2+ |
| **Documentation Format** | Markdown + YAML frontmatter |
| **Configuration** | YAML (~/.config/syntlas/config.yaml) |
| **Search Engine** | Custom multi-index (inverted, graph, metadata) |
| **Storage** | Local filesystem + mmap |
| **Build System** | Zig build system |
| **Issue Tracking** | Beads (`bd`) |
| **Spec Management** | OpenSpec |

---

## Project Conventions

### Code Style

**Memory Management:**

- Use explicit allocator patterns (always pass allocators)
- Never use global variables for large structs
- `ArenaAllocator` for frame-scoped data
- `PoolAllocator` for background tasks
- `ArrayListUnmanaged` preferred over `ArrayList`
- `GeneralPurposeAllocator` for debug builds

**Error Handling:**

- Always handle errors with `try` or `catch`
- No hidden allocations

**Example Pattern:**

```zig
fn processData(allocator: std.mem.Allocator, data: []const u8) !void {
    var list = std.ArrayListUnmanaged(u8){};
    defer list.deinit(allocator);
    // ...
}
```

### Architecture Patterns

**The Neurona System:**

| Term | Definition |
|------|------------|
| **Neurona** | Atomic knowledge unit — single Markdown doc with unique ID |
| **Tome** | Collection of Neuronas for a language/topic |
| **Synapse** | Connection between Neuronas (prerequisite, related, next) |
| **Activation** | Search query matching a Neurona |
| **Traversal** | Following synapse connections through the graph |

**Search Algorithm (5-Stage Pipeline):**

1. Text Matching → Initial neuron activation
2. Semantic Matching → Use-case based discovery
3. Context Filtering → User skill/platform/goals
4. Graph Expansion → Traverse connections
5. Ranking → Weighted scoring

### Testing Strategy

- Unit tests for all modules (>80% coverage target)
- Integration tests for end-to-end workflows
- Performance benchmarks (search, indexing, load)
- Memory leak detection (Zig sanitizers)
- Cross-platform testing (Linux, macOS, Windows)

### Git Workflow

**Branching:** Main branch (`main`)

**Commit Process:**

1. Always ask for approval before committing
2. Run `zig build run` successfully before commit
3. Application must run 30+ seconds with no errors
4. After commit: `git pull --rebase && bd sync && git push`

**Documentation:** Update `doc/PLAN.md`, `doc/ARCHITECTURE.md`, `README.md` as needed after commits.

---

## Domain Context

### Neurona Specification

The `doc/NEURONA_SPEC.md` is **IMMUTABLE** for AI agents. It defines:

- 10 core metadata sections (Identity, Connections, Search, Technical, etc.)
- Graph relationships (prerequisites, related, next_topics, part_of)
- Search optimization fields (keywords, use_cases, answers)
- Quality indicators (tested, production_ready, benchmarked)
- Agent hints for AI recommendations

### Three-Tier Tome System

| Tier | Source | Description |
|------|--------|-------------|
| **Embedded** | Bundled in binary | C, C++, Python, Rust, Zig |
| **Official** | Curated downloads | JavaScript, Go, TypeScript |
| **Community** | Any host | User-created, niche content |

---

## Important Constraints

### Performance Targets

| Operation | Target |
|-----------|--------|
| Text search | <10ms |
| Graph traversal | <5ms/hop |
| Faceted filter | <3ms |
| Full re-index | <100ms |
| Cold start | <200ms |
| Binary size | <15MB |

### Security Requirements

- Safe YAML parsing (no arbitrary object instantiation)
- Path traversal validation (reject `..` and absolute paths)
- Dangerous command pattern detection
- Sandboxing for untrusted tomes
- User confirmation for shell commands

### Verification Rules

- `zig build run` must succeed before task completion
- Application must run 30+ seconds with no errors
- Never stop before verification passes

---

## External Dependencies

### Tools

| Tool | Purpose |
|------|---------|
| **Beads** | Issue tracking (`bd show`, `bd close`) |
| **OpenSpec** | Spec-driven development |
| **Git** | Version control |

### Future Integrations

- AI coding assistants (Claude, GPT)
- Editor plugins (Vim, Neovim, VSCode)
- LSP server
- Package managers (Homebrew, AUR, Scoop)

---

## Current Status

**Phase:** Specification & Design

**Active OpenSpec Changes:**

| Change ID | Phase | Status |
|-----------|-------|--------|
| `add-foundation` | Phase 1: Foundation | Proposed |
| `add-index-engine` | Phase 2: Index Engine | Proposed |
| `add-search-algorithm` | Phase 3: Search Algorithm | Proposed |
| `add-tome-system` | Phase 4: Tome System | Proposed |
| `add-security-hardening` | Phase 5: Security | Proposed |
| `add-embedded-tomes` | Phase 6: Embedded Tomes | Proposed |
| `add-cli-output` | Phase 7: CLI & Output | Proposed |
| `add-testing-optimization` | Phase 8: Testing | Proposed |
| `add-alpha-release` | Phase 9: Alpha Release | Proposed |
| `add-post-alpha` | Phase 10: Post-Alpha | Proposed |
| `add-beta-ecosystem` | Phase 11: Beta | Proposed |

**Next Steps:**

1. Approve Phase 1 proposal and begin implementation
2. Implement Zig search engine
3. Build core indices (inverted, graph, metadata)
4. Create embedded tomes (C, C++, Python, Rust, Zig)
5. Alpha release with official tomes

---

*Last updated: 2026-01-17*
