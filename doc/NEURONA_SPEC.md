# The Neurona System Specification v0.2.0

*A Neurona is knowledge. A Tome is a library.*

**Version**: 0.2.0
**Date**: 2026-01-17
**Status**: Draft

---

## Table of Contents

1. [Terminology](#terminology)
2. [Philosophy](#philosophy)
3. [Tiered Architecture](#tiered-architecture)
4. [File Structure](#file-structure)
5. [Tier 1: Essential Fields](#tier-1-essential-fields)
6. [Tier 2: Standard Fields](#tier-2-standard-fields)
7. [Tier 3: Advanced Fields](#tier-3-advanced-fields)
8. [Security Model](#security-model)
9. [Search Index Architecture](#search-index-architecture)
10. [AI Agent Integration](#ai-agent-integration)
11. [Search Algorithm: Neural Activation](#search-algorithm-neural-activation)
12. [Validation Rules](#validation-rules)

---

## Terminology

| Term | Definition |
| ------ | ------------ |
| **Neurona** | The atomic unit of knowledge. A single Markdown document with YAML frontmatter containing one concept, pattern, or reference. |
| **Tome** | A collection of Neuronas organized around a language, topic, or domain. A directory containing multiple `.md` files and a `tome.json` manifest. |
| **Synapse** | A connection between Neuronas (prerequisites, related, next). Carries a weight indicating strength. |
| **Activation** | When a search query matches a Neurona, it "activates" and propagates signal through its synapses. |
| **Traversal** | Following synapse connections to discover related Neuronas. |

### Hierarchy Diagram

```text
┌────────────────────────────────────────────────────────┐
│                    THE NEURONA SYSTEM                  │
├────────────────────────────────────────────────────────┤
│                                                        │
│  TOME (Collection)          NEURONA (Atomic Unit)      │
│  ──────────────────          ─────────────────────     │
│  python.tome/              ┌───────────────────────┐   │
│  ├── tome.json             │ py.async.basics       │   │
│  ├── syntax/               ├───────────────────────┤   │
│  │   ├── basics.md  ─────→ │ id: py.async.basics   │   │
│  │   └── types.md          │ title: Async Basics   │   │
│  ├── patterns/             │ tags: [python, async] │   │
│  │   └── async.md          │ links: [py.async.adv] │   │
│  └── .syntlas/             └───────────────────────┘   │
│      └── graph.idx                  │                  │
│                                     │ SYNAPSE          │
│                                     ▼                  │
│                            ┌─────────────────────────┐ │
│                            │ py.async.advanced       │ │
│                            └─────────────────────────┘ │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## Philosophy

**Syntlas is a facilitator, not a gatekeeper.**

The Neurona System models documentation as a **neural network** where:

- **A Neurona is the atomic unit** — One concept, one document, one truth
- **Synapses connect Neuronas** — Prerequisites, related topics, next steps
- **Search activates Neuronas** — Queries trigger relevance scoring
- **Learning is traversal** — Users navigate from Neurona to Neurona
- **A Tome collects Neuronas** — Organized by language or topic

### The Neurona-First Principle

> **Write one Neurona. Connect it. Let the network emerge.**

A single well-written Neurona with good connections is more valuable than a thousand unlinked documents. The power comes from the graph, not the volume.

### Key Principles

1. **Neurona-Centric** — The smallest unit is the most important
2. **Human-Readable First** — All content in plain Markdown
3. **Progressive Complexity** — Start simple (5 fields), add as needed
4. **Machine-Queryable** — Structured YAML frontmatter for agents
5. **Graph-Native** — Neuronas explicitly declare relationships
6. **Performance-Critical** — Sub-10ms search across all Neuronas
7. **Content-Addressable** — Tamper detection via hashing
8. **Security-First** — All external Neuronas treated as untrusted
9. **No Lock-In** — Works with Zettelkasten, Obsidian, Logseq, or plain text

### General Knowledge Use

While examples in this spec use programming languages, the Neurona System is **domain-agnostic**. It works equally well for:

- Personal knowledge bases (Zettelkasten)
- Research notes and literature reviews
- Course materials and curricula
- Recipes and cooking techniques
- Philosophy, history, or any subject

**Example (non-programming):**

```yaml
---
id: "stoicism.marcus-aurelius.meditations"
title: "Meditations by Marcus Aurelius"
tags: [philosophy, stoicism, self-improvement]
links: ["stoicism.epictetus", "stoicism.seneca"]
---
```

---

## Tiered Architecture

The specification uses three tiers to balance simplicity with capability:

| Tier | Fields | Use Case |
| ------ | -------- | ---------- |
| **Tier 1: Essential** | 5 required | Plain text, local models, Zettelkasten |
| **Tier 2: Standard** | +10 optional | Graph features, search optimization |
| **Tier 3: Advanced** | +20 optional | Enterprise, AI agents, full features |

### Tier Compatibility

- Tier 1 documents work everywhere (any Markdown parser)
- Tier 2 adds graph traversal and rich search
- Tier 3 enables AI agent features and enterprise tooling
- Higher tiers are additive (Tier 3 includes all Tier 1 and 2 fields)

---

## File Structure

A tome is a directory containing Markdown files with YAML frontmatter:

```text
mylang.tome/
├── tome.json                 # Tome metadata (required)
├── README.md                 # Human-readable overview
├── .syntlas/                 # Index directory (auto-generated)
│   ├── manifest.json         # File list with content hashes
│   ├── graph.idx             # Precomputed adjacency list
│   ├── keywords.idx          # Inverted keyword index
│   └── embeddings/           # Optional: vector embeddings
│       └── local-minilm.bin
├── syntax/
│   ├── basics.md
│   ├── functions.md
│   ├── control-flow.md
│   └── types.md
├── stdlib/
│   ├── collections.md
│   ├── io.md
│   └── networking.md
├── patterns/
│   ├── error-handling.md
│   ├── concurrency.md
│   └── testing.md
├── snippets/
│   ├── hello-world.md
│   ├── file-operations.md
│   └── web-server.md
└── assets/
    └── diagrams/
        └── control-flow.svg
```

### tome.json (Required)

```json
{
  "name": "python",
  "version": "3.12.1",
  "language": "Python",
  "author": "Syntlas Community",
  "description": "Python 3.12 documentation tome",
  "homepage": "https://python.org",
  "created": "2026-01-15",
  "updated": "2026-01-17",
  "tags": ["scripting", "general-purpose", "interpreted"],
  "license": "MIT",
  "spec_version": "0.2.0",
  "integrity": {
    "algorithm": "sha256",
    "manifest_hash": "sha256:a7ffc6f8bf1ed76..."
  }
}
```

---

## Tier 1: Essential Fields

**5 required fields** - Works with any Markdown system (Zettelkasten, Obsidian, Logseq):

```yaml
---
# TIER 1: ESSENTIAL (Required)
id: "py.async.basics"              # Unique identifier (dot-notation or numeric UID)
title: "Async Basics"              # Human-readable title
tags: [python, async, beginner]    # 3-15 searchable tags
links: ["py.async.advanced"]       # Related Neurona IDs (simple references)
hash: "sha256:a7ffc6f8..."         # Content hash for integrity (optional but recommended)
---
```

### Field Specifications

| Field | Type | Required | Description |
| ------- | ------ | ---------- | ------------- |
| `id` | string | Yes | Unique identifier. Supports dot-notation (`py.async.basics`) or numeric UID (`202601171200`) |
| `title` | string | Yes | Human-readable title (5-100 chars) |
| `tags` | string[] | Yes | 3-15 searchable tags, lowercase |
| `links` | string[] | No | Related Neurona IDs for graph traversal |
| `hash` | string | No | SHA256 of content body (for tamper detection) |

### Zettelkasten Compatibility

Tier 1 supports numeric UIDs for Zettelkasten workflows:

```yaml
---
id: "202601171200"                 # Zettelkasten UID format
title: "Async Programming Basics"
tags: [python, async, beginner]
links: ["202601171201", "202601171202"]
---
```

### Wiki-Style Link Parsing

Links can also be extracted from content body:

```markdown
## See Also
- [[py.async.advanced]] - Next level concepts
- [[py.async.errors]] - Error handling
```

---

## Tier 2: Standard Fields

**+10 optional fields** - Enables graph features and rich search:

```yaml
---
# TIER 1 (required)
id: "py.async.basics"
title: "Async Basics"
tags: [python, async, beginner]
links: ["py.async.advanced"]
hash: "sha256:a7ffc6f8..."

# TIER 2 (optional - graph features)
category: concepts                  # See category values below
difficulty: beginner                # [beginner, intermediate, advanced, expert]
keywords: [asyncio, coroutine, event-loop]  # Search optimization
prerequisites: ["py.basics.functions"]      # What must be learned first
next: ["py.async.tasks"]                    # Natural progression
related:                             # Bidirectional relationships
  - id: "py.async.threading"
    type: contrast                   # [similar, alternative, complement, contrast]
version:
  minimum: "3.7.0"
  recommended: "3.11.0"
platforms: [linux, macos, windows]
updated: "2026-01-17"
---
```

### Tier 2 Field Specifications

| Field | Type | Description |
| ------- | ------ | ------------- |
| `category` | enum | Document type classification |
| `difficulty` | enum | Skill level required |
| `keywords` | string[] | Additional search terms |
| `prerequisites` | string[] | IDs of required prior knowledge |
| `next` | string[] | IDs of suggested next topics |
| `related` | object[] | Related neuronas with relationship type |
| `version` | object | Language/framework version requirements |
| `platforms` | enum[] | Supported platforms |
| `updated` | date | Last modification date (ISO 8601) |
| `author` | string | Content author |

### Category Values

**Programming:**
`syntax`, `stdlib`, `patterns`, `snippets`, `api`, `reference`

**General Knowledge:**
`concept`, `note`, `quote`, `summary`, `journal`, `definition`, `guide`, `tutorial`, `comparison`

---

## Tier 3: Advanced Fields

**+20 optional fields** - Full features for enterprise and AI agent integration:

```yaml
---
# TIER 1 + 2 fields...

# TIER 3: ADVANCED (Enterprise/AI features)

# Neural connections with quantized weights
neural:
  prerequisites:
    - id: "py.async.basics"
      strength: 85            # 0-100 (quantized for performance)
      optional: false
  related:
    - id: "py.async.httpx"
      type: alternative
      weight: 80              # 0-100
  part_of: ["py.async.full-guide"]
  composed_of: ["py.async.tasks", "py.async.futures"]
  supersedes: ["py.old.async"]
  deprecated_by: null

# Quality indicators
quality:
  tested: true
  reviewed: true
  production_ready: true
  benchmarked: false

# Learning metadata
learning:
  time: "20min"
  outcomes:
    - "Create async HTTP sessions"
    - "Handle concurrent requests"
  pitfalls:
    - mistake: "Not closing session"
      impact: severe
      solution: "py.async.cleanup"
  complexity: 55              # 0-100 cognitive load

# AI Agent specific (compact notation)
_llm:
  t: "Async HTTP"            # Compact title (token efficient)
  d: 2                         # Difficulty 1-4
  k: [aiohttp, async, http]    # Top 3 keywords
  p: [py.async.basics]         # Prerequisites (IDs only)
  c: 850                       # Token estimate
  summary_tokens: 120
  context_strategy: hierarchical
---
```

### Quantized Weights

Tier 3 uses integers (0-100) instead of floats for performance:

| Float | Integer | Meaning |
| ------- | --------- | -------- |
| 0.85 | 85 | Strong |
| 0.50 | 50 | Moderate |
| 0.25 | 25 | Weak |

---

## Security Model

> [!CAUTION]
> All external tome content is treated as **untrusted** by default.

### Content-Addressable Integrity

Every document includes a `hash` field for tamper detection:

```yaml
id: "py.async.basics"
hash: "sha256:a7ffc6f8bf1ed76..."  # SHA256 of content body
```

### Trust Levels

| Level | Source | Code Execution |
| ------- | -------- | --------------- |
| `embedded` | Built into binary | Allowed |
| `official` | Signed by Syntlas | Sandboxed |
| `community` | GPG-signed | Sandboxed + warning |
| `untrusted` | Unsigned | Disabled |

### Execution Section (DEPRECATED)

> [!WARNING]
> The `execution` section is **deprecated** in v0.2.0.
> Tomes should contain documentation only.

---

## AI Agent Integration

### Token-Efficient Metadata

The `_llm` section provides compact metadata for LLM context efficiency:

```yaml
_llm:
  t: "Async HTTP"       # Short title
  d: 2                   # Difficulty (1-4)
  k: [aiohttp, async]    # Top keywords
  c: 850                 # Token count
  context_strategy: hierarchical
```

### Context Strategies

| Strategy | Description | Best For |
| ---------- | ------------- | ---------- |
| `full` | Send entire document | Small docs |
| `summary` | Send TL;DR only | Large docs |
| `hierarchical` | Progressive detail | Most cases |

### Embedding Storage

Vector embeddings stored separately from content:

```text
.syntlas/embeddings/
├── openai-ada-002.bin
├── cohere-english-v3.bin
└── local-minilm.bin
```

---

## Legacy Field Reference

The following sections document legacy fields for backwards compatibility.

### Neural Connections (Legacy)

**Graph Relationships** (all optional):

```yaml
# Prerequisites (incoming edges - what must be learned first)
prerequisites:
  - id: string              # Neurona ID
    strength: float         # 0.0-1.0, how critical (default: 1.0)
    optional: boolean       # Can be skipped? (default: false)

# Example:
prerequisites:
  - id: "py.async.basics"
    strength: 0.9
    optional: false
  - id: "py.async.context-managers"
    strength: 0.6
    optional: true
```

```yaml
# Related neuronas (bidirectional edges - complementary topics)
related:
  - id: string
    relationship: enum      # [similar, alternative, complement, contrast]
    weight: float           # 0.0-1.0, strength of relationship

# Example:
related:
  - id: "py.async.httpx"
    relationship: alternative
    weight: 0.8
  - id: "py.async.asyncio"
    relationship: complement
    weight: 0.7
```

```yaml
# Next topics (outgoing edges - natural progression)
next_topics:
  - id: string
    confidence: float       # 0.0-1.0, how confident is this path

# Example:
next_topics:
  - id: "py.async.aiohttp.server"
    confidence: 0.8
  - id: "py.async.error-handling"
    confidence: 0.9
```

```yaml
# Supersedes (replaces older knowledge)
supersedes: string[]
# Example: ["py.async.old-coroutines", "py.threading.basics"]

# Deprecated by (this Neurona is outdated)
deprecated_by: string
# Example: "py.async.modern-approach"

# Part of (belongs to larger concept)
part_of: string[]
# Example: ["py.async.full-guide", "py.web-scraping.tutorial"]

# Composed of (this is a parent concept)
composed_of: string[]
# Example: ["py.async.tasks", "py.async.futures", "py.async.coroutines"]
```

---

### 3. Search Optimization Metadata

```yaml
# Primary keywords for search indexing (required)
keywords: string[]
# Example: [aiohttp, ClientSession, async requests, fetch, get, post]

# Aliases/synonyms (optional)
aliases: string[]
# Example: [asynchronous http, non-blocking requests, concurrent downloads]

# Use cases (for semantic search, highly recommended)
use_cases: string[]
# Example: [web-scraping, api-integration, concurrent-downloads, load-testing]

# Problem solved (what pain points does this address?)
solves: string[]
# Example: [slow-sequential-requests, blocking-io, http-performance]

# Common search queries this answers
answers: string[]
# Example: 
#   - "how to make async http requests in python"
#   - "parallel api calls python"
#   - "aiohttp client session example"

# Negative keywords (what this is NOT about)
not_about: string[]
# Example: [synchronous, requests library, urllib, threading]

# Search boost (0.0-2.0, default 1.0)
search_weight: float
```

---

### 4. Technical Specifications

```yaml
# Language/framework version requirements
version:
  minimum: semver           # Minimum version required
  maximum: semver           # Maximum version (null = no limit)
  recommended: semver       # Recommended version
  tested_on: semver[]      # Versions tested

# Example:
version:
  minimum: "3.7.0"
  maximum: null
  recommended: "3.11.0"
  tested_on: ["3.9.0", "3.10.0", "3.11.0", "3.12.0"]
```

```yaml
# External dependencies
dependencies:
  - name: string            # Package name
    version: semver         # Version requirement
    optional: boolean       # Is it optional?
    install_cmd: string     # Advisory installation command

# Example:
dependencies:
  - name: "aiohttp"
    version: ">=3.8.0"
    optional: false
    install_cmd: "pip install aiohttp"
```

```yaml
# Platform compatibility
platforms: enum[]
# Values: [linux, macos, windows, wasm, android, ios, bsd]

# Example:
platforms: [linux, macos, windows]
```

```yaml
# Performance characteristics
performance:
  time_complexity: string   # Big-O notation
  space_complexity: string  # Big-O notation
  throughput: string        # Optional: throughput description
  best_for: string[]        # When to use this
  avoid_when: string[]      # When NOT to use this

# Example:
performance:
  time_complexity: "O(n/c)"  # n requests, c concurrency
  space_complexity: "O(c)"
  throughput: "1000+ req/sec"
  best_for: [io-bound, many-requests, api-heavy]
  avoid_when: [cpu-bound, single-request, simple-scripts]
```

```yaml
# Safety/quality indicators
quality:
  tested: boolean           # Has automated tests
  reviewed: boolean         # Peer reviewed
  production_ready: boolean # Safe for production
  thread_safe: boolean      # Thread-safe code
  memory_safe: boolean      # No memory leaks
  benchmarked: boolean      # Performance tested

# Example:
quality:
  tested: true
  reviewed: true
  production_ready: true
  thread_safe: true
  memory_safe: true
  benchmarked: false
```

---

### 5. Execution Context

**For Code Snippets:**

> [!CAUTION]
> **SECURITY WARNING**: The `execution` section contains potentially dangerous commands.
> Syntlas treats ALL execution content as untrusted and applies the following protections:
>
> - Commands are analyzed for dangerous patterns before execution
> - User must explicitly approve each command
> - Code runs in a sandboxed environment by default
> - Network access is denied unless explicitly required

```yaml
execution:
  # Safety flags - these are CLAIMS, not guarantees
  author_claims_safe: boolean  # Author's claim (NOT a security guarantee)
  requires_setup: boolean      # Needs setup steps?
  sandboxed: boolean           # Default: true - always sandbox untrusted code
  interactive: boolean         # Requires user input?
  
  # Setup steps (if requires_setup: true)
  # WARNING: These run with user permissions - use caution
  setup:
    - command: string         # Shell command to execute
      description: string     # Human-readable description
  
  # Cleanup steps
  cleanup:
    - command: string
      description: string
  
  # Environment variables
  env_vars:
    - name: string            # Variable name (validated against allowlist)
      required: boolean       # Is it required?
      default: string         # Default value (no variable expansion)
      description: string     # What it's for
  
  # Expected runtime
  execution_time: duration    # Format: "2s", "500ms", "1m30s"
  
  # Resource requirements
  resources:
    memory: string            # Example: "512MB"
    cpu: string               # Example: "1 core"
    disk: string              # Example: "100MB"
    network: boolean          # Requires network?

# Example:
execution:
  author_claims_safe: true  # Note: This is NOT a security guarantee
  requires_setup: true
  sandboxed: true           # ALWAYS true for community tomes
  interactive: false
  
  setup:
    - command: "pip install aiohttp"
      description: "Install aiohttp library"
    - command: "mkdir -p output"
      description: "Create output directory"
  
  cleanup:
    - command: "rm -rf output"
      description: "Remove temporary files"
  
  env_vars:
    - name: "API_KEY"
      required: true
      default: null
      description: "API authentication key"
  
  execution_time: "5s"
  
  resources:
    memory: "128MB"
    cpu: "1 core"
    network: true
```

#### Blocked Command Patterns

The following patterns are **blocked** in `setup` and `cleanup` commands:

| Pattern | Risk Level | Action |
| --------- | ------------ | -------- |
| `rm -rf /` or `rm -rf ~` | Critical | Installation blocked |
| `curl \| sh` or `wget \| bash` | Critical | Requires explicit confirmation |
| `sudo` commands | High | Requires explicit confirmation |
| `chmod 777` | High | Warning displayed |
| `eval`, `exec`, backticks | High | Requires confirmation |
| Network commands (curl, wget) | Medium | Flagged for review |

---

### 6. Learning Context

```yaml
learning:
  # Estimated time to understand
  estimated_time: duration  # Format: "15min", "1h30m", "2h"
  
  # Learning outcomes (what you'll know after reading)
  outcomes: string[]
  
  # Common mistakes/pitfalls
  pitfalls:
    - mistake: string       # Description of mistake
      impact: enum          # [minor, moderate, severe, critical]
      solution_id: string   # Link to document explaining fix
  
  # Assessment available
  quiz_available: boolean
  exercises_available: boolean
  
  # Cognitive load (subjective difficulty 0.0-10.0)
  complexity_score: float

# Example:
learning:
  estimated_time: "20min"
  
  outcomes:
    - "Create async HTTP client sessions"
    - "Make concurrent GET/POST requests"
    - "Handle async context managers"
    - "Process responses asynchronously"
  
  pitfalls:
    - mistake: "Not closing ClientSession"
      impact: severe
      solution_id: "py.async.resource-cleanup"
    - mistake: "Using session outside async context"
      impact: critical
      solution_id: "py.async.context-managers"
  
  quiz_available: false
  exercises_available: true
  complexity_score: 5.5
```

---

### 7. Content Metadata

```yaml
content:
  # Content type flags
  has_code: boolean
  has_diagrams: boolean
  has_video: boolean
  has_interactive: boolean
  
  # Code language (for syntax highlighting)
  code_language: string     # Example: "python"
  
  # Media assets (relative paths from tome root)
  assets:
    diagrams: string[]      # SVG/PNG diagrams
    videos: url[]          # Video URLs
    demos: url[]           # Interactive demos
  
  # Reading level
  reading_level: enum       # [simple, moderate, technical, academic]
  
  # Word count (for time estimation, auto-calculated if omitted)
  word_count: integer
  
  # Last updated (ISO 8601 format)
  updated: date             # Example: "2025-01-15"
  
  # Author/maintainer
  author: string
  maintainer: string
  contributors: string[]
  
  # License
  license: enum             # [MIT, Apache-2.0, CC-BY-4.0, BSD-3, proprietary]

# Example:
content:
  has_code: true
  has_diagrams: true
  has_video: false
  has_interactive: false
  
  code_language: "python"
  
  assets:
    diagrams: ["assets/diagrams/aiohttp-flow.svg"]
    videos: []
    demos: ["https://replit.com/@example/aiohttp-demo"]
  
  reading_level: technical
  word_count: 850
  updated: "2025-01-15"
  author: "Jane Developer"
  maintainer: "Syntlas Community"
  contributors: ["John Doe", "Alice Smith"]
  license: "MIT"
```

---

### 8. Agent-Specific Hints

**Metadata to help AI agents make better decisions:**

```yaml
agent_hints:
  # Primary intent this document serves
  intent: enum[]            # [learn, reference, debug, optimize, migrate, compare]
  
  # Confidence level for AI recommendations (0.0-1.0)
  recommendation_score: float
  
  # Context requirements (other docs needed for full understanding)
  requires_context: string[]   # Neurona IDs
  
  # Preferred output format when using this doc
  preferred_output: enum       # [code, explanation, both, visual, interactive]
  
  # Target user skill level
  targets_skill: enum[]        # [beginner, intermediate, advanced, expert]
  
  # Interaction style
  interaction: enum            # [tutorial, reference, troubleshooting, comparison, guide]
  
  # Semantic embeddings (optional, for vector search)
  embedding_version: string    # Example: "openai-ada-002"
  embedding_model: string

# Example:
agent_hints:
  intent: [learn, reference]
  recommendation_score: 0.92
  requires_context: ["py.async.basics", "py.http.fundamentals"]
  preferred_output: both
  targets_skill: [intermediate, advanced]
  interaction: tutorial
  embedding_version: null
  embedding_model: null
```

---

### 9. Error Handling & Debugging

**For troubleshooting documents:**

```yaml
debugging:
  # Error signatures this doc addresses
  error_codes: string[]        # Exception names, error codes
  
  # Error patterns (regex patterns for matching)
  error_patterns: string[]
  
  # Symptoms (human-readable descriptions)
  symptoms: string[]
  
  # Solutions offered
  solutions:
    - title: string
      steps: string[]
      success_rate: float      # 0.0-1.0, how often this works
      prerequisites: string[]  # What's needed for this solution
  
  # Related errors (often occur together)
  related_errors: string[]

# Example:
debugging:
  error_codes: ["ModuleNotFoundError", "ImportError"]
  
  error_patterns:
    - "No module named '.*'"
    - "cannot import name '.*' from '.*'"
  
  symptoms:
    - "Module not found when importing"
    - "Import statement fails"
    - "Package not recognized"
  
  solutions:
    - title: "Install missing package"
      steps:
        - "Identify package name from error"
        - "Run: pip install <package>"
        - "Verify installation: pip list | grep <package>"
      success_rate: 0.95
      prerequisites: ["pip installed"]
    
    - title: "Check virtual environment"
      steps:
        - "Verify venv is activated"
        - "Check PYTHONPATH"
        - "Reinstall in correct environment"
      success_rate: 0.80
      prerequisites: []
  
  related_errors: ["AttributeError", "NameError", "SyntaxError"]
```

---

### 10. Versioning & Migration

```yaml
versioning:
  # API/feature version
  api_version: semver
  
  # Deprecation status
  deprecated: boolean
  deprecated_date: date       # When deprecated
  removal_date: date          # When it will be removed
  deprecation_reason: string  # Why deprecated
  
  # Breaking changes
  breaking_changes:
    - version: semver
      description: string
      migration_guide_id: string   # Link to migration doc
  
  # Migration paths
  migrates_from: string[]      # IDs of old docs this replaces
  migrates_to: string          # ID of replacement doc
  
  # Stability level
  stability: enum              # [experimental, beta, stable, deprecated, removed]

# Example:
versioning:
  api_version: "3.8.0"
  deprecated: false
  deprecated_date: null
  removal_date: null
  deprecation_reason: null
  
  breaking_changes:
    - version: "3.0.0"
      description: "ClientSession API changed"
      migration_guide_id: "py.aiohttp.migration-v3"
  
  migrates_from: ["py.async.old-aiohttp", "py.urllib.async"]
  migrates_to: null
  
  stability: stable
```

---

## Search Index Architecture

Syntlas builds multiple indices for fast queries:

### 1. Inverted Index (Text Search)

```text
Structure:
  keyword -> [neurona_ids]

Example:
  "async" -> ["py.async.basics", "py.async.aiohttp", "js.async.promises"]
  "http" -> ["py.async.aiohttp", "js.fetch.api", "rust.reqwest"]
```

### 2. Graph Index (Neural Connections)

```text
Structure:
  Adjacency List Format
  neurona_id -> {
    prerequisites: [(id, strength, optional), ...],
    related: [(id, weight, relationship), ...],
    next_topics: [(id, confidence), ...],
    part_of: [ids],
    composed_of: [ids]
  }

Example:
  "py.async.aiohttp" -> {
    prerequisites: [("py.async.basics", 0.9, false)],
    related: [("py.async.httpx", 0.8, "alternative")],
    next_topics: [("py.async.error-handling", 0.9)]
  }
```

### 3. Metadata Index (Faceted Search)

```text
Structure:
  attribute:value -> [neurona_ids]

Examples:
  category:patterns -> [neurona_ids]
  difficulty:beginner -> [neurona_ids]
  tags:async -> [neurona_ids]
  platforms:linux -> [neurona_ids]
  quality.production_ready:true -> [neurona_ids]
```

### 4. Use-Case Index (Semantic Search)

```text
Structure:
  use_case -> [(neurona_id, relevance_score), ...]

Example:
  "web-scraping" -> [
    ("py.async.aiohttp", 0.95),
    ("py.beautifulsoup", 0.90),
    ("py.selenium", 0.85)
  ]
```

### 5. Error Index (Debugging)

```text
Structure:
  error_signature -> [neurona_ids]

Example:
  "ModuleNotFoundError" -> ["py.errors.import", "py.venv.setup"]
  "No module named '.*'" -> ["py.errors.import"]
```

---

## Search Algorithm: Neural Activation

```text
FUNCTION search_neurona(query, context):
  
  // Stage 1: Text Matching (Inverted Index)
  text_matches = inverted_index.search(query)
  score_by_keyword_relevance(text_matches)
  
  // Stage 2: Semantic Matching
  semantic_matches = []
  FOR each use_case in use_case_index:
    IF query matches use_case:
      semantic_matches += use_case_index[use_case]
  
  // Stage 3: Context-Aware Filtering
  IF context exists:
    filtered = filter_results(
      results = text_matches + semantic_matches,
      user_skill = context.skill_level,
      completed = context.completed_neuronas,
      goals = context.goals,
      platforms = context.platforms
    )
  ELSE:
    filtered = text_matches + semantic_matches
  
  // Stage 4: Graph Expansion (Neural Activation)
  expanded = []
  FOR each Neurona in filtered:
    // Add Neurona itself
    expanded.add(Neurona, weight=1.0)
    
    // Traverse prerequisites (if user missing them)
    IF NOT all_prerequisites_met(Neurona, context):
      FOR each prereq in Neurona.prerequisites:
        expanded.add(prereq.id, weight=prereq.strength * 0.8)
    
    // Traverse related neuronas (breadth-first)
    FOR each related in Neurona.related:
      IF related.weight > 0.5:
        expanded.add(related.id, weight=related.weight * 0.6)
    
    // Suggest next topics (if prerequisites met)
    IF all_prerequisites_met(Neurona, context):
      FOR each next in Neurona.next_topics:
        IF next.confidence > 0.7:
          expanded.add(next.id, weight=next.confidence * 0.7)
  
  // Stage 5: Ranking
  ranked = rank_neuronas(
    neuronas = deduplicate(expanded),
    factors = [
      relevance_score (40%),
      search_weight (20%),
      quality.production_ready (15%),
      recency (10%),
      popularity (10%),
      user_preference (5%)
    ]
  )
  
  RETURN top_n(ranked, n=20)
```

---

## Complete Example Neurona

```yaml
---
# ============================================================
# NEURONA IDENTITY
# ============================================================
id: "py.async.aiohttp.client"
title: "Async HTTP Client with aiohttp"
category: patterns
subcategory: "concurrency.async.http"
difficulty: intermediate
tags: [async, http, aiohttp, client, networking, io-bound, requests, api]

# ============================================================
# NEURAL CONNECTIONS
# ============================================================
prerequisites:
  - id: "py.async.basics"
    strength: 0.9
    optional: false
  - id: "py.async.context-managers"
    strength: 0.6
    optional: true

related:
  - id: "py.async.httpx"
    relationship: alternative
    weight: 0.8
  - id: "py.async.asyncio"
    relationship: complement
    weight: 0.7
  - id: "py.requests"
    relationship: contrast
    weight: 0.5

next_topics:
  - id: "py.async.aiohttp.server"
    confidence: 0.8
  - id: "py.async.error-handling"
    confidence: 0.9
  - id: "py.async.connection-pooling"
    confidence: 0.7

part_of:
  - "py.async.web-scraping-guide"
  - "py.async.full-course"

# ============================================================
# SEARCH OPTIMIZATION
# ============================================================
keywords: [aiohttp, ClientSession, async requests, fetch, get, post, http client]
aliases: [async http client, non-blocking requests, concurrent http, async api calls]
use_cases: [web-scraping, api-integration, concurrent-downloads, load-testing, microservices]
solves: [slow-sequential-requests, blocking-io, http-performance, api-rate-limits]
answers:
  - "how to make async http requests in python"
  - "parallel api calls python"
  - "aiohttp client session example"
  - "async web scraping python"
  - "concurrent http requests python"
not_about: [synchronous, requests library, urllib, threading, multiprocessing]
search_weight: 1.5

# ============================================================
# TECHNICAL SPECS
# ============================================================
version:
  minimum: "3.7.0"
  maximum: null
  recommended: "3.11.0"
  tested_on: ["3.9.0", "3.10.0", "3.11.0", "3.12.0"]

dependencies:
  - name: "aiohttp"
    version: ">=3.8.0"
    optional: false
    install_cmd: "pip install aiohttp"
  - name: "aiohttp[speedups]"
    version: ">=3.8.0"
    optional: true
    install_cmd: "pip install aiohttp[speedups]"

platforms: [linux, macos, windows]

performance:
  time_complexity: "O(n/c)"
  space_complexity: "O(c)"
  throughput: "1000+ req/sec"
  best_for: [io-bound, many-requests, api-heavy, concurrent-operations]
  avoid_when: [cpu-bound, single-request, simple-scripts, blocking-operations]

quality:
  tested: true
  reviewed: true
  production_ready: true
  thread_safe: true
  memory_safe: true
  benchmarked: true

# ============================================================
# EXECUTION CONTEXT
# ============================================================
execution:
  author_claims_safe: true  # Note: NOT a security guarantee
  requires_setup: true
  sandboxed: true
  interactive: false
  
  setup:
    - command: "pip install aiohttp"
      description: "Install aiohttp library"
    - command: "mkdir -p output"
      description: "Create output directory for results"
  
  cleanup:
    - command: "rm -rf output"
      description: "Remove temporary output directory"
  
  env_vars:
    - name: "API_KEY"
      required: false
      default: "demo_key"
      description: "Optional API key for authenticated requests"
  
  execution_time: "5s"
  
  resources:
    memory: "128MB"
    cpu: "1 core"
    disk: "10MB"
    network: true

# ============================================================
# LEARNING CONTEXT
# ============================================================
learning:
  estimated_time: "20min"
  
  outcomes:
    - "Create and manage async HTTP client sessions"
    - "Make concurrent GET/POST requests efficiently"
    - "Handle async context managers properly"
    - "Process responses asynchronously"
    - "Implement error handling for async HTTP"
  
  pitfalls:
    - mistake: "Not closing ClientSession properly"
      impact: severe
      solution_id: "py.async.resource-cleanup"
    - mistake: "Using session outside async context"
      impact: critical
      solution_id: "py.async.context-managers"
    - mistake: "Forgetting to await requests"
      impact: moderate
      solution_id: "py.async.common-errors"
    - mistake: "Creating new session for each request"
      impact: moderate
      solution_id: "py.async.session-reuse"
  
  quiz_available: false
  exercises_available: true
  complexity_score: 5.5

# ============================================================
# CONTENT METADATA
# ============================================================
content:
  has_code: true
  has_diagrams: true
  has_video: false
  has_interactive: false
  
  code_language: "python"
  
  assets:
    diagrams: ["assets/diagrams/aiohttp-flow.svg"]
    videos: []
    demos: ["https://replit.com/@syntlas/aiohttp-demo"]
  
  reading_level: technical
  word_count: 850
  updated: "2025-01-15"
  author: "Jane Developer"
  maintainer: "Syntlas Community"
  contributors: ["John Doe", "Alice Smith"]
  license: "MIT"

# ============================================================
# AGENT HINTS
# ============================================================
agent_hints:
  intent: [learn, reference]
  recommendation_score: 0.92
  requires_context: ["py.async.basics"]
  preferred_output: both
  targets_skill: [intermediate, advanced]
  interaction: tutorial

# ============================================================
# VERSIONING
# ============================================================
versioning:
  api_version: "3.8.0"
  deprecated: false
  deprecated_date: null
  removal_date: null
  deprecation_reason: null
  
  breaking_changes:
    - version: "3.0.0"
      description: "ClientSession API redesigned with context manager requirement"
      migration_guide_id: "py.aiohttp.migration-v3"
  
  migrates_from: ["py.async.old-aiohttp"]
  migrates_to: null
  
  stability: stable
---

# Async HTTP Client with aiohttp

Learn how to make concurrent HTTP requests using aiohttp's ClientSession for high-performance async operations.

## Overview

The `aiohttp` library provides async/await support for HTTP operations, allowing you to make thousands of concurrent requests efficiently without blocking.

## Basic Usage

```python
import aiohttp
import asyncio

async def fetch_url(session, url):
    """Fetch a single URL and return its content."""
    async with session.get(url) as response:
        return await response.text()

async def main():
    urls = [
        'https://api.example.com/users/1',
        'https://api.example.com/users/2',
        'https://api.example.com/users/3'
    ]
    
    # Create a session (reuse for all requests)
    async with aiohttp.ClientSession() as session:
        # Create tasks for concurrent execution
        tasks = [fetch_url(session, url) for url in urls]
        
        # Wait for all tasks to complete
        results = await asyncio.gather(*tasks)
        
        return results

# Run the async function
results = asyncio.run(main())
```

## Performance Tip: Connection Pooling

aiohttp automatically manages connection pooling when you reuse a `ClientSession`. This dramatically improves performance for multiple requests.

```python
# ✅ GOOD: Reuse session
async with aiohttp.ClientSession() as session:
    for url in urls:
        await fetch(session, url)

# ❌ BAD: Create new session each time
for url in urls:
    async with aiohttp.ClientSession() as session:
        await fetch(session, url)
```

## See Also

- [Async Basics](py.async.basics) - Learn async/await fundamentals
- [Error Handling](py.async.error-handling) - Comprehensive error handling patterns
- [aiohttp Server](py.async.aiohttp.server) - Build async web servers

---

## Performance Targets

| Operation | Target Time | Strategy |
| ----------- | ------------- | ---------- |
| Text search | <10ms | Inverted index + in-memory cache |
| Graph traversal | <5ms per hop | Adjacency lists with pre-computed paths |
| Faceted filtering | <3ms | Bitmap indices for metadata |
| Full tome re-index | <100ms | Incremental updates only |
| Semantic search | <50ms | Vector index with HNSW (optional) |
| Complex query (multi-facet) | <20ms | Parallel index queries + merge |
| Cold start (load tome) | <200ms | Lazy loading + mmap |

---

## Validation Rules

### Required Fields by Category

**All Documents Must Have:**

- `id`
- `title`
- `category`
- `difficulty`
- `tags` (3-15 items)
- `keywords` (minimum 3)

**Code Snippets Must Also Have:**

- `execution.safe_to_run`
- `content.has_code` (true)
- `content.code_language`

**Reference Documents Should Have:**

- `use_cases` (minimum 2)
- `learning.outcomes`
- `version` information

**Troubleshooting Documents Must Have:**

- `debugging.error_codes` or `debugging.error_patterns`
- `debugging.solutions` (minimum 1)

### Field Constraints

```yaml
# String lengths
id: 3-100 characters, alphanumeric + dots/hyphens
title: 5-100 characters
tags: each 2-30 characters
keywords: each 2-50 characters

# Arrays
tags: 3-15 items
keywords: 3-30 items
use_cases: 0-20 items
related: 0-10 items
prerequisites: 0-5 items
next_topics: 0-10 items

# Numeric ranges
search_weight: 0.0-2.0
strength: 0.0-1.0
weight: 0.0-1.0
confidence: 0.0-1.0
complexity_score: 0.0-10.0
recommendation_score: 0.0-1.0
success_rate: 0.0-1.0

# Dates
ISO 8601 format: "2025-01-15" or "2025-01-15T10:30:00Z"

# Semver
Must follow: MAJOR.MINOR.PATCH
Can include: >=, <=, ~, ^, || operators
```

### Cross-Reference Validation

**Reference Integrity:**

- All `id` references in connections must exist in tome (or be resolvable in the network)
- `prerequisites`, `related`, `next_topics` IDs must be valid
- `solution_id`, `migration_guide_id` must point to existing docs
- `requires_context` IDs must be valid

**Circular Dependencies:**

- No circular prerequisites (A → B → A)
- Graph must be acyclic for prerequisites
- `related` and `next_topics` can have cycles (bidirectional OK)

**Deprecation Chain:**

- If `deprecated: true`, must have `deprecated_by` or `migrates_to`
- If `supersedes` used, those docs should reference this in `deprecated_by`

### Content Validation

**Markdown Quality:**

- Must have at least one H1 heading (`# Title`)
- Code blocks must specify language (```python, not```)
- Internal links should use Neurona IDs: `[Link](Neurona.id)`
- External links must be absolute URLs

**Code Snippets:**

- Must include complete, runnable examples
- Should have comments explaining key parts
- Must specify all imports
- Should avoid hardcoded credentials (use env vars)

### Tome-Level Validation

**tome.json Requirements:**

```json
{
  "name": "required, lowercase-hyphenated",
  "version": "required, semver",
  "language": "required",
  "spec_version": "required, must be 1.0.0"
}
```

**File Organization:**

- Each category should have its own directory
- File names should match Neurona IDs (lowercase, hyphens)
- Assets referenced must exist in tome

---

## File Format Summary

✅ **Human-Readable**: Markdown + YAML frontmatter  
✅ **Machine-Queryable**: Structured metadata for agents  
✅ **Graph-Native**: Built-in neural connections  
✅ **Performance-Optimized**: Multiple indices for <10ms search  
✅ **Extensible**: Custom fields allowed (prefixed with `x_`)  
✅ **Version-Controlled**: Git-friendly plain text  
✅ **No Lock-In**: Works without Syntlas

---

## Specification Versioning

**Current Version**: 0.2.0

**Changelog:**

- **0.2.0** (2026-01-17): Major restructure - Neurona-centric
  - Renamed to "The Neurona System Specification"
  - Added Terminology section (Neurona, Tome, Synapse, Activation)
  - Added visual hierarchy diagram
  - Updated Philosophy with Neurona-First principle
  - Added tiered architecture (Tier 1/2/3)
  - Added content-addressable integrity (hash field)
  - Added Security Model with trust levels
  - Added AI Agent Integration (_llm section)
  - Deprecated `execution` section
  - Added `.syntlas/` index directory specification
  - Quantized weights (0-100 integers)
  - Zettelkasten/wiki-link compatibility

- **0.1.0** (2026-01-17): Initial draft with security hardening
  - Added blocked command patterns
  - Added checksum and signature fields to tome.json

**Future Considerations:**

- Semantic embeddings standardization
- Multi-language cross-references
- Interactive code execution metadata
- Accessibility metadata (WCAG compliance)

**Backward Compatibility Promise:**

- Spec 0.x versions may have breaking changes
- Spec 1.x will remain backward compatible once released
- New optional fields may be added in minor versions
- Breaking changes will increment major version

---

## License

This specification is released under CC-BY-4.0.

Tomes created using this specification may use any license chosen by the author.

---

**The Neurona System Specification v0.2.0**  
*A Neurona is knowledge. A Tome is a library.*

