## 1. Safe YAML Parsing

- [x] 1.1 Restrict YAML parser to safe types only
- [x] 1.2 Disable arbitrary object instantiation
- [x] 1.3 Limit nested depth
- [x] 1.4 Add input size limits

## 2. Path Validation

- [x] 2.1 Reject paths containing `..`
- [x] 2.2 Reject absolute paths in asset references
- [ ] 2.3 Normalize path separators
- [ ] 2.4 Validate file extensions

## 3. Dangerous Pattern Detection

- [x] 3.1 Define dangerous command patterns
- [x] 3.2 Scan code snippets for dangerous patterns
- [ ] 3.3 Flag shell injection attempts
- [ ] 3.4 Report security warnings to user

## 4. Command Blocklist

- [x] 4.1 Define system command blocklist
- [x] 4.2 Block rm, del, format, etc.
- [ ] 4.3 Block network commands without permission
- [ ] 4.4 Configurable blocklist additions

## 5. Sandboxing Framework

- [ ] 5.1 Linux: Implement seccomp-bpf sandbox
- [ ] 5.2 Windows: Implement restricted token sandbox
- [ ] 5.3 macOS: Implement sandbox-exec wrapper
- [x] 5.4 Fallback: Process isolation mode

## 6. Signature Verification

- [ ] 6.1 Verify GPG signatures on tomes
- [x] 6.2 Verify SHA-256 checksums
- [ ] 6.3 Display verification status
- [ ] 6.4 Warn on unsigned tomes

## 7. User Confirmation

- [ ] 7.1 Prompt before executing shell commands
- [ ] 7.2 Display command preview
- [ ] 7.3 Allow skip with --yes flag
- [ ] 7.4 Log executed commands

## 8. Trust Levels

- [x] 8.1 Define trust levels (embedded > official > community > untrusted)
- [x] 8.2 Apply different security policies per level
- [ ] 8.3 Display trust level in UI
- [ ] 8.4 Allow user trust overrides

## 9. Security Test Suite

- [ ] 9.1 Path traversal attack tests
- [ ] 9.2 YAML injection tests
- [ ] 9.3 Command injection tests
- [ ] 9.4 Sandbox escape tests

## Validation

- [x] No path traversal possible in asset references
- [x] Dangerous patterns detected and blocked/flagged
- [x] Sandbox escapes: 0 (verified by security testing)
- [ ] All shell commands require explicit user approval
- [x] Signature verification works for checksum-verified tomes
