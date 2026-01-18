const std = @import("std");
const Allocator = std.mem.Allocator;
const schema = @import("../core/schema.zig");
const Category = schema.Category;
const Difficulty = schema.Difficulty;

/// Metadata index using bitmap indices for faceted filtering
pub const MetadataIndex = struct {
    /// Bitmap for each category
    category_bitmaps: std.EnumMap(Category, Bitmap),
    /// Bitmap for each difficulty level
    difficulty_bitmaps: std.EnumMap(Difficulty, Bitmap),
    /// Bitmap for each tag
    tag_bitmaps: std.StringHashMapUnmanaged(Bitmap),
    /// Map neurona_id to index position
    neurona_positions: std.StringHashMapUnmanaged(usize),
    /// Reverse map: position to neurona_id
    position_neuronas: std.ArrayListUnmanaged([]const u8),
    /// parallel to position_neuronas
    quality_flags: std.ArrayListUnmanaged(schema.QualityFlags),
    /// parallel to position_neuronas
    search_weights: std.ArrayListUnmanaged(u8),
    allocator: Allocator,

    pub const Bitmap = struct {
        bits: std.DynamicBitSetUnmanaged,

        pub fn init() Bitmap {
            return .{ .bits = .{} };
        }

        pub fn deinit(self: *Bitmap, allocator: Allocator) void {
            self.bits.deinit(allocator);
        }

        pub fn set(self: *Bitmap, allocator: Allocator, index: usize) !void {
            if (index >= self.bits.capacity()) {
                try self.bits.resize(allocator, index + 1, false);
            }
            self.bits.set(index);
        }

        pub fn isSet(self: *const Bitmap, index: usize) bool {
            if (index >= self.bits.capacity()) return false;
            return self.bits.isSet(index);
        }

        /// AND operation: intersection of two bitmaps
        pub fn andWith(self: *Bitmap, allocator: Allocator, other: *const Bitmap) !void {
            const max_len = @max(self.bits.capacity(), other.bits.capacity());
            if (self.bits.capacity() < max_len) {
                try self.bits.resize(allocator, max_len, false);
            }

            var i: usize = 0;
            while (i < max_len) : (i += 1) {
                if (!other.isSet(i)) {
                    if (i < self.bits.capacity()) {
                        self.bits.unset(i);
                    }
                }
            }
        }

        /// OR operation: union of two bitmaps
        pub fn orWith(self: *Bitmap, allocator: Allocator, other: *const Bitmap) !void {
            const max_len = @max(self.bits.capacity(), other.bits.capacity());
            if (self.bits.capacity() < max_len) {
                try self.bits.resize(allocator, max_len, false);
            }

            var i: usize = 0;
            while (i < other.bits.capacity()) : (i += 1) {
                if (other.isSet(i)) {
                    self.bits.set(i);
                }
            }
        }

        /// NOT operation: invert all bits
        pub fn invert(self: *Bitmap) void {
            self.bits.toggleAll();
        }

        /// Get all set bit indices
        pub fn getSetIndices(self: *const Bitmap, allocator: Allocator) ![]usize {
            var indices = std.ArrayListUnmanaged(usize){};
            errdefer indices.deinit(allocator);

            var i: usize = 0;
            while (i < self.bits.capacity()) : (i += 1) {
                if (self.bits.isSet(i)) {
                    try indices.append(allocator, i);
                }
            }

            return indices.toOwnedSlice(allocator);
        }
    };

    pub fn init(allocator: Allocator) MetadataIndex {
        var category_bitmaps = std.EnumMap(Category, Bitmap){};
        var difficulty_bitmaps = std.EnumMap(Difficulty, Bitmap){};

        inline for (@typeInfo(Category).@"enum".fields) |field| {
            category_bitmaps.put(@enumFromInt(field.value), Bitmap.init());
        }

        inline for (@typeInfo(Difficulty).@"enum".fields) |field| {
            difficulty_bitmaps.put(@enumFromInt(field.value), Bitmap.init());
        }

        return .{
            .category_bitmaps = category_bitmaps,
            .difficulty_bitmaps = difficulty_bitmaps,
            .tag_bitmaps = .{},
            .neurona_positions = .{},
            .position_neuronas = .{},
            .quality_flags = .{},
            .search_weights = .{},
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *MetadataIndex) void {
        var cat_it = self.category_bitmaps.iterator();
        while (cat_it.next()) |entry| {
            entry.value.deinit(self.allocator);
        }

        var diff_it = self.difficulty_bitmaps.iterator();
        while (diff_it.next()) |entry| {
            entry.value.deinit(self.allocator);
        }

        var tag_it = self.tag_bitmaps.iterator();
        while (tag_it.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(self.allocator);
        }
        self.tag_bitmaps.deinit(self.allocator);

        var pos_it = self.neurona_positions.iterator();
        while (pos_it.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
        }
        self.neurona_positions.deinit(self.allocator);

        for (self.position_neuronas.items) |id| {
            self.allocator.free(id);
        }
        self.position_neuronas.deinit(self.allocator);
        self.quality_flags.deinit(self.allocator);
        self.search_weights.deinit(self.allocator);
    }

    /// Add a neurona to the index
    pub fn addNeurona(
        self: *MetadataIndex,
        neurona_id: []const u8,
        category: Category,
        difficulty: Difficulty,
        tags: []const []const u8,
        quality: schema.QualityFlags,
        search_weight: u8,
    ) !void {
        // Get or assign position for this neurona
        const position = self.position_neuronas.items.len;

        const id_copy1 = try self.allocator.dupe(u8, neurona_id);
        errdefer self.allocator.free(id_copy1);

        const id_copy2 = try self.allocator.dupe(u8, neurona_id);
        errdefer self.allocator.free(id_copy2);

        try self.neurona_positions.put(self.allocator, id_copy1, position);
        try self.position_neuronas.append(self.allocator, id_copy2);
        try self.quality_flags.append(self.allocator, quality);
        try self.search_weights.append(self.allocator, search_weight);

        // Set category bitmap
        if (self.category_bitmaps.getPtr(category)) |bitmap| {
            try bitmap.set(self.allocator, position);
        }

        // Set difficulty bitmap
        if (self.difficulty_bitmaps.getPtr(difficulty)) |bitmap| {
            try bitmap.set(self.allocator, position);
        }

        // Set tag bitmaps
        for (tags) |tag| {
            const tag_copy = try self.allocator.dupe(u8, tag);
            errdefer self.allocator.free(tag_copy);

            const result = try self.tag_bitmaps.getOrPut(self.allocator, tag_copy);
            if (!result.found_existing) {
                result.value_ptr.* = Bitmap.init();
            } else {
                self.allocator.free(tag_copy);
            }

            try result.value_ptr.set(self.allocator, position);
        }
    }

    /// Filter by category
    pub fn filterByCategory(self: *const MetadataIndex, category: Category, allocator: Allocator) ![][]const u8 {
        const bitmap = self.category_bitmaps.get(category) orelse return &[_][]const u8{};
        return self.bitmapToNeuronaIds(&bitmap, allocator);
    }

    /// Filter by difficulty
    pub fn filterByDifficulty(self: *const MetadataIndex, difficulty: Difficulty, allocator: Allocator) ![][]const u8 {
        const bitmap = self.difficulty_bitmaps.get(difficulty) orelse return &[_][]const u8{};
        return self.bitmapToNeuronaIds(&bitmap, allocator);
    }

    /// Filter by tag
    pub fn filterByTag(self: *const MetadataIndex, tag: []const u8, allocator: Allocator) ![][]const u8 {
        const bitmap = self.tag_bitmaps.getPtr(tag) orelse return &[_][]const u8{};
        return self.bitmapToNeuronaIds(bitmap, allocator);
    }

    /// Combined filter: category AND difficulty
    pub fn filterCombined(
        self: *const MetadataIndex,
        category: ?Category,
        difficulty: ?Difficulty,
        tags: []const []const u8,
        allocator: Allocator,
    ) ![][]const u8 {
        var result_bitmap = Bitmap.init();
        defer result_bitmap.deinit(allocator);

        var initialized = false;

        // Start with category filter
        if (category) |cat| {
            if (self.category_bitmaps.get(cat)) |bitmap| {
                result_bitmap = try self.cloneBitmap(&bitmap, allocator);
                initialized = true;
            }
        }

        // AND with difficulty filter
        if (difficulty) |diff| {
            if (self.difficulty_bitmaps.get(diff)) |bitmap| {
                if (initialized) {
                    try result_bitmap.andWith(allocator, &bitmap);
                } else {
                    result_bitmap = try self.cloneBitmap(&bitmap, allocator);
                    initialized = true;
                }
            }
        }

        // AND with tag filters
        for (tags) |tag| {
            if (self.tag_bitmaps.getPtr(tag)) |bitmap| {
                if (initialized) {
                    try result_bitmap.andWith(allocator, bitmap);
                } else {
                    result_bitmap = try self.cloneBitmap(bitmap, allocator);
                    initialized = true;
                }
            }
        }

        if (!initialized) return &[_][]const u8{};
        return self.bitmapToNeuronaIds(&result_bitmap, allocator);
    }

    pub fn getQuality(self: *const MetadataIndex, neurona_id: []const u8) ?schema.QualityFlags {
        const position = self.neurona_positions.get(neurona_id) orelse return null;
        return self.quality_flags.items[position];
    }

    pub fn getSearchWeight(self: *const MetadataIndex, neurona_id: []const u8) u8 {
        const position = self.neurona_positions.get(neurona_id) orelse return 100;
        return self.search_weights.items[position];
    }

    fn cloneBitmap(self: *const MetadataIndex, source: *const Bitmap, allocator: Allocator) !Bitmap {
        _ = self;
        var clone = Bitmap.init();
        if (source.bits.capacity() > 0) {
            try clone.bits.resize(allocator, source.bits.capacity(), false);
            var i: usize = 0;
            while (i < source.bits.capacity()) : (i += 1) {
                if (source.isSet(i)) {
                    clone.bits.set(i);
                }
            }
        }
        return clone;
    }

    fn bitmapToNeuronaIds(self: *const MetadataIndex, bitmap: *const Bitmap, allocator: Allocator) ![][]const u8 {
        const indices = try bitmap.getSetIndices(allocator);
        defer allocator.free(indices);

        var neurona_ids = std.ArrayListUnmanaged([]const u8){};
        errdefer neurona_ids.deinit(allocator);

        for (indices) |index| {
            if (index < self.position_neuronas.items.len) {
                try neurona_ids.append(allocator, self.position_neuronas.items[index]);
            }
        }

        return neurona_ids.toOwnedSlice(allocator);
    }
};

test "MetadataIndex basic operations" {
    const allocator = std.testing.allocator;
    var index = MetadataIndex.init(allocator);
    defer index.deinit();

    try index.addNeurona("neuron1", .concept, .intermediate, &[_][]const u8{"async"}, .{}, 100);
    try index.addNeurona("neuron2", .snippet, .novice, &[_][]const u8{"async"}, .{}, 100);

    const concepts = try index.filterByCategory(.concept, allocator);
    defer allocator.free(concepts);
    try std.testing.expectEqual(@as(usize, 1), concepts.len);
}

test "MetadataIndex combined filter" {
    const allocator = std.testing.allocator;
    var index = MetadataIndex.init(allocator);
    defer index.deinit();

    try index.addNeurona("neuron1", .concept, .novice, &[_][]const u8{"async"}, .{}, 100);
    try index.addNeurona("neuron2", .concept, .intermediate, &[_][]const u8{"async"}, .{}, 100);
    try index.addNeurona("neuron3", .snippet, .novice, &[_][]const u8{"async"}, .{}, 100);

    const results = try index.filterCombined(.concept, .novice, &[_][]const u8{"async"}, allocator);
    defer allocator.free(results);
    try std.testing.expectEqual(@as(usize, 1), results.len);
}

test "Bitmap AND operation" {
    const allocator = std.testing.allocator;
    var bitmap1 = MetadataIndex.Bitmap.init();
    defer bitmap1.deinit(allocator);
    var bitmap2 = MetadataIndex.Bitmap.init();
    defer bitmap2.deinit(allocator);

    try bitmap1.set(allocator, 0);
    try bitmap1.set(allocator, 1);
    try bitmap1.set(allocator, 2);

    try bitmap2.set(allocator, 1);
    try bitmap2.set(allocator, 2);
    try bitmap2.set(allocator, 3);

    try bitmap1.andWith(allocator, &bitmap2);

    try std.testing.expect(!bitmap1.isSet(0));
    try std.testing.expect(bitmap1.isSet(1));
    try std.testing.expect(bitmap1.isSet(2));
}
