# Windows Sandbox Design: Restricted Tokens

## Overview

For Windows, we will implement a sandbox using **Restricted Tokens** and **Job Objects**. This provides a robust way to run untrusted code snippets with minimal privileges without requiring administrative rights for the host process.

## Architecture

### 1. Token Restriction

We will use `CreateRestrictedToken` to create a new access token that has:

- Reduced SIDs (e.g., removing Administrator group).
- Restricted SIDs (adding the restricted SID to the token).
- Disabled Privileges (removing all dangerous privileges).

### 2. Job Objects

To prevent resource exhaustion (Fork bombs, memory leaks), we will use Windows **Job Objects**:

- `ActiveProcessLimit`: Set to 1 to prevent spawning child processes (if desired).
- `UserHandleLimit`: Set to 0 to prevent UI interaction.
- `MemoryLimit`: Restrict total memory usage.
- `PerProcessUserTimeLimit`: Limit CPU time to avoid infinite loops.

### 3. Process Execution

We will use `CreateProcessAsUserW` to launch the sandboxed process with the restricted token and assigned to the Job Object.

### 4. Communication

Initially, we will use standard pipes (stdin/stdout/stderr) for communication. In the future, we might use a restricted named pipe or shared memory if needed.

## Implementation Details

The implementation will reside in `src/security/sandbox_windows.zig`.

### Security Policies

- **No Network**: Restricted tokens don't automatically block network, so we will use a Job Object or Windows Filtering Platform (future) if needed, but for now, we rely on the fact that the restricted user won't have credentials/access to network resources in many environments. (Actually, we should try to disable `SeNetworkLogonRight` or similar if possible).
- **No File Access**: The restricted token will have a specific SID that doesn't have access to anything except the temporary directory we provide.

## Verification

- Verify that `rm -rf C:\` fails within the sandbox.
- Verify that network access is blocked.
- Verify that a fork bomb is caught by the Job Object.
