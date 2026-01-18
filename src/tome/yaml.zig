const std = @import("std");

pub const TokenType = enum {
    key,
    string,
    number,
    boolean,
    colon,
    l_bracket, // [
    r_bracket, // ]
    hyphen, // -
    l_brace, // {
    r_brace, // }
    comma,
    newline,
    indent,
    eof,
    unknown,
};

pub const Token = struct {
    tag: TokenType,
    value: []const u8,
    line: usize,
    column: usize,
};

pub const Tokenizer = struct {
    source: []const u8,
    index: usize = 0,
    line: usize = 1,
    column: usize = 1,

    pub fn init(source: []const u8) Tokenizer {
        return .{ .source = source };
    }

    pub fn next(self: *Tokenizer) Token {
        self.skipWhitespace();

        if (self.index >= self.source.len) {
            return .{ .tag = .eof, .value = "", .line = self.line, .column = self.column };
        }

        const start = self.index;
        const char = self.source[self.index];

        switch (char) {
            ':' => {
                self.advance();
                return self.makeToken(.colon, self.source[start..self.index]);
            },
            '[' => {
                self.advance();
                return self.makeToken(.l_bracket, self.source[start..self.index]);
            },
            ']' => {
                self.advance();
                return self.makeToken(.r_bracket, self.source[start..self.index]);
            },
            '{' => {
                self.advance();
                return self.makeToken(.l_brace, self.source[start..self.index]);
            },
            '}' => {
                self.advance();
                return self.makeToken(.r_brace, self.source[start..self.index]);
            },
            ',' => {
                self.advance();
                return self.makeToken(.comma, self.source[start..self.index]);
            },
            '-' => {
                self.advance();
                return self.makeToken(.hyphen, self.source[start..self.index]);
            },
            '"' => return self.string(),
            else => return self.identifierOrNumber(),
        }
    }

    fn advance(self: *Tokenizer) void {
        if (self.index < self.source.len) {
            if (self.source[self.index] == '\n') {
                self.line += 1;
                self.column = 1;
            } else {
                self.column += 1;
            }
            self.index += 1;
        }
    }

    fn skipWhitespace(self: *Tokenizer) void {
        while (self.index < self.source.len) {
            switch (self.source[self.index]) {
                ' ', '\t', '\r', '\n' => self.advance(),
                '#' => {
                    while (self.index < self.source.len and self.source[self.index] != '\n') {
                        self.advance();
                    }
                },
                else => return,
            }
        }
    }

    fn makeToken(self: *Tokenizer, tag: TokenType, value: []const u8) Token {
        return .{ .tag = tag, .value = value, .line = self.line, .column = self.column };
    }

    fn string(self: *Tokenizer) Token {
        const start = self.index;
        self.advance(); // Skip "
        while (self.index < self.source.len and self.source[self.index] != '"') {
            self.advance();
        }
        if (self.index < self.source.len) self.advance(); // Skip closing "
        return self.makeToken(.string, self.source[start + 1 .. self.index - 1]);
    }

    fn identifierOrNumber(self: *Tokenizer) Token {
        const start = self.index;
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (isAlphaNumeric(c)) {
                self.advance();
            } else {
                break;
            }
        }
        const value = self.source[start..self.index];
        // TODO: Check if number or boolean
        return self.makeToken(.string, value); // Treat as string/key for now
    }

    fn isAlphaNumeric(c: u8) bool {
        return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_' or c == '.' or c == '-';
    }
};

pub const Parser = struct {
    allocator: std.mem.Allocator,
    tokenizer: Tokenizer,
    current: Token,

    pub fn init(allocator: std.mem.Allocator, source: []const u8) Parser {
        var tokenizer = Tokenizer.init(source);
        const current = tokenizer.next();
        return .{
            .allocator = allocator,
            .tokenizer = tokenizer,
            .current = current,
        };
    }

    fn advance(self: *Parser) void {
        self.current = self.tokenizer.next();
    }

    fn match(self: *Parser, tag: TokenType) bool {
        if (self.current.tag == tag) {
            self.advance();
            return true;
        }
        return false;
    }

    fn expect(self: *Parser, tag: TokenType) !Token {
        if (self.current.tag == tag) {
            const token = self.current;
            self.advance();
            return token;
        }
        return error.UnexpectedToken;
    }

    fn parseArray(self: *Parser) ![][]const u8 {
        var list = std.ArrayListUnmanaged([]const u8){};
        errdefer list.deinit(self.allocator);

        _ = try self.expect(.l_bracket);

        while (self.current.tag != .r_bracket and self.current.tag != .eof) {
            if (self.current.tag == .string) {
                const val_token = try self.expect(.string);
                try list.append(self.allocator, val_token.value);
            } else if (self.current.tag == .l_bracket) {
                // Nested array - skip for now
                _ = try self.parseArray();
            } else {
                self.advance();
            }

            if (self.current.tag == .comma) {
                self.advance();
            }
        }

        _ = try self.expect(.r_bracket);
        return try list.toOwnedSlice(self.allocator);
    }

    pub fn parse(self: *Parser) !std.StringHashMap([]const u8) {
        var map = std.StringHashMap([]const u8).init(self.allocator);
        errdefer map.deinit();

        while (self.current.tag != .eof) {
            // Expect Key: Value
            const key_token = try self.expect(.string); // Keys are treated as strings
            _ = try self.expect(.colon);

            // Handle different value types
            if (self.current.tag == .string) {
                const val_token = try self.expect(.string);
                try map.put(key_token.value, val_token.value);
            } else if (self.current.tag == .l_bracket) {
                // Array value - for now, store as comma-separated string
                var array_list = std.ArrayListUnmanaged(u8){};
                defer array_list.deinit(self.allocator);

                const array = try self.parseArray();
                for (array, 0..) |item, i| {
                    if (i > 0) try array_list.append(self.allocator, ',');
                    try array_list.appendSlice(self.allocator, item);
                }
                self.allocator.free(array);
                try map.put(key_token.value, try array_list.toOwnedSlice(self.allocator));
            } else {
                // Skip other complex structures for now
                self.advance();
            }

            // Optional comma or newline handling if implemented
            if (self.current.tag == .comma) {
                self.advance();
            }
        }

        return map;
    }

    test "tokenizer simple" {
        const source = "key: value\n";
        var tokenizer = Tokenizer.init(source);
        const token1 = tokenizer.next();
        try std.testing.expectEqual(TokenType.string, token1.tag);
        try std.testing.expectEqualStrings("key", token1.value);

        const token2 = tokenizer.next();
        try std.testing.expectEqual(TokenType.colon, token2.tag);

        const token3 = tokenizer.next();
        try std.testing.expectEqual(TokenType.string, token3.tag);
        try std.testing.expectEqualStrings("value", token3.value);
    }

    test "parse simple map" {
        const source = "key: value\nkey2: value2\n";
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var parser = Parser.init(allocator, source);
        var map = try parser.parse();
        defer map.deinit();

        try std.testing.expectEqual(@as(usize, 2), map.count());
        try std.testing.expectEqualStrings("value", map.get("key").?);
        try std.testing.expectEqualStrings("value2", map.get("key2").?);
    }

    test "parse array" {
        const source = "tags: [tag1, tag2, tag3]\n";
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var parser = Parser.init(allocator, source);
        var map = try parser.parse();
        defer map.deinit();

        try std.testing.expectEqual(@as(usize, 1), map.count());
        const value = map.get("tags").?;
        try std.testing.expectEqualStrings("tag1,tag2,tag3", value);
    }
};