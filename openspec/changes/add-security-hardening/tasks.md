## 1. Safe YAML Parsing

- [ ] 1.1 Restrict YAML parser to safe types only
- [ ] 1.2 Disable arbitrary object instantiation
- [ ] 1.3 Limit nested depth
- [ ] 1.4 Add input size limits

## 2. Path Validation

- [ ] 2.1 Reject paths containing `..`
- [ ] 2.2 Reject absolute paths in asset references
- [ ] 2.3 Normalize path separators
- [ ] 2.4 Validate file extensions

## 3. Dangerous Pattern Detection

- [ ] 3.1 Define dangerous command patterns
- [ ] 3.2 Scan code snippets for dangerous patterns
- [ ] 3.3 Flag shell injection attempts
- [ ] 3.4 Report security warnings to user

## 4. Command Blocklist

- [ ] 4.1 Define system command blocklist
- [ ] 4.2 Block rm, del, format, etc.
- [ ] 4.3 Block network commands without permission
- [ ] 4.4 Configurable blocklist additions

## 5. Sandboxing Framework

- [ ] 5.1 Linux: Implement seccomp-bpf sandbox
- [ ] 5.2 Windows: Implement restricted token sandbox
- [ ] 5.3 macOS: Implement sandbox-exec wrapper
- [ ] 5.4 Fallback: Process isolation mode

## 6. Signature Verification

- [ ] 6.1 Verify GPG signatures on tomes
- [ ] 6.2 Verify SHA-256 checksums
- [ ] 6.3 Display verification status
- [ ] 6.4 Warn on unsigned tomes

## 7. User Confirmation

- [ ] 7.1 Prompt before executing shell commands
- [ ] 7.2 Display command preview
- [ ] 7.3 Allow skip with --yes flag
- [ ] 7.4 Log executed commands

## 8. Trust Levels

- [ ] 8.1 Define trust levels (embedded > official > community > untrusted)
- [ ] 8.2 Apply different security policies per level
- [ ] 8.3 Display trust level in UI
- [ ] 8.4 Allow user trust overrides

## 9. Security Test Suite

- [ ] 9.1 Path traversal attack tests
- [ ] 9.2 YAML injection tests
- [ ] 9.3 Command injection tests
- [ ] 9.4 Sandbox escape tests

## Validation

- [ ] No path traversal possible in asset references
- [ ] Dangerous patterns detected and blocked/flagged
- [ ] Sandbox escapes: 0 (verified by security testing)
- [ ] All shell commands require explicit user approval
- [ ] Signature verification works for GPG-signed tomes
