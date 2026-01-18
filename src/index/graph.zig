const std = @import("std");
const Allocator = std.mem.Allocator;
const schema = @import("../core/schema.zig");
const RelationshipType = schema.RelationshipType;

/// Graph index: neurona synapses via adjacency lists
pub const GraphIndex = struct {
    /// Forward synapses: neurona_id → list of outgoing synapses
    forward: std.StringHashMapUnmanaged(SynapseList),
    /// Backward synapses: neurona_id → list of incoming synapses
    backward: std.StringHashMapUnmanaged(SynapseList),
    allocator: Allocator,

    pub const Synapse = struct {
        target_id: []const u8,
        relationship: RelationshipType,
        weight: u8, // 0 - 100

        pub fn init(target_id: []const u8, relationship: RelationshipType, weight: u8) Synapse {
            return .{
                .target_id = target_id,
                .relationship = relationship,
                .weight = weight,
            };
        }
    };

    pub const SynapseList = struct {
        synapses: std.ArrayListUnmanaged(Synapse),

        pub fn init() SynapseList {
            return .{ .synapses = .{} };
        }

        pub fn deinit(self: *SynapseList, allocator: Allocator) void {
            for (self.synapses.items) |conn| {
                allocator.free(conn.target_id);
            }
            self.synapses.deinit(allocator);
        }

        pub fn add(self: *SynapseList, allocator: Allocator, target_id: []const u8, relationship: RelationshipType, weight: u8) !void {
            const id_copy = try allocator.dupe(u8, target_id);
            errdefer allocator.free(id_copy);

            const conn = Synapse.init(id_copy, relationship, weight);
            try self.synapses.append(allocator, conn);
        }

        /// Get synapses sorted by weight (descending)
        pub fn getSortedByWeight(self: *const SynapseList, allocator: Allocator) ![]Synapse {
            const sorted = try allocator.dupe(Synapse, self.synapses.items);
            std.mem.sort(Synapse, sorted, {}, compareWeight);
            return sorted;
        }

        fn compareWeight(_: void, a: Synapse, b: Synapse) bool {
            return a.weight > b.weight; // Descending order
        }
    };

    pub fn init(allocator: Allocator) GraphIndex {
        return .{
            .forward = .{},
            .backward = .{},
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *GraphIndex) void {
        var it = self.forward.iterator();
        while (it.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(self.allocator);
        }
        self.forward.deinit(self.allocator);

        var it_back = self.backward.iterator();
        while (it_back.next()) |entry| {
            self.allocator.free(entry.key_ptr.*);
            entry.value_ptr.deinit(self.allocator);
        }
        self.backward.deinit(self.allocator);
    }

    /// Add a directed synapse from source to target
    pub fn addSynapse(
        self: *GraphIndex,
        source_id: []const u8,
        target_id: []const u8,
        relationship: RelationshipType,
        weight: u8,
    ) !void {
        // Add to forward index
        try self.addToIndex(&self.forward, source_id, target_id, relationship, weight);

        // Add to backward index for bidirectional lookup
        try self.addToIndex(&self.backward, target_id, source_id, relationship, weight);
    }

    fn addToIndex(
        self: *GraphIndex,
        index: *std.StringHashMapUnmanaged(SynapseList),
        from_id: []const u8,
        to_id: []const u8,
        relationship: RelationshipType,
        weight: u8,
    ) !void {
        const from_copy = try self.allocator.dupe(u8, from_id);
        errdefer self.allocator.free(from_copy);

        const result = try index.getOrPut(self.allocator, from_copy);
        if (!result.found_existing) {
            result.value_ptr.* = SynapseList.init();
        } else {
            self.allocator.free(from_copy);
        }

        try result.value_ptr.add(self.allocator, to_id, relationship, weight);
    }

    /// Get outgoing synapses from a neurona
    pub fn getOutgoing(self: *const GraphIndex, neurona_id: []const u8) ?*const SynapseList {
        return self.forward.getPtr(neurona_id);
    }

    /// Get incoming synapses to a neurona (bidirectional lookup)
    pub fn getIncoming(self: *const GraphIndex, neurona_id: []const u8) ?*const SynapseList {
        return self.backward.getPtr(neurona_id);
    }

    /// Get connections of a specific type
    pub fn getByRelationship(
        self: *const GraphIndex,
        neurona_id: []const u8,
        relationship: RelationshipType,
        allocator: Allocator,
    ) ![]Synapse {
        const synapses = self.getOutgoing(neurona_id) orelse return &[_]Synapse{};

        var filtered = std.ArrayListUnmanaged(Synapse){};
        errdefer filtered.deinit(allocator);

        for (synapses.synapses.items) |conn| {
            if (conn.relationship == relationship) {
                try filtered.append(allocator, conn);
            }
        }

        return filtered.toOwnedSlice(allocator);
    }

    /// Get prerequisites for a neurona
    pub fn getPrerequisites(self: *const GraphIndex, neurona_id: []const u8, allocator: Allocator) ![]Synapse {
        return self.getByRelationship(neurona_id, .prerequisite, allocator);
    }

    /// Get related topics for a neurona
    pub fn getRelated(self: *const GraphIndex, neurona_id: []const u8, allocator: Allocator) ![]Synapse {
        return self.getByRelationship(neurona_id, .related, allocator);
    }

    /// Get next topics for a neurona
    pub fn getNextTopics(self: *const GraphIndex, neurona_id: []const u8, allocator: Allocator) ![]Synapse {
        return self.getByRelationship(neurona_id, .next_topic, allocator);
    }
};

test "GraphIndex basic operations" {
    const allocator = std.testing.allocator;
    var graph = GraphIndex.init(allocator);
    defer graph.deinit();

    try graph.addSynapse("py.async.coroutines", "py.functions.generators", .prerequisite, 90);
    try graph.addSynapse("py.async.coroutines", "py.async.await", .related, 80);

    const outgoing = graph.getOutgoing("py.async.coroutines").?;
    try std.testing.expectEqual(@as(usize, 2), outgoing.synapses.items.len);
}

test "GraphIndex bidirectional lookup" {
    const allocator = std.testing.allocator;
    var graph = GraphIndex.init(allocator);
    defer graph.deinit();

    try graph.addSynapse("A", "B", .prerequisite, 90);

    // Forward lookup
    const outgoing = graph.getOutgoing("A").?;
    try std.testing.expectEqual(@as(usize, 1), outgoing.synapses.items.len);

    // Backward lookup
    const incoming = graph.getIncoming("B").?;
    try std.testing.expectEqual(@as(usize, 1), incoming.synapses.items.len);
}

test "GraphIndex filter by relationship" {
    const allocator = std.testing.allocator;
    var graph = GraphIndex.init(allocator);
    defer graph.deinit();

    try graph.addSynapse("A", "B", .prerequisite, 90);
    try graph.addSynapse("A", "C", .related, 70);
    try graph.addSynapse("A", "D", .prerequisite, 80);

    const prereqs = try graph.getPrerequisites("A", allocator);
    defer allocator.free(prereqs);

    try std.testing.expectEqual(@as(usize, 2), prereqs.len);
}

test "GraphIndex weighted sorting" {
    const allocator = std.testing.allocator;
    var graph = GraphIndex.init(allocator);
    defer graph.deinit();

    try graph.addSynapse("A", "B", .related, 50);
    try graph.addSynapse("A", "C", .related, 90);
    try graph.addSynapse("A", "D", .related, 70);

    var synapses = graph.getOutgoing("A").?;
    const sorted = try synapses.getSortedByWeight(allocator);
    defer allocator.free(sorted);

    try std.testing.expectEqual(@as(usize, 3), sorted.len);
    try std.testing.expect(sorted[0].weight >= sorted[1].weight);
    try std.testing.expect(sorted[1].weight >= sorted[2].weight);
}
