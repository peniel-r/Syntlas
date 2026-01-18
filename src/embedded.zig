const std = @import("std");

/// The compressed archive of embedded tomes.
/// This file is generated during the build process.
pub const tomes_archive = @embedFile("tomes.tar.gz");
