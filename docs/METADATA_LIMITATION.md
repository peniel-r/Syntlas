# Search Metadata Display Limitation

## Issue

When running `syntlas search <query>`, the search results display:
- Difficulty: unknown
- Category: unknown

However, the `docs <neurona-id>` command correctly shows full metadata:
- Difficulty: actual value (e.g., "advanced", "novice", etc.)
- Category: actual value (e.g., "language", "library", etc.)

## Root Cause

The search pipeline in `src/search/engine.zig` creates `ActivationSummary` structures in `stage7_FormatResults()`. These structures include `difficulty` and `category` fields that should be populated from the metadata index.

Currently, these fields default to `.unknown` because the metadata retrieval from the index is not working correctly during search result formatting.

## Affected Code

- `src/search/engine.zig` - `stage7_FormatResults()` function
- `src/core/schema.zig` - `ActivationSummary` struct definition
- `src/index/metadata.zig` - Metadata index (difficulty and category bitmaps)
- `src/output/text.zig` - Result formatting

## Workarounds

1. **Use `docs` command**: View individual neurona metadata directly
   ```bash
   syntlas docs <neurona-id>
   ```

2. **Filter by difficulty**: Use the `--difficulty` flag with search
   ```bash
   syntlas search "<query>" --difficulty advanced
   ```

3. **Filter by category**: Use the `--category` flag with search
   ```bash
   syntlas search "<query>" --category language
   ```

## Implementation Notes

The metadata is correctly stored in the index during tome loading. The issue is specifically in the search result retrieval/display phase, not in the indexing phase.

## Related Issues

- **Syntlas-2kd**: Phase 1: Foundation (Closed)
- **Syntlas-3im**: Phase 6: Embedded Tomes (Status: Open)
- **Syntlas-t4h**: Search results show unknown metadata (New - Open)

## Resolution

This will be addressed by implementing proper metadata retrieval in the search engine's result formatting phase, or by creating a separate search command that includes metadata in results.
