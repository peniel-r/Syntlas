# Change: Tome System - Installation and Management

## Why

Syntlas's decentralized architecture requires a robust tome management system. Users need to install tomes from various sources (tar.gz, git, local paths), validate them against the spec, and manage multiple tomes simultaneously.

## What Changes

- Implement tome validator (spec compliance checker)
- Build tome installer (tar.gz, git clone, local path support)
- Create optional tome registry for discovery
- Enable embedded tome bundling (compress into binary)
- Manage downloaded tomes (~/.config/syntlas/tomes/)
- Parse tome metadata (tome.json)
- Support multi-tome loading and searching

## Impact

- Affected specs: `tome-system`
- Affected code: `src/tome/`, `tomes/`
- Dependencies: Phase 2 (Index Engine) must be complete
