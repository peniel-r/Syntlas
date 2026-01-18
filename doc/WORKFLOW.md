# Syntlas Development Workflow

> **For Humans and AI Agents** — Spec-driven, issue-tracked development.

---

## Quick Reference

| Tool | Commands |
|------|----------|
| **Beads** | `bd list` · `bd ready` · `bd update <id> --status in_progress` · `bd close <id>` |
| **OpenSpec** | `/openspec-proposal` · `/openspec-apply` · `/openspec-archive` |
| **Zig** | `zig build` · `zig build run` · `zig build test` |
| **Git** | `git pull --rebase` · `bd sync` · `git push` |

---

## Core Principles

| Principle | Rule |
|-----------|------|
| **Immutable Spec** | `NEURONA_SPEC.md` is READ-ONLY for AI agents |
| **Spec-First** | Lock intent with OpenSpec before implementation |
| **Zig 0.15.2+** | All code must align to this version |
| **Explicit Allocators** | Never use globals for large structs |
| **Commit Approval** | Always ask before any commit |

---

## Development Workflow

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  1. SELECT  │──▶│  2. SPECIFY │──▶│ 3. IMPLEMENT│──▶│  4. VERIFY  │──▶│  5. COMMIT  │
│   (Beads)   │   │  (OpenSpec) │   │    (Zig)    │   │   (Build)   │   │  (Git+Docs) │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
```

---

### Step 1: Select Task (Beads)

```bash
bd list                              # Read current high-priority issue
bd ready                             # Find available work
bd update <id> --status in_progress  # Claim the task
```

> [!IMPORTANT]
> **READ FIRST**: Always run `bd show` before writing any code.

---

### Step 2: Specify Intent (OpenSpec)

Before writing code, lock intent with a spec proposal:

```bash
/openspec-proposal    # AI creates change folder with proposal + tasks
```

**Creates:**

```
openspec/changes/<change-name>/
├── proposal.md       # Why and what changes
├── tasks.md          # Implementation checklist
├── design.md         # Technical decisions (optional)
└── specs/            # Delta updates to specs
```

**Review cycle:**

1. Review `proposal.md` and `tasks.md` with stakeholders
2. Iterate until all parties agree
3. Proceed only after approval

> [!WARNING]
> Never skip the spec phase. Implementation without spec leads to drift.

---

### Step 3: Implement (Zig)

After spec approval, implement using `/openspec-apply`:

```bash
/openspec-apply       # AI implements tasks from approved proposal
```

**Zig Memory Rules:**

| Context | Allocator |
|---------|-----------|
| Frame-scoped data | `ArenaAllocator` |
| Background tasks | `PoolAllocator` |
| Dynamic arrays | `ArrayListUnmanaged` |
| Debug builds | `GeneralPurposeAllocator` |

```zig
// ✅ Correct: Explicit allocator
fn process(allocator: std.mem.Allocator, data: []const u8) !void {
    var list = std.ArrayListUnmanaged(u8){};
    defer list.deinit(allocator);
}

// ❌ Wrong: Global state
var global_buffer: [1024]u8 = undefined;
```

**During implementation:**

- Run `zig build` frequently
- Handle comptime errors: Read → Think → Fix

---

### Step 4: Verify (Build + Runtime)

> [!CAUTION]
> Work is **NOT complete** until all verification passes.

```bash
zig build run         # Must succeed
# Application must run 30+ seconds with no errors
zig build test        # Run tests if applicable
```

| Rule | Requirement |
|------|-------------|
| Build Success | `zig build run` must succeed |
| Runtime Stability | 30 seconds minimum, no errors |
| Retry on Failure | Resolve and retry until success |
| No Early Exit | Never stop before verification passes |

---

### Step 5: Commit & Archive

> [!WARNING]
> Always ask for approval before committing.

**After approval:**

```bash
# 1. Commit code
git add -A
git commit -m "descriptive message"

# 2. Push (MANDATORY)
git pull --rebase
bd sync
git push
git status            # Must show "up to date with origin"

# 3. Archive spec change
/openspec-archive     # Merges deltas into openspec/specs/
```

**Update documentation:**

| Document | Update When |
|----------|-------------|
| `doc/PLAN.md` | Task status changes |
| `doc/ARCHITECTURE.md` | Structural changes |
| `README.md` | User-facing changes |
| `<task_id>_implementation.md` | New features completed |

```bash
# 4. Close issue
bd close <id>
```

---

## Directory Structure

```
openspec/
├── specs/                    # Source of truth (approved specs)
├── changes/                  # Active proposals
└── project.md                # Project context

doc/
├── NEURONA_SPEC.md           # IMMUTABLE - Do not modify
├── PLAN.md                   # Development plan
├── ARCHITECTURE.md           # System architecture
├── WORKFLOW.md               # This file
└── <task_id>_implementation.md
```

---

## Error Recovery

**Build failures:**

```
Read error → Identify cause → Fix → zig build  → Repeat → zig build run
```

**Comptime errors:**

```
Read trace → Understand check → Fix types → zig build 
```

---

## Session Handoff

Before ending a work session:

- [ ] All changes committed
- [ ] `git push` succeeded
- [ ] `git status` shows "up to date with origin"
- [ ] Issues updated (`bd close` or status update)
- [ ] OpenSpec changes archived if complete
- [ ] Documentation updated
- [ ] Context provided for next session

---

## Summary Checklist

```
[ ] bd show                           # Read issue
[ ] bd update <id> --status in_progress
[ ] /openspec-proposal                # Create spec
[ ] Review and approve proposal
[ ] /openspec-apply                   # Implement
[ ] zig build check                   # Check frequently
[ ] zig build run                     # Must succeed
[ ] Run 30+ seconds stable
[ ] Ask for commit approval
[ ] git commit + git push
[ ] /openspec-archive                 # Archive spec
[ ] Update docs
[ ] bd close <id>
```

---

*Last updated: 2026-01-17*
