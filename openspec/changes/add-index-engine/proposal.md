# Change: Index Engine - Multi-Index Search System

## Why

Fast search requires specialized indices. Syntlas needs an inverted index for text search, a graph index for neural connections, and a metadata index for faceted filtering. These indices enable sub-10ms search performance.

## What Changes

- Implement inverted index (keyword → neurona_ids mapping)
- Implement graph index (adjacency lists for neural connections)
- Implement metadata index (bitmap indices for faceted filtering)
- Build index construction pipeline
- Add index persistence (save/load from disk)
- Implement memory mapping for large indices
- Create basic search query parser

## Impact

- Affected specs: `index-engine`
- Affected code: `src/index/`, `src/search/`
- Dependencies: Phase 1 (Foundation) must be complete
