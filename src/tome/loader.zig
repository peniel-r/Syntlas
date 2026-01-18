const std = @import("std");
const core = @import("../core/mod.zig");
const parser = @import("parser.zig");

pub const TomeLoader = struct {
    allocator: std.mem.Allocator,
    neuronas: std.ArrayListUnmanaged(core.Neurona),
    contents: std.ArrayListUnmanaged([]const u8),

    pub fn init(allocator: std.mem.Allocator) TomeLoader {
        return .{
            .allocator = allocator,
            .neuronas = .{},
            .contents = .{},
        };
    }

    pub fn deinit(self: *TomeLoader) void {
        for (self.neuronas.items) |*neurona| {
            self.allocator.free(neurona.id);
            self.allocator.free(neurona.title);
            for (neurona.tags) |tag| self.allocator.free(tag);
            for (neurona.keywords) |kw| self.allocator.free(kw);
            for (neurona.use_cases) |uc| self.allocator.free(uc);
            for (neurona.prerequisites) |p| self.allocator.free(p.id);
            for (neurona.related) |r| self.allocator.free(r.id);
            for (neurona.next_topics) |n| self.allocator.free(n.id);
            self.allocator.free(neurona.tags);
            self.allocator.free(neurona.keywords);
            self.allocator.free(neurona.use_cases);
            self.allocator.free(neurona.prerequisites);
            self.allocator.free(neurona.related);
            self.allocator.free(neurona.next_topics);
        }
        self.neuronas.deinit(self.allocator);

        for (self.contents.items) |content| {
            self.allocator.free(content);
        }
        self.contents.deinit(self.allocator);
    }

    pub fn loadTome(self: *TomeLoader, tome_path: []const u8) !void {
        const neuronas_path = try std.fs.path.join(self.allocator, &.{ tome_path, "neuronas" });
        defer self.allocator.free(neuronas_path);

        var dir = try std.fs.cwd().openDir(neuronas_path, .{ .iterate = true });
        defer dir.close();

        var iter = dir.iterate();
        while (try iter.next()) |entry| {
            if (entry.kind != .file) continue;
            if (!std.mem.endsWith(u8, entry.name, ".md")) continue;

            const file_path = try std.fs.path.join(self.allocator, &.{ neuronas_path, entry.name });
            defer self.allocator.free(file_path);

            const file_content = try std.fs.cwd().readFileAlloc(self.allocator, file_path, 1024 * 1024);
            errdefer self.allocator.free(file_content);

            const neurona = parser.parse(self.allocator, file_content) catch |err| {
                std.debug.print("Warning: Failed to parse {s}: {}\n", .{ entry.name, err });
                self.allocator.free(file_content);
                continue;
            };

            // Extract content after frontmatter
            const content_start = neurona.content_offset;
            const content = if (content_start < file_content.len)
                try self.allocator.dupe(u8, file_content[content_start..])
            else
                try self.allocator.dupe(u8, "");

            self.allocator.free(file_content);

            try self.neuronas.append(self.allocator, neurona);
            try self.contents.append(self.allocator, content);
        }
    }

    pub fn loadAllEmbeddedTomes(self: *TomeLoader, base_path: []const u8) !void {
        const tomes = [_][]const u8{ "c", "cpp", "python", "rust", "zig" };

        for (tomes) |tome_name| {
            const tome_path = try std.fs.path.join(self.allocator, &.{ base_path, tome_name });
            defer self.allocator.free(tome_path);

            std.debug.print("Loading {s} tome from {s}...\n", .{ tome_name, tome_path });
            self.loadTome(tome_path) catch |err| {
                std.debug.print("Warning: Failed to load {s} tome: {}\n", .{ tome_name, err });
                continue;
            };
        }
    }

    pub fn getNeuronas(self: *TomeLoader) []const core.Neurona {
        return self.neuronas.items;
    }

    pub fn getContents(self: *TomeLoader) []const []const u8 {
        return self.contents.items;
    }
};
