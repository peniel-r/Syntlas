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
            '"', '\'' => return self.string(),
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
            const char = self.source[self.index];
            switch (char) {
                ' ', '\t', '\r' => self.advance(),
                '\n' => {
                    self.advance();
                },
                '#' => {
                    var i: usize = self.index;
                    var is_start_of_line = true;
                    while (i > 0) {
                        i -= 1;
                        const prev = self.source[i];
                        if (prev == '\n') break;
                        if (prev != ' ' and prev != '\t' and prev != '\r') {
                            is_start_of_line = false;
                            break;
                        }
                    }
                    if (self.index == 0) is_start_of_line = true;

                    if (is_start_of_line) {
                        while (self.index < self.source.len and self.source[self.index] != '\n') {
                            self.advance();
                        }
                    } else {
                        return;
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
        const quote = self.source[self.index];
        self.advance();
        while (self.index < self.source.len and self.source[self.index] != quote) {
            self.advance();
        }
        if (self.index < self.source.len) self.advance();
        const value = self.source[start + 1 .. self.index - 1];
        return self.makeToken(.string, value);
    }

    fn identifierOrNumber(self: *Tokenizer) Token {
        const start = self.index;
        while (self.index < self.source.len) {
            const c = self.source[self.index];
            if (c == ',' or c == '[' or c == ']' or c == '{' or c == '}') break;
            if (c == ':') {
                if (self.index + 1 >= self.source.len or
                    self.source[self.index + 1] == ' ' or
                    self.source[self.index + 1] == '\t' or
                    self.source[self.index + 1] == '\n' or
                    self.source[self.index + 1] == '\r')
                {
                    break;
                }
            }
            if (c == '\n' or c == '\r') break;
            self.advance();
        }
        if (self.index == start) {
            self.advance();
            return self.makeToken(.unknown, self.source[start..self.index]);
        }
        const raw_value = self.source[start..self.index];
        const trimmed = std.mem.trim(u8, raw_value, " \t");
        return self.makeToken(.string, trimmed);
    }
};

pub const Parser = struct {
    allocator: std.mem.Allocator,
    tokenizer: Tokenizer,
    current: Token,

    const MAX_DEPTH = 10;
    const MAX_SIZE = 1024 * 1024;

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

    fn expect(self: *Parser, tag: TokenType) !Token {
        if (self.current.tag == tag) {
            const token = self.current;
            self.advance();
            return token;
        }
        return error.UnexpectedToken;
    }

    fn parseArray(self: *Parser, depth: usize) ![][]const u8 {
        if (depth > MAX_DEPTH) return error.YamlDepthExceeded;
        var list = std.ArrayListUnmanaged([]const u8){};
        errdefer list.deinit(self.allocator);

        _ = try self.expect(.l_bracket);

        while (self.current.tag != .r_bracket and self.current.tag != .eof) {
            if (self.current.tag == .string) {
                const val_token = try self.expect(.string);
                try list.append(self.allocator, val_token.value);
            } else if (self.current.tag == .l_bracket) {
                const nested = try self.parseArray(depth + 1);
                self.allocator.free(nested);
            } else if (self.current.tag == .l_brace) {
                try self.skipToMatch(.l_brace, .r_brace);
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

    fn skipToMatch(self: *Parser, open: TokenType, close: TokenType) !void {
        var stack: usize = 1;
        self.advance();
        while (stack > 0 and self.current.tag != .eof) {
            if (self.current.tag == open) stack += 1;
            if (self.current.tag == close) stack -= 1;
            self.advance();
        }
    }

    pub fn parse(self: *Parser) !std.StringHashMap([]const u8) {
        if (self.tokenizer.source.len > MAX_SIZE) return error.YamlSizeExceeded;
        var map = std.StringHashMap([]const u8).init(self.allocator);
        errdefer map.deinit();

        while (self.current.tag != .eof) {
            if (self.current.tag != .string) {
                self.advance();
                continue;
            }

            const key_token = self.current;
            self.advance();

            if (self.current.tag != .colon) {
                continue;
            }
            self.advance();

            if (self.current.tag == .string) {
                const val_token = try self.expect(.string);
                // Allocate the value so all map values are consistently owned
                try map.put(key_token.value, try self.allocator.dupe(u8, val_token.value));
            } else if (self.current.tag == .l_bracket) {
                var array_list = std.ArrayListUnmanaged(u8){};
                defer array_list.deinit(self.allocator);

                const array = try self.parseArray(0);
                for (array, 0..) |item, i| {
                    if (i > 0) try array_list.append(self.allocator, ',');
                    try array_list.appendSlice(self.allocator, item);
                }
                self.allocator.free(array);
                try map.put(key_token.value, try array_list.toOwnedSlice(self.allocator));
            } else if (self.current.tag == .hyphen) {
                var array_list = std.ArrayListUnmanaged(u8){};
                defer array_list.deinit(self.allocator);
                var count: usize = 0;

                while (self.current.tag == .hyphen) {
                    self.advance();

                    if (self.current.tag == .string) {
                        const val = self.current.value;
                        self.advance();

                        if (self.current.tag == .colon) {
                            if (std.mem.eql(u8, val, "id")) {
                                self.advance();
                                if (self.current.tag == .string) {
                                    if (count > 0) try array_list.append(self.allocator, ',');
                                    try array_list.appendSlice(self.allocator, self.current.value);
                                    count += 1;
                                    self.advance();
                                }
                            }
                            // Skip the rest of this map until next hyphen
                            while (self.current.tag != .hyphen and self.current.tag != .eof) {
                                // If we've reached what looks like another key (at a different level or after map)?
                                // We don't have level info.
                                // But if it's NOT a hyphen and the next hyphen is missing, we might be at a new key.
                                // This is okay for our simple flat-schema requirement.
                                // We'll just break if we see a string NOT followed by colon?
                                // No, strings followed by colon are map keys.
                                // Let's just consume until hyphen.
                                // BUT we must not consume the NEXT key of the root map.
                                // Root map keys are at start of line (column 1).
                                // We don't track column in Token perfectly yet but it exists.
                                if (self.tokenizer.column == 1) break;
                                self.advance();
                            }
                        } else {
                            if (count > 0) try array_list.append(self.allocator, ',');
                            try array_list.appendSlice(self.allocator, val);
                            count += 1;
                        }
                    } else {
                        self.advance();
                    }
                }
                try map.put(key_token.value, try array_list.toOwnedSlice(self.allocator));
            } else {
                self.advance();
            }
        }

        return map;
    }
};
