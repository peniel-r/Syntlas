## ADDED Requirements

### Requirement: Safe YAML Parsing

The system SHALL parse YAML safely without risk of code execution:

- No arbitrary object instantiation
- Restricted to safe scalar types (string, int, float, bool)
- Maximum nesting depth of 10 levels
- Input size limits enforced

#### Scenario: YAML injection attempt

- **WHEN** a tome contains YAML with object instantiation syntax
- **THEN** parsing fails with a security error

---

### Requirement: Path Traversal Prevention

The system SHALL reject all path traversal attempts in asset references:

- Reject `..` in any path component
- Reject absolute paths
- Normalize path separators
- Validate allowed file extensions

#### Scenario: Path traversal blocked

- **WHEN** a neurona references `../../etc/passwd`
- **THEN** the reference is rejected with a security error

---

### Requirement: Dangerous Command Detection

The system SHALL detect and flag dangerous command patterns in code snippets:

- Shell injection patterns
- File system destructive commands
- Network access without permission
- Privilege escalation attempts

#### Scenario: Dangerous command flagged

- **WHEN** a code snippet contains `rm -rf /`
- **THEN** a warning is displayed before execution

---

### Requirement: Platform-Specific Sandboxing

The system SHALL sandbox untrusted tome execution using platform-native mechanisms:

- Linux: seccomp-bpf
- Windows: Restricted tokens
- macOS: sandbox-exec
- Fallback: Process isolation

#### Scenario: Sandbox enforcement

- **WHEN** a community tome attempts file system access outside its directory
- **THEN** the operation is blocked by the sandbox

---

### Requirement: Tome Signature Verification

The system SHALL verify tome authenticity via:

- GPG signature verification
- SHA-256 checksum validation
- Visual indicator of verification status
- Warning for unsigned/unverified tomes

#### Scenario: Signed tome verification

- **WHEN** installing a GPG-signed tome
- **THEN** the signature is verified and displayed

#### Scenario: Unsigned tome warning

- **WHEN** installing an unsigned community tome
- **THEN** a security warning is displayed

---

### Requirement: Shell Command Confirmation

The system SHALL require explicit user confirmation before executing shell commands from tomes:

- Display command preview
- Require explicit confirmation
- Support bypass via --yes flag
- Log all executed commands

#### Scenario: Command confirmation prompt

- **WHEN** a code snippet contains an executable command
- **AND** user requests execution
- **THEN** a confirmation prompt is displayed

---

### Requirement: Trust Level Enforcement

The system SHALL enforce trust levels with graduated security policies:

- Embedded: Full trust, no restrictions
- Official: Verified, minimal restrictions
- Community: Sandboxed, user confirmation required
- Untrusted: Maximum restrictions, all actions require approval

#### Scenario: Community tome restrictions

- **WHEN** a community tome is installed
- **THEN** sandbox and confirmation policies are applied
