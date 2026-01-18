# Change: Embedded Tomes - Core Language Documentation

## Why

Syntlas ships with embedded tomes for the 5 core languages (C, C++, Python, Rust, Zig) to provide immediate value out-of-the-box. These tomes demonstrate the Neurona system and serve as templates for community tome creators.

## What Changes

- Create C tome (ISO C standard, common patterns)
- Create C++ tome (C++17/20 STL, modern idioms)
- Create Python tome (Python 3.12 stdlib, best practices)
- Create Rust tome (stdlib, ownership, async)
- Create Zig tome (stdlib, comptime, patterns)
- Validate all tomes against NEURONA_SPEC
- Test synapses
- Verify search quality

## Impact

- Affected specs: `embedded-tomes`
- Affected code: `tomes/embedded/`
- Dependencies: Phase 5 (Security) must be complete

