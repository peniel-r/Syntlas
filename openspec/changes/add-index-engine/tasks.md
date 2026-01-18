## 1. Inverted Index

- [x] 1.1 Design hash map structure (keyword → neurona_ids)
- [x] 1.2 Implement keyword tokenization
- [x] 1.3 Build index from neurona collection
- [x] 1.4 Add term frequency weighting

## 2. Graph Index

- [x] 2.1 Design adjacency list structure
- [x] 2.2 Store prerequisite, related, next_topics connections
- [x] 2.3 Add connection weights
- [x] 2.4 Implement bidirectional lookups

## 3. Metadata Index

- [x] 3.1 Implement bitmap indices for categories
- [x] 3.2 Implement bitmap indices for difficulty levels
- [x] 3.3 Implement bitmap indices for tags
- [x] 3.4 Add bitmap AND/OR operations for filtering

## 4. Index Builder

- [x] 4.1 Scan tome directory for markdown files
- [x] 4.2 Parse all neuronas and build indices
- [x] 4.3 Calculate search weights
- [x] 4.4 Generate index statistics

## 5. Index Persistence

- [ ] 5.1 Design binary format for indices
- [ ] 5.2 Implement save to disk
- [ ] 5.3 Implement load from disk
- [ ] 5.4 Add version header for compatibility

## 6. Memory Mapping

- [ ] 6.1 Implement mmap for large index files
- [ ] 6.2 Add lazy loading for cold data
- [ ] 6.3 Optimize memory footprint

## 7. Query Parser

- [ ] 7.1 Parse simple text queries
- [ ] 7.2 Parse facet filters (difficulty:beginner)
- [ ] 7.3 Parse boolean operators (AND, OR, NOT)

## Validation

- [ ] Text search: <10ms p50, <15ms p99
- [ ] Index build time: <100ms for 1,000 neuronas
- [ ] Index load time: <50ms from disk
- [ ] Memory footprint: <20MB for 10,000 neuronas
