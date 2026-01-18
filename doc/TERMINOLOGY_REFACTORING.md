# Terminology Refactoring Task List

**Objective**: Refactor all documentation and code to use canonical terminology from doc/NEURONA_SPEC.md

**Canonical Terms**:
- **Neurona** (not Neuron)
- **Synapse** (not Connection as a data structure)
- **Activation** (not SearchResult)

---

## Priority 1: Critical Documentation Fixes

### 1.1 Fix doc/PLAN.md
- [x] Line 265: Change `Neuronaa` → `Neurona` (typo fix)

### 1.2 Fix openspec/project.md
- [x] Line 52: Change "neuron activation" → "neurona activation"
- [x] Line 54: Change "neuron activation" → "neurona activation"

### 1.3 Fix openspec/specs/foundation/spec.md
- [x] Change requirement title: "Neuron Data Structure" → "Neurona Data Structure"
- [x] Line 5: Change "define a Neuron struct" → "define a Neurona struct"
- [x] Line 15: Change "into a Neuron struct" → "into a Neurona struct"
- [x] Change scenario title: "Parse neuron from markdown file" → "Parse neurona from markdown file"
- [x] Line 22: Change "into a Neuron struct" → "into a Neurona struct"

### 1.4 Fix openspec/changes/archive/2026-01-17-add-foundation/proposal.md
- [x] Change: "Define Neuron, Connection, and SearchResult data structures"
- [x] To: "Define Neurona, Synapse, and Activation data structures"

### 1.5 Fix openspec/changes/archive/2026-01-17-add-foundation/tasks.md
- [x] Change: "Define SearchResult struct for query responses"
- [x] To: "Define Activation struct for query responses"

---

## Priority 2: OpenSpec Changes - Systematic Neuron → Neurona

### 2.1 add-index-engine/
- [x] **proposal.md**: Replace all `\bNeuron\b` with `Neurona`
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~10 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~10 instances)

### 2.2 add-search-algorithm/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)

### 2.3 add-tome-system/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~6 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~6 instances)

### 2.4 add-testing-optimization/
- [x] **proposal.md**: Replace all `\bneuron\b` with `neurona` (~2 instances)
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)

### 2.5 add-security-hardening/
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~2 instances)

### 2.6 add-post-alpha/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~5 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~5 instances)

### 2.7 add-embedded-tomes/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~15 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~15 instances)

### 2.8 add-cli-output/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)
- [x] **spec.md**: Replace all `\bneuron\b` with `neurona` (~8 instances)

### 2.9 add-alpha-release/
- [x] **tasks.md**: Replace all `\bneuron\b` with `neurona` (~2 instances)

---

## Priority 3: Code Refactoring

### 3.1 Core Data Structures
- [x] **src/core/schema.zig**: Rename `Neuron` struct → `Neurona`
- [x] **src/core/schema.zig**: Update all references from `Neuron` to `Neurona`
- [x] **src/core/schema.zig**: Rename `SearchResult` struct → `Activation`
- [x] **src/core/schema.zig**: Rename `Connection` struct → `Synapse` (if exists)
- [x] **src/core/schema.zig**: Update all type signatures using new names

### 3.2 Index Engine
- [x] **src/index/mod.zig**: Update all `Neuron` references → `Neurona`
- [x] **src/index/builder.zig**: Update all `neuron` variable names → `neurona`
- [x] **src/index/builder.zig**: Update all `neuron_id` → `neurona_id`
- [x] **src/index/inverted.zig**: Update all `Neuron` → `Neurona` references
- [x] **src/index/graph.zig**: Update all `neuron` → `neurona` variable names
- [x] **src/index/graph.zig**: Update synapse connection terminology (if using "Connection")
- [x] **src/index/metadata.zig**: Update all `neuron` → `neurona` references
- [x] **src/index/persistence.zig**: Update all `Neuron` → `Neurona` in serialization

### 3.3 Main Application
- [x] **src/main.zig**: Update all `Neuron` → `Neurona` references
- [x] **src/main.zig**: Update all `SearchResult` → `Activation` references
- [x] **src/main.zig**: Update all `neuron` → `neurona` variable names

### 3.4 Root Module
- [x] **src/root.zig**: Update public API exports (if any)
- [x] **src/root.zig**: Update type definitions

### 3.5 Config Module
- [x] **src/config/mod.zig**: Update any `neuron` → `neurona` references
- [x] **src/config/manager.zig**: Update variable names

### 3.6 Tome Module
- [x] **src/tome/mod.zig**: Update all `Neuron` → `Neurona` references
- [x] **src/tome/parser.zig**: Update parser to return `Neurona` struct
- [x] **src/tome/parser.zig**: Update all `neuron` → `neurona` variable names
- [x] **src/tome/extractor.zig**: Update extraction logic for `Neurona`
- [x] **src/tome/yaml.zig**: Update YAML field parsing for `Neurona`

### 3.7 Comments and Documentation in Code
- [x] **All .zig files**: Search for `//.*neuron.*` comments and update to `neurona`
- [x] **All .zig files**: Search for `//.*Connection.*` comments and update to `Synapse` (if referring to struct)
- [x] **All .zig files**: Search for `//.*SearchResult.*` comments and update to `Activation`

---

## Priority 4: Development Tooling

### 4.1 Pre-commit Hook
- [x] Create `.git/hooks/pre-commit` script to validate terminology
- [x] Add check for `\bNeuron\b` (except "neuronas")
- [x] Add check for `\bneuron\b` (except "neuronas")
- [x] Add check for `\bConnection\b` as struct name
- [x] Add check for `\bSearchResult\b` as struct name
- [x] Test pre-commit hook with intentional errors

### 4.2 CI/CD Validation
- [x] Add terminology validation step to GitHub Actions workflow
- [x] Use ripgrep to search for incorrect terminology
- [x] Fail build if any incorrect terminology found
- [x] Test CI/CD validation with PR

### 4.3 Documentation Update
- [x] **openspec/AGENTS.md**: Add "Terminology Compliance Checklist" section
- [x] Add checklist items for Neurona, Synapse, Activation terminology
- [x] Add examples of correct vs incorrect usage
- [x] Update "Quick Reference" section if needed

---

## Priority 5: Validation & Testing

### 5.1 Documentation Validation
- [x] Run comprehensive search for any remaining `\bNeuron\b` instances
- [x] Run comprehensive search for any remaining `\bneuron\b` instances
- [x] Run comprehensive search for any remaining `\bConnection\b` (as struct name)
- [x] Run comprehensive search for any remaining `\bSearchResult\b` (as struct name)
- [x] Verify all instances are correct contextually (e.g., descriptive use of "connection")

### 5.2 Code Compilation
- [x] Run `zig build` to ensure all type changes compile
- [x] Run `zig build test` to ensure tests compile
- [x] Fix any compilation errors from renaming
- [x] Run `zig test` to ensure all tests pass

### 5.3 Application Testing
- [x] Run `zig build run` for 30+ seconds with no errors
- [x] Verify application starts correctly
- [x] Test basic search functionality
- [x] Verify no runtime errors from terminology changes

### 5.4 Code Review
- [x] Review all changed files for missed instances
- [x] Verify variable names follow convention (`neurona_id`, `neurona_list`, etc.)
- [x] Verify comments use correct terminology
- [x] Verify documentation strings are updated

---

## Priority 6: Completion & Sign-off

### 6.1 Git Commit
- [x] Stage all changed files
- [x] Write commit message: "Refactor: Standardize terminology per NEURONA_SPEC.md"
- [x] Include detailed commit body explaining changes
- [x] Get approval before committing
- [x] Execute `git commit`

### 6.2 Push to Remote
- [x] Run `git pull --rebase`
- [x] Run `bd sync`
- [x] Run `git push`
- [x] Verify `git status` shows "up to date with origin"

### 6.3 Documentation Update
- [x] Update CHANGELOG.md (if exists) with terminology refactoring entry
- [x] Update doc/PLAN.md to reflect completed refactoring
- [x] Update openspec/project.md to reflect completed refactoring

---

## Quick Reference Tables

### File-by-File Summary

| File | Neuron→Neurona | Connection→Synapse | SearchResult→Activation |
|-------|------------------|---------------------|------------------------|
| doc/PLAN.md | 1 typo | - | - |
| openspec/project.md | 2 | - | - |
| openspec/specs/foundation/spec.md | 5 | - | - |
| add-index-engine/ | ~20 | - | - |
| add-search-algorithm/ | ~16 | - | - |
| add-tome-system/ | ~12 | - | - |
| add-testing-optimization/ | ~18 | - | - |
| add-security-hardening/ | ~2 | - | - |
| add-post-alpha/ | ~10 | - | - |
| add-embedded-tomes/ | ~30 | - | - |
| add-cli-output/ | ~16 | - | - |
| add-alpha-release/ | ~2 | - | - |
| archive/2026-01-17-add-foundation/ | 1 | 1 | 2 |
| **src/**/*.zig** | ~50+ | TBD | TBD |

### Regex Patterns for Find/Replace

**Zig Code:**
```
\bNeuron\b → Neurona
\bneuron\b → neurona
\bneuron_id\b → neurona_id
\bneurons\b → neuronas
\*Neuron\b → *Neurona
```

**Documentation (Markdown):**
```
\bNeuron\b → Neurona
\bneuron\b → neurona
\bConnection\b (as struct name) → Synapse
\bSearchResult\b → Activation
```

---

## Success Criteria

**Refactoring is complete when:**
- ✅ Zero instances of `\bNeuron\b` in documentation (except "neuronas")
- ✅ Zero instances of `\bneuron\b` in documentation (except "neuronas")
- ✅ Zero instances of `Neuron` struct in code (only `Neurona` exists)
- ✅ Zero instances of `neuron` variable names (only `neurona` exists)
- ✅ Zero instances of `Connection` struct (only `Synapse` exists)
- ✅ Zero instances of `SearchResult` struct (only `Activation` exists)
- ✅ All code compiles successfully
- ✅ All tests pass
- ✅ Application runs 30+ seconds without errors
- ✅ Pre-commit hook validates terminology
- ✅ CI/CD validates terminology on every PR
- ✅ openspec/AGENTS.md updated with compliance checklist

---

## Execution Notes

### When to Skip Replacements

**Do NOT replace** "Connection" when used as:
- Descriptive term: "connection pooling", "connection weight", "network connection"
- Generic concept: "make a connection", "database connection"
- Technical term unrelated to Neurona System

**Do NOT replace** "neuronas" (correct plural):
- This is the canonical plural form per NEURONA_SPEC.md
- Only replace singular "neuron" with "neurona"

### Variable Naming Convention

**Correct patterns:**
```zig
var neurona: Neurona;
var neurona_id: []const u8;
var neurona_list: ArrayList(Neurona);
var neurona_map: HashMap([]const u8, Neurona);
```

**Incorrect patterns:**
```zig
var neuron: Neuron;  // ❌ Should be Neurona
var neuron_id: []const u8;  // ❌ Should be neurona_id
var neurons: ArrayList(Neurona);  // ❌ Should be neuronas
```

---

**Created**: 2026-01-17  
**Purpose**: Comprehensive task list for terminology standardization per NEURONA_SPEC.md v0.2.0
