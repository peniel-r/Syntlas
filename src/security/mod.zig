const std = @import("std");

pub const validator = @import("validator.zig");
pub const trust = @import("trust.zig");
pub const sandbox = @import("sandbox.zig");

pub const SecurityError = error{
    PathTraversalDetected,
    AbsolutePathsNotAllowed,
    InvalidFileExtension,
    DangerousPatternDetected,
    CommandBlocked,
    InvalidSignature,
    ChecksumMismatch,
    UntrustedSource,
};
