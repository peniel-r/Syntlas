const std = @import("std");
const schema = @import("../core/schema.zig");

/// Ranking algorithm factors
pub const RankingFactors = struct {
    relevance_weight: f32 = 1.0,
    quality_weight: f32 = 0.5,
    recency_weight: f32 = 0.2,
    popularity_weight: f32 = 0.1,
};

pub fn calculateScore(
    relevance: f32,
    quality: schema.QualityFlags,
    factors: RankingFactors,
) f32 {
    var score = relevance * factors.relevance_weight;

    if (quality.tested) score += 0.2 * factors.quality_weight;
    if (quality.production_ready) score += 0.3 * factors.quality_weight;
    if (quality.benchmarked) score += 0.1 * factors.quality_weight;
    if (quality.deprecated) score *= 0.5;

    return score;
}

test "calculateScore basic" {
    const quality = schema.QualityFlags{ .tested = true, .production_ready = true };
    const score = calculateScore(1.0, quality, .{});
    try std.testing.expect(score > 1.0);
}
