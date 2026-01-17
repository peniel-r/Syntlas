# Syntlas Project Summary

**Date**: January 17, 2026  
**Project**: Syntlas - The Neurona System for Programming Documentation  
**Language**: Zig 0.15.2+

---

## Project Origin

The project began with exploring the term "Atlas" as a collection of maps/knowledge, leading to the creation of **Syntlas** - a terminal application for navigating programming language documentation, use cases, and code snippets.

### Name Etymology

- **Syntlas** = "Syntax" + "Atlas"
- Represents a comprehensive map/guide through programming language territories
- Designed for both human developers and AI coding agents

---

## Core Philosophy

### The Facilitator Principle

> **"Syntlas is a facilitator, not a gatekeeper."**

**Key Tenets:**

1. **Human-Readable First**
   - All documentation stored as plain Markdown files
   - No proprietary formats or lock-in
   - Users can read docs with `cat`, `less`, or any text editor
   - Works perfectly outside of Syntlas

2. **Community-Driven**
   - Manual distribution (no centralized registry required)
   - Anyone can create and host their own "tomes"
   - Open, decentralized ecosystem
   - Official curated tomes + unlimited community tomes

3. **Agent-Friendly**
   - Structured YAML frontmatter for machine parsing
   - JSON output mode for AI coding assistants
   - Semantic search capabilities
   - Context-aware recommendations

4. **Performance-Critical**
   - Sub-10ms search target
   - Built in Zig for maximum efficiency
   - Offline-first after initial setup
   - Binary size under 15MB with embedded tomes

5. **No Lock-In**
   - Documentation valuable independent of Syntlas
   - Git-friendly plain text format
   - Easy to migrate, fork, or extend
   - Syntlas adds value through search/navigation, not format control

---

## The Neurona System

### Concept: Documentation as a Neural Network

The breakthrough innovation in Syntlas is the **Neurona specification** - treating documentation as a living neural network.

#### Terminology

| Term | Definition |
| ---------------- | ---------------- |
| **Neurona** | The atomic unit of knowledge — a single Markdown document with one concept |
| **Tome** | A collection of Neuronas organized around a programming language or topic |
| **Synapse** | A connection between Neuronas (prerequisite, related, next) |
| **Activation** | When a search query matches a Neurona |
| **Traversal** | Following synapse connections through the graph |
| **Weights** | Relationship strength (0-100 integer scale) |

### How It Works

1. **Each Document is a Neurona**
   - Unique ID: `py.async.aiohttp.client`
   - Self-contained unit of knowledge
   - Rich metadata in YAML frontmatter

2. **Documents Form Synaptic Connections**

   ```yaml
   prerequisites:     # What you need to know first
     - id: "py.async.basics"
       strength: 0.9
   
   related:          # Complementary/alternative topics
     - id: "py.async.httpx"
       relationship: alternative
       weight: 0.8
   
   next_topics:      # Natural progression
     - id: "py.async.error-handling"
       confidence: 0.9
   ```

3. **Search Activates the Network**
   - Query triggers initial neurons (text match)
   - Activation propagates through connections
   - Graph traversal finds related/prerequisite topics
   - Results ranked by relevance + connection strength

4. **Learning Paths Emerge Naturally**
   - Prerequisites form directed acyclic graph
   - System can generate personalized learning sequences
   - Detects missing knowledge gaps
   - Suggests optimal next steps

### Why "Neurona"?

- **Neural** - Mimics how human knowledge is interconnected
- **Dynamic** - Connections allow context-aware navigation
- **Intelligent** - Graph structure enables smart recommendations
- **Scalable** - Adding documents strengthens the network
- **Organic** - Knowledge grows through community contributions

---

## Technical Architecture

### Technology Stack

- **Language**: Zig 0.15.2+ (performance, safety, small binaries)
- **Format**: Markdown + YAML frontmatter
- **Configuration**: YAML (~/.config/syntlas/config.yaml)
- **Distribution**: Tarballs, Git repos, or direct URLs
- **Storage**: `~/.config/syntlas/tomes/`

### Embedded vs Downloadable Tomes

**Embedded** (bundled in binary):

- C, C++, Python, Rust, Zig
- Instant access, no network needed
- Core languages most developers need

**Downloadable** (community-created):

- JavaScript, Go, Elixir, Haskell, etc.
- Framework-specific (React, Django, etc.)
- Company-internal documentation
- Niche/specialized content

### Search Engine Design

**Multi-Index Architecture:**

1. **Inverted Index** - Text keyword search (<10ms)
2. **Graph Index** - Neural connections (adjacency lists)
3. **Metadata Index** - Faceted search (difficulty, tags, etc.)
4. **Use-Case Index** - Semantic matching
5. **Error Index** - Debugging by error signatures

**Search Algorithm (5 Stages):**

```text
1. Text Matching → Initial neuron activation
2. Semantic Matching → Use-case based discovery
3. Context Filtering → User skill/platform/goals
4. Graph Expansion → Traverse connections (prerequisites, related)
5. Ranking → Weighted scoring with multiple factors
```

---

## Frontmatter Specification Highlights

### 10 Core Metadata Sections

1. **Neuron Identity** - ID, title, category, difficulty, tags
2. **Neural Connections** - Prerequisites, related, next topics, hierarchies
3. **Search Optimization** - Keywords, use cases, semantic hints
4. **Technical Specs** - Versions, dependencies, performance characteristics
5. **Execution Context** - For runnable code snippets
6. **Learning Context** - Time estimates, outcomes, common pitfalls
7. **Content Metadata** - Media, word count, licenses
8. **Agent Hints** - AI-specific guidance for recommendations
9. **Error Handling** - For troubleshooting documents
10. **Versioning** - API versions, deprecations, migrations

### Example Neural Connection

```yaml
# A document about async HTTP in Python
id: "py.async.aiohttp.client"

prerequisites:
  - id: "py.async.basics"        # Must understand async first
    strength: 0.9                # Critical prerequisite
    optional: false

related:
  - id: "py.async.httpx"         # Alternative library
    relationship: alternative
    weight: 0.8
  - id: "py.async.asyncio"       # Complementary topic
    relationship: complement
    weight: 0.7

next_topics:
  - id: "py.async.error-handling"  # Natural next step
    confidence: 0.9
```

---

## Key Design Decisions

### 1. Markdown Over Proprietary Formats

**Rationale:**

- Universally readable (GitHub, editors, terminals)
- Git-friendly (meaningful diffs)
- No parsing complexity for humans
- Community already knows Markdown

### 2. Manual Distribution Over Registry

**Rationale:**

- No infrastructure burden
- No moderation overhead
- True decentralization
- Users choose their trust model
- Simple: just URLs or file paths

**Installation:**

```bash
syntlas install https://example.com/tome.tar.gz (placeholder)
syntlas install gh:user/tome-repo (placeholder)
syntlas install file:///local/path (placeholder)
```

### 3. Graph Structure Over Flat Hierarchy

**Rationale:**

- Knowledge is naturally interconnected
- Enables intelligent navigation
- Supports multiple learning paths
- Better than rigid folder hierarchies
- AI agents can traverse relationships

### 4. Zig Over Other Languages

**Rationale:**

- Performance (comparable to C/C++)
- Memory safety without garbage collection
- Small binaries
- Cross-compilation built-in
- Approaching 1.0 stability (0.15.2+)

---

## Use Cases

### For Human Developers

```bash
# Quick reference
syntlas search python "async/await"

# Find by use case
syntlas snippet rust --use-case="web-scraping"

# Learning path
syntlas learn python async  # Shows prerequisites → topic → next steps

# Offline docs
syntlas docs zig stdlib/allocators
```

### For AI Coding Agents

```bash
# Structured output
syntlas search python async --format=json

# Context-aware search
syntlas query python \
  --tags=async,http \
  --skill=intermediate \
  --completed=["py.async.basics"] \
  --format=json

# Graph traversal
syntlas related py.async.basics --depth=2 --format=json
```

**Agent Benefits:**

- Understand prerequisites (avoid suggesting advanced topics too early)
- Find alternatives (offer httpx vs aiohttp based on context)
- Detect knowledge gaps (user needs async basics first)
- Generate learning paths (optimal sequence for mastery)

---

## Performance Targets

| Operation | Target | Why It Matters |
| ----------- | -------- | ---------------- |
| Text search | <10ms | Instant feedback, faster than typing |
| Graph hop | <5ms | Real-time navigation through connections |
| Faceted filter | <3ms | Smooth multi-criteria search |
| Full re-index | <100ms | Fast tome updates |
| Cold start | <200ms | Quick launch, imperceptible delay |

---

## Ecosystem Vision

### Three-Tier System

**Tier 1: Embedded (Instant)**

- C, C++, Python, Rust, Zig
- Built into binary
- Zero latency
- Most common needs

**Tier 2: Official Downloadable (Curated)**

- JavaScript, Go, TypeScript, etc.
- Quality-controlled
- Versioned releases
- Community-maintained

**Tier 3: Community (Unlimited)**

- Anyone can create/host
- Niche languages
- Company-internal docs
- Experimental content
- Framework-specific guides

### Community Contributions

**Tome Creators Can:**

- Host on GitHub, personal sites, company servers
- Use any license (MIT, Apache, proprietary)
- Version independently
- Innovate freely
- Monetize if desired

**Syntlas Provides:**

- Creation tools (`syntlas create-tome`)
- Validation (`syntlas validate-tome`)
- Building (`syntlas build-tome`)
- Documentation (NEURONA_SPEC.md)
- Example tomes

---

## Future Possibilities

### Planned Features

- Vector search (semantic embeddings)
- Interactive TUI mode
- Editor integrations (Vim, VSCode, Neovim)
- LSP server
- Learning path generator
- Quiz/assessment system
- Collaborative filtering (popularity-based ranking)

### Research Directions

- Graph neural networks for better recommendations
- Multi-language cross-references (Python ↔ Rust equivalents)
- Automatic prerequisite detection
- Difficulty calibration based on user feedback
- Community knowledge graphs

---

## Core Innovation Summary

### What Makes Syntlas Different?

1. **Neural Documentation Network**
   - First system to treat docs as interconnected neurons
   - Explicit relationship modeling (prerequisites, alternatives)
   - Graph-based navigation and discovery

2. **Dual Interface**
   - Human-readable Markdown (works everywhere)
   - Machine-queryable metadata (AI agents love it)

3. **True Decentralization**
   - No required central registry
   - Community-driven growth
   - Multiple trust models

4. **Performance Excellence**
   - Sub-10ms search in Zig
   - Offline-first architecture
   - Tiny memory footprint

5. **No Lock-In Philosophy**
   - Docs valuable outside Syntlas
   - Open specification
   - Easy migration/forking

---

## Project Values

### For Users

- **Speed** - Faster than web search, instant offline access
- **Quality** - Curated official tomes + unlimited community content
- **Privacy** - All local processing, no tracking
- **Flexibility** - Works your way (CLI, JSON, integrations)

### For Contributors

- **Openness** - Clear specs, MIT license
- **Simplicity** - Markdown is easy to write
- **Autonomy** - Host/distribute however you want
- **Impact** - Help developers worldwide

### For the Ecosystem

- **Sustainability** - No single point of failure
- **Evolution** - Network improves as it grows
- **Diversity** - Room for all languages/frameworks
- **Longevity** - Plain text survives proprietary systems
- **Security** - Defense-in-depth for untrusted content

---

## Security Architecture

### Threat Model

Syntlas processes tomes from potentially untrusted sources. The security architecture addresses:

1. **Malicious Code Execution** - Shell commands in tome setup/cleanup
2. **Path Traversal** - Asset references escaping tome directory
3. **YAML Attacks** - Deserialization and entity expansion attacks
4. **Tome Integrity** - Tampering during download

### Defense-in-Depth Approach

```text
┌────────────────────────────────────────────────────────────────┐
│                    TOME INGESTION PIPELINE                     │
├────────────────────────────────────────────────────────────────┤
│ 1. DOWNLOAD    → Verify HTTPS, check size limits, quarantine   │
│ 2. VALIDATION  → Parse safely, check paths, validate schema    │
│ 3. ANALYSIS    → Flag dangerous patterns, generate warnings    │
│ 4. APPROVAL    → User confirms any shell commands              │
│ 5. INSTALL     → Set read-only, build indices, verify          │
└────────────────────────────────────────────────────────────────┘
```

### Trust Levels

| Level | Source | Code Execution | Shell Commands |
|-------|--------|----------------|----------------|
| `embedded` | Bundled in binary | Allowed | None permitted |
| `official` | Signed by Syntlas | Sandboxed | User approval |
| `community` | GPG-signed | Sandboxed | User approval + warning |
| `untrusted` | Unsigned | Sandboxed | Blocked |

### Sandboxing Strategy

- **Linux**: seccomp-bpf + namespaces + cgroups
- **Windows**: Restricted tokens + job objects
- **macOS**: sandbox-exec profiles
- **Fallback**: Container isolation (Docker/Podman)

### Blocked Patterns

The following patterns in `execution.setup` and `execution.cleanup` are blocked:

- `rm -rf /` or `rm -rf ~`
- `curl | sh` or `wget | bash`
- `sudo` commands
- Shell evaluation (`eval`, `exec`, backticks)

---

## Technical Highlights

### Neurona Specification Features

**Graph Relationships:**

```yaml
prerequisites:    # Directed acyclic graph (learning order)
related:         # Undirected graph (bidirectional connections)
next_topics:     # Directed graph (suggested progression)
part_of:         # Hierarchical (belongs-to relationships)
composed_of:     # Hierarchical (contains relationships)
supersedes:      # Versioning (replacement chain)
```

**Search Optimization:**

```yaml
keywords:        # Inverted index (text search)
use_cases:       # Semantic index (intent matching)
answers:         # Natural language queries
not_about:       # Negative filtering
search_weight:   # Ranking boost (0.0-2.0)
```

**Quality Indicators:**

```yaml
quality:
  tested: true            # Has automated tests
  production_ready: true  # Safe for production
  benchmarked: true       # Performance verified
```

**Agent Intelligence:**

```yaml
agent_hints:
  intent: [learn, reference, debug]
  recommendation_score: 0.92
  requires_context: ["prerequisite.id"]
  targets_skill: [intermediate]
```

---

## Success Metrics

### Technical

- ✅ <10ms search response time
- ✅ <15MB binary size (with embedded tomes)
- ✅ Zero runtime dependencies
- ✅ Cross-platform (Linux, macOS, Windows)

### Ecosystem

- 📈 Number of community tomes
- 📈 Language coverage breadth
- 📈 Active contributors
- 📈 Integration with dev tools

### Adoption

- 📈 Daily active users
- 📈 Agent integrations (Claude, GPT, etc.)
- 📈 Editor plugin installations
- 📈 Community engagement (Discord, GitHub)

---

## Project Status

**Current Phase**: Specification & Design  
**Next Steps**:

1. Implement Zig search engine
2. Build core indices (inverted, graph, metadata)
3. Create embedded tomes (C, C++, Python, Rust, Zig)
4. Develop tome creation tools
5. Alpha release with official tomes

**Repository Structure**:

```text
syntlas/
├── README.md              ✅ Created
├── NEURONA_SPEC.md       ✅ Created
├── CONTRIBUTING.md       📝 Needed
├── src/                  🔨 To implement
│   ├── main.zig
│   ├── search/
│   ├── index/
│   └── tome/
├── tomes/                🔨 To create
│   ├── python/
│   ├── rust/
│   └── zig/
├── examples/             📝 Needed
└── docs/                 📝 Needed
```

---

## Philosophical Foundation

### The Knowledge Graph Vision

Traditional documentation is **linear** (top-to-bottom reading) or **hierarchical** (folder structure).

Syntlas documentation is **networked** (interconnected knowledge graph).

**Why This Matters:**

1. **Multiple Learning Paths**
   - No single "correct" order
   - Users choose their journey
   - Respects different backgrounds

2. **Contextual Discovery**
   - "If you're reading X, you might need Y"
   - Prerequisites automatically suggested
   - Alternatives presented fairly

3. **Emergent Organization**
   - Structure emerges from connections
   - Not imposed top-down
   - Organic growth

4. **AI-Native**
   - Agents can traverse graphs naturally
   - Context-aware recommendations
   - Personalized learning paths

### The Open Knowledge Principle

> "Knowledge should be free, accessible, and improvable by all."

Syntlas embodies this by:

- Using open formats (Markdown, YAML)
- Permitting any license
- Enabling decentralized distribution
- Avoiding platform lock-in
- Supporting offline use

---

## Call to Action

### For Developers

"Use Syntlas to navigate documentation faster than ever. Contribute tomes for your favorite languages."

### For AI Researchers

"Build agents that leverage Syntlas's structured knowledge graph for better code generation."

### For Documentation Writers

"Turn your docs into intelligent, interconnected neurons that help developers learn efficiently."

### For the Community

"Let's build the world's most comprehensive, intelligent, and accessible programming knowledge network—together."

---

## Closing Thought

**Syntlas** is not just a documentation tool—it's a vision for how programming knowledge should be structured, shared, and discovered in the age of AI-assisted development.

By combining human-readable simplicity with machine-queryable intelligence, and by embracing true decentralization with community ownership, Syntlas aims to become the universal atlas for navigating the ever-expanding territory of programming languages and frameworks.

**The Neurona system is the key innovation:** treating documentation as a living neural network that grows smarter with every connection, every tome, and every query.

---

**Project**: Syntlas  
**Motto**: *Your programming language atlas for the terminal*  
**Philosophy**: *A facilitator, not a gatekeeper*  
**Innovation**: *Documentation as a neural network*  
**License**: MIT  
**Version**: 0.1.0-dev  
**Status**: Specification & Design

*Made with ⚡ and 🧠 by the Syntlas Community*
