# Change: Security Hardening - Defense-in-Depth for Untrusted Tomes

## Why

Syntlas processes untrusted content from community tomes. Defense-in-depth security is critical to prevent path traversal, code injection, and other attacks. This phase implements sandboxing, signature verification, and trust levels.

## What Changes

- Implement safe YAML parser (no arbitrary object instantiation)
- Add path traversal validation (reject `..` and absolute paths)
- Detect dangerous command patterns
- Implement command blocklist
- Build sandboxing framework (seccomp, restricted tokens, sandbox-exec)
- Add tome signature verification (GPG/checksums)
- Require user confirmation for shell commands
- Enforce trust levels (embedded, official, community, untrusted)
- Create security test suite

## Impact

- Affected specs: `security`
- Affected code: `src/security/`, `src/tome/validator.zig`
- Dependencies: Phase 4 (Tome System) must be complete

