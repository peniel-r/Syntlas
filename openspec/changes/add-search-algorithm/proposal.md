# Change: Search Algorithm - 5-Stage Neural Activation Search

## Why

Syntlas's core value proposition is intelligent search through neural activation. The 5-stage pipeline combines text matching, semantic discovery, context filtering, graph expansion, and ranking to deliver highly relevant results.

## What Changes

- Implement Stage 1: Text matching with inverted index
- Implement Stage 2: Semantic use-case matching
- Implement Stage 3: Context-aware filtering (user skill, platform, goals)
- Implement Stage 4: Graph expansion (traverse prerequisites, related, next)
- Implement Stage 5: Ranking algorithm with weighted scoring
- Add fuzzy search (Levenshtein distance)
- Implement query result formatting

## Impact

- Affected specs: `search-algorithm`
- Affected code: `src/search/engine.zig`, `src/search/ranking.zig`
- Dependencies: Phase 2 (Index Engine) must be complete
