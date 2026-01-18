# Syntlas

> Your programming language atlas for the terminal

**Syntlas** is a lightning-fast documentation navigator built in Zig. Powered by the **Neurona System**, it provides instant access to language docs, use cases, and code snippets—designed for both human developers and AI coding agents.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Zig](https://img.shields.io/badge/Zig-0.15.2+-orange.svg)](https://ziglang.org/)

## Features

- ⚡ **Lightning Fast** - Sub-10ms search powered by optimized Zig implementation
- 🧠 **Neurona System** - Each document is a Neurona in an interconnected knowledge graph
- 📦 **Embedded Core** - Common languages (C, C++, Python, Rust, Zig) built-in
- 🌐 **Extensible Tomes** - Download community-created documentation packs
- 🤖 **Agent-Friendly** - Structured output for AI coding assistants
- 💻 **Human-Readable** - All documentation in plain Markdown
- 🔌 **Offline-First** - Works without internet after initial setup
- 🎯 **Cross-Platform** - Linux, macOS, Windows support

## Quick Start

```bash
# Search Python documentation
syntlas search python "list comprehension"

# Get code snippet
syntlas snippet rust "error handling"

# Browse documentation
syntlas docs zig concurrency

# Agent-friendly JSON output
syntlas search python async --format=json

# Install additional language tome
syntlas install javascript

# List available tomes
syntlas list --available
```

## Installation

### Pre-built Binaries

Download the latest release for your platform:

```bash
# Linux/macOS
curl -L https://github.com/yourusername/syntlas/releases/latest/download/syntlas-$(uname -s)-$(uname -m) -o syntlas
chmod +x syntlas
sudo mv syntlas /usr/local/bin/

# Or using Homebrew (macOS/Linux)
brew install syntlas
```

### Build from Source

Requires Zig 0.15.2 or later:

```bash
git clone https://github.com/yourusername/syntlas.git
cd syntlas
zig build -Doptimize=ReleaseFast
./zig-out/bin/syntlas --version
```

## Embedded Languages

Syntlas comes with built-in documentation for:

- **C** - ISO C standard library and common patterns
- **C++** - Modern C++ (C++17/20) STL and idioms
- **Python** - Python 3.x stdlib and best practices
- **Rust** - Rust stdlib and ownership patterns
- **Zig** - Zig stdlib and comptime magic

## The Neurona System

### What are Tomes and Neuronas?

- **Neurona** — The atomic unit of knowledge. A single Markdown document with one concept.
- **Tome** — A collection of Neuronas organized around a programming language or topic.

Each Neurona connects to others via **synapses** (prerequisites, related topics, next steps), forming a navigable knowledge graph.

### Installing Tomes

```bash
# From official registry
syntlas install javascript
syntlas install golang

# From custom URL
syntlas install https://example.com/tomes/elixir.tome

# From GitHub
syntlas install gh:username/tome-haskell

# From local directory
syntlas install file:///path/to/custom-tome/
```

### Creating Your Own Tome

```bash
# Bootstrap a new tome
syntlas create-tome --language "MyLang" --version "1.0"

# Validate tome structure
syntlas validate-tome ./mylang-tome/

# Build distributable package
syntlas build-tome --source ./mylang-tome/ --output mylang.tome
```

See [NEURONA_SPEC.md](NEURONA_SPEC.md) for the complete Neurona specification.

### Community Tomes

Check out [Awesome Syntlas Tomes](https://github.com/yourusername/awesome-syntlas-tomes) for community-created documentation packages.

## Usage Examples

### For Developers

```bash
# Quick reference
syntlas search python "async/await"

# Find snippets by use case
syntlas snippet rust --use-case="web-scraping"

# Filter by difficulty
syntlas search zig --difficulty=beginner

# Get full documentation
syntlas docs python stdlib/asyncio
```

### For AI Coding Agents

```bash
# Structured JSON output
syntlas query python \
  --tags=async,http \
  --difficulty=intermediate \
  --format=json

# Get related topics (graph traversal)
syntlas related python/async/basics --depth=2 --format=json

# Context-aware search
syntlas search python "error handling" \
  --context='{"skill":"beginner","completed":["python/basics"]}' \
  --format=json
```

### Example JSON Response

```json
{
  "results": [
    {
      "id": "py.async.aiohttp",
      "title": "Async HTTP with aiohttp",
      "category": "patterns",
      "difficulty": "intermediate",
      "tags": ["async", "http", "networking"],
      "code_snippet": "...",
      "file_path": "patterns/async-http.md",
      "relevance_score": 0.95
    }
  ],
  "query_time_ms": 8,
  "total_results": 1
}
```

## Architecture

### The Neurona System

Syntlas uses a neural network-inspired documentation model:

- **Neurona** - Each document is a node with unique ID
- **Synapse** - Documents link via prerequisites, related topics, next steps
- **Activation** - Search activates neuronas and propagates through synapses
- **Learning Path** - Graph traversal generates personalized learning sequences

### Performance

- **Search**: <10ms for text queries
- **Graph Traversal**: <5ms per hop
- **Faceted Filtering**: <3ms
- **Binary Size**: <15MB (with embedded tomes)
- **Memory**: ~50MB typical usage

## Configuration

Default config location: `~/.config/syntlas/config.yaml`

```yaml
search:
  max_results: 20
  min_relevance: 0.3
  enable_fuzzy: true

tomes:
  registry_url: "https://tomes.syntlas.org/registry.json" # placeholder
  auto_update: false
  storage_path: "~/.config/syntlas/tomes/"

output:
  default_format: "text"
  syntax_highlighting: true
  theme: "monokai"

agent:
  enable_context: true
  max_graph_depth: 3

security:
  sandbox_execution: true
  allow_network: false
  require_signature: false  # Set to true for production
```

## Security

### Threat Model

Syntlas treats all external tomes as potentially untrusted. The security model provides:

- **Sandboxed Execution**: Code snippets run in isolated environments
- **Tome Verification**: Checksums and optional GPG signatures
- **Path Validation**: Protection against directory traversal attacks
- **Command Blocklist**: Dangerous shell commands are flagged or blocked
- **Safe YAML Parsing**: Protection against deserialization attacks

### Trust Levels

| Level | Source | Execution |
|-------|--------|----------|
| `embedded` | Built into binary | Full access |
| `official` | Signed by Syntlas team | Sandboxed |
| `community` | GPG-signed by author | Sandboxed + warning |
| `untrusted` | Unsigned | Sandboxed + restricted |

### Reporting Vulnerabilities

Please report security issues to <security@syntlas.org> (placeholder). Do not open public issues for security vulnerabilities.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
git clone https://github.com/yourusername/syntlas.git
cd syntlas

# Run tests
zig build test

# Run with debug info
zig build run -- search python async

# Format code
zig fmt src/
```

### Creating Tomes

The real power of Syntlas comes from community-created tomes. See:

- [The Neurona System Specification](NEURONA_SPEC.md) - Complete Neurona format
- [Tome Creation Guide](docs/creating-tomes.md) - Step-by-step tutorial (placeholder)
- [Example Tome](examples/example-tome/) - Reference implementation (placeholder)

## Roadmap

- [x] Core search engine (multi-index, 7-stage pipeline)
- [x] Tome installation system (local, git, tar, http)
- [x] Security hardening (path validation, command blocklist, trust levels, checksums, configurable policies)
- [ ] Embedded tomes (C, C++, Python, Rust, Zig) - Phase 6
- [ ] CLI & JSON output for agents - Phase 7
- [ ] Vector search (semantic embeddings)
- [ ] Interactive TUI mode
- [ ] LSP integration
- [ ] Browser extension
- [ ] Vim/Neovim plugin
- [ ] VSCode extension
- [ ] Learning path generator
- [ ] Quiz system

## Philosophy

**Syntlas is a facilitator, not a gatekeeper.**

- Documentation remains human-readable Markdown
- No proprietary formats or lock-in
- Community-driven tome ecosystem
- Open, decentralized distribution
- Privacy-first (all local processing)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by [tldr](https://github.com/tldr-pages/tldr) and [cheat.sh](https://cheat.sh)
- Built with [Zig](https://ziglang.org/)
- Neurona concept inspired by neural networks and knowledge graphs

## Links

- **Documentation**: <https://syntlas.org/docs> (placeholder)
- **Tome Registry**: <https://tomes.syntlas.org> (placeholder)
- **Community**: <https://discord.gg/syntlas> (placeholder)
- **Twitter**: <https://twitter.com/syntlas> (placeholder)

---

**Made with ⚡ by the Syntlas Community**
