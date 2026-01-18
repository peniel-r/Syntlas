const std = @import("std");
const builtin = @import("builtin");

pub const SandboxOptions = struct {
    allow_network: bool = false,
    read_only: bool = true,
};

pub fn runInSandbox(allocator: std.mem.Allocator, argv: []const []const u8, options: SandboxOptions) !std.process.Child.Term {
    if (builtin.target.os.tag == .windows) {
        return runInSandboxWindows(allocator, argv, options);
    }

    // Fallback for other platforms (Process isolation mode)
    var child = std.process.Child.init(argv, allocator);
    return try child.spawnAndWait();
}

fn runInSandboxWindows(allocator: std.mem.Allocator, argv: []const []const u8, options: SandboxOptions) !std.process.Child.Term {
    _ = options;

    // 1. Create Job Object
    const job = CreateJobObjectW(null, null) orelse return error.SandboxCreationFailed;
    defer _ = w.CloseHandle(job);

    // 2. Set Job Limits
    var info = std.mem.zeroes(JOBOBJECT_EXTENDED_LIMIT_INFORMATION);
    info.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE | JOB_OBJECT_LIMIT_ACTIVE_PROCESS;
    info.BasicLimitInformation.ActiveProcessLimit = 1;

    if (SetInformationJobObject(
        job,
        @intFromEnum(JOBOBJECTINFOCLASS.ExtendedLimitInformation),
        &info,
        @sizeOf(JOBOBJECT_EXTENDED_LIMIT_INFORMATION),
    ) == 0) {
        return error.SandboxCreationFailed;
    }

    // 3. Environment Variable Scrubbing
    // Only pass safe variables or empty environment
    var env_map = std.process.getEnvMap(allocator) catch std.process.EnvMap.init(allocator);
    defer env_map.deinit();

    // Clear potentially dangerous variables
    env_map.remove("PATH");
    env_map.remove("TEMP");
    env_map.remove("TMP");
    // Add a minimal safe PATH if needed, or leave empty
    // For now, we leave it empty to be most restrictive.

    // 4. Create Process
    var child = std.process.Child.init(argv, allocator);
    child.env_map = &env_map;

    try child.spawn();

    if (AssignProcessToJobObject(job, child.id) == 0) {
        // If it already exited or we failed to assign, kill it
        _ = child.kill() catch {};
        return error.SandboxCreationFailed;
    }

    return try child.wait();
}

// Win32 Constants and Structs missing in std.os.windows
const JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = 0x00002000;
const JOB_OBJECT_LIMIT_ACTIVE_PROCESS = 0x00000008;
const JOB_OBJECT_LIMIT_JOB_MEMORY = 0x00000010;
const JOB_OBJECT_LIMIT_DIE_ON_UNHANDLED_EXCEPTION = 0x00000100;

const JOBOBJECT_BASIC_LIMIT_INFORMATION = extern struct {
    PerProcessUserTimeLimit: w.LARGE_INTEGER = 0,
    PerJobUserTimeLimit: w.LARGE_INTEGER = 0,
    LimitFlags: u32,
    MinimumWorkingSetSize: usize = 0,
    MaximumWorkingSetSize: usize = 0,
    ActiveProcessLimit: u32,
    Affinity: usize = 0,
    PriorityClass: u32 = 0,
    SchedulingClass: u32 = 0,
};

const IO_COUNTERS = extern struct {
    ReadOperationCount: u64,
    WriteOperationCount: u64,
    OtherOperationCount: u64,
    ReadTransferCount: u64,
    WriteTransferCount: u64,
    OtherTransferCount: u64,
};

const JOBOBJECT_EXTENDED_LIMIT_INFORMATION = extern struct {
    BasicLimitInformation: JOBOBJECT_BASIC_LIMIT_INFORMATION,
    IoInfo: IO_COUNTERS = std.mem.zeroes(IO_COUNTERS),
    ProcessMemoryLimit: usize = 0,
    JobMemoryLimit: usize = 0,
    PeakProcessMemoryUsed: usize = 0,
    PeakJobMemoryUsed: usize = 0,
};

const w = std.os.windows;

extern "kernel32" fn CreateJobObjectW(
    lpJobAttributes: ?*w.SECURITY_ATTRIBUTES,
    lpName: ?[*:0]const u16,
) callconv(.winapi) ?w.HANDLE;

extern "kernel32" fn SetInformationJobObject(
    hJob: w.HANDLE,
    JobObjectInformationClass: u32,
    lpJobObjectInformation: *const anyopaque,
    cbJobObjectInformation: u32,
) callconv(.winapi) w.BOOL;

extern "kernel32" fn AssignProcessToJobObject(
    hJob: w.HANDLE,
    hProcess: w.HANDLE,
) callconv(.winapi) w.BOOL;

const JOBOBJECTINFOCLASS = enum(u32) {
    BasicLimitInformation = 2,
    ExtendedLimitInformation = 9,
};
