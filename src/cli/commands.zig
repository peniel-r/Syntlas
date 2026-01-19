const std = @import("std");
const mod = @import("mod.zig");
const help = @import("help.zig");
const text = @import("../output/text.zig");
const json = @import("../output/json.zig");
const output_mod = @import("../output/mod.zig");
const search_mod = @import("../search/mod.zig");
const engine_mod = @import("../search/engine.zig");
const config_mod = @import("../config/mod.zig");
const tome_mod = @import("../tome/mod.zig");
const schema = @import("../core/schema.zig");

const CliConfig = mod.CliConfig;
const Command = mod.Command;
const CommandArgs = mod.CommandArgs;
const SearchArgs = mod.SearchArgs;
const DocsArgs = mod.DocsArgs;
const SnippetArgs = mod.SnippetArgs;
const InstallArgs = mod.InstallArgs;
const ListArgs = mod.ListArgs;
const CreateTomeArgs = mod.CreateTomeArgs;
const ValidateTomeArgs = mod.ValidateTomeArgs;
const OutputConfig = output_mod.OutputConfig;

pub fn runCommand(
    allocator: std.mem.Allocator,
    command: Command,
    args: CommandArgs,
    cli_config: CliConfig,
) !void {
    const output_config = OutputConfig{
        .use_color = cli_config.color_output,
        .theme = cli_config.theme,
        .formatter = if (cli_config.json_output) .json else .text,
    };
    
    switch (command) {
        .search => try runSearch(allocator, args.search, cli_config, output_config),
        .docs => try runDocs(allocator, args.docs, cli_config, output_config),
        .snippet => try runSnippet(allocator, args.snippet, cli_config, output_config),
        .install => try runInstall(allocator, args.install, cli_config, output_config),
        .list => try runList(allocator, args.list, cli_config, output_config),
        .@"create-tome" => try runCreateTome(allocator, args.@"create-tome", cli_config, output_config),
        .@"validate-tome" => try runValidateTome(allocator, args.@"validate-tome", cli_config, output_config),
        .help => try runHelp(allocator, args.help, cli_config),
    }
}

fn runSearch(
    allocator: std.mem.Allocator,
    args: SearchArgs,
    _: CliConfig,
    output_config: OutputConfig,
) !void {
    // Load tomes
    var tome_loader = tome_mod.loader.TomeLoader.init(allocator);
    defer tome_loader.deinit();
    
    try tome_loader.loadAllEmbeddedTomes("tomes/embedded");
    const neuronas = tome_loader.getNeuronas();
    const contents = tome_loader.getContents();
    
    // Build indices
    var builder = @import("../index/builder.zig").IndexBuilder.init(allocator);
    defer builder.deinit();
    _ = try builder.buildFromCollection(neuronas, contents);
    
    // Create search engine
    var engine = engine_mod.SearchEngine.init(
        allocator,
        &builder.inverted_index,
        &builder.graph_index,
        &builder.metadata_index,
        &builder.use_case_index,
    );
    
    // Parse context
    var context = engine_mod.SearchContext{};
    if (args.difficulty) |diff| {
        if (std.mem.eql(u8, diff, "novice")) context.difficulty = .novice;
        if (std.mem.eql(u8, diff, "intermediate")) context.difficulty = .intermediate;
        if (std.mem.eql(u8, diff, "advanced")) context.difficulty = .advanced;
        if (std.mem.eql(u8, diff, "expert")) context.difficulty = .expert;
    }
    
    // Perform search
    const start_time = std.time.nanoTimestamp();
    const results = try engine.search(args.query, context, .{});
    const end_time = std.time.nanoTimestamp();
    const query_time_ms = @as(f64, @floatFromInt(end_time - start_time)) / 1_000_000.0;
    
    defer allocator.free(results);
    
    // Limit results
    const limited_results = if (args.limit < results.len) results[0..args.limit] else results;
    
    // Format and output
    const output = switch (output_config.formatter) {
        .text => try text.formatSearchResults(allocator, limited_results, args.query, query_time_ms, output_config),
        .json => try json.formatSearchResults(allocator, limited_results, query_time_ms),
    };
    defer allocator.free(output);
    
    std.debug.print("{s}", .{output});
}

fn runDocs(
    allocator: std.mem.Allocator,
    args: DocsArgs,
    _: CliConfig,
    output_config: OutputConfig,
) !void {
    // Load tomes
    var tome_loader = tome_mod.loader.TomeLoader.init(allocator);
    defer tome_loader.deinit();
    
    try tome_loader.loadAllEmbeddedTomes("tomes/embedded");
    const neuronas = tome_loader.getNeuronas();
    const contents = tome_loader.getContents();
    
    // Find neurona
    var found_neurona: ?*const schema.Neurona = null;
    var found_content: ?[]const u8 = null;
    
    for (neuronas, 0..) |*neurona, i| {
        if (std.mem.eql(u8, neurona.id, args.neurona_id)) {
            found_neurona = neurona;
            found_content = contents[i];
            break;
        }
    }
    
    if (found_neurona == null or found_content == null) {
        const error_output = switch (output_config.formatter) {
            .text => try text.formatError(allocator, "Neurona not found", output_config),
            .json => try json.formatError(allocator, "Neurona not found"),
        };
        defer allocator.free(error_output);
        std.debug.print("{s}", .{error_output});
        return error.NeuronaNotFound;
    }
    
    // Format and output
    const output = switch (output_config.formatter) {
        .text => try text.formatNeurona(allocator, found_neurona.?, found_content.?, output_config),
        .json => try json.formatNeurona(allocator, found_neurona.?, found_content.?),
    };
    defer allocator.free(output);
    
    std.debug.print("{s}", .{output});
}

fn runSnippet(
    allocator: std.mem.Allocator,
    args: SnippetArgs,
    _: CliConfig,
    output_config: OutputConfig,
) !void {
    // Load tomes
    var tome_loader = tome_mod.loader.TomeLoader.init(allocator);
    defer tome_loader.deinit();
    
    try tome_loader.loadAllEmbeddedTomes("tomes/embedded");
    const neuronas = tome_loader.getNeuronas();
    const contents = tome_loader.getContents();
    
    // Find neurona
    var found_neurona: ?*const schema.Neurona = null;
    var found_content: ?[]const u8 = null;
    
    for (neuronas, 0..) |*neurona, i| {
        if (std.mem.eql(u8, neurona.id, args.neurona_id)) {
            found_neurona = neurona;
            found_content = contents[i];
            break;
        }
    }
    
    if (found_neurona == null or found_content == null) {
        const error_output = switch (output_config.formatter) {
            .text => try text.formatError(allocator, "Neurona not found", output_config),
            .json => try json.formatError(allocator, "Neurona not found"),
        };
        defer allocator.free(error_output);
        std.debug.print("{s}", .{error_output});
        return error.NeuronaNotFound;
    }
    
    // Format and output
    const output = try text.formatSnippet(allocator, found_neurona.?, found_content.?, output_config);
    defer allocator.free(output);
    
    std.debug.print("{s}", .{output});
}

fn runInstall(
    allocator: std.mem.Allocator,
    args: InstallArgs,
    cli_config: CliConfig,
    output_config: OutputConfig,
) !void {
    // Load config
    const cfg = try config_mod.manager.load(allocator);
    defer cfg.deinit(allocator);
    
    // Check if it's a URL, Git repo, or local path
    const is_url = std.mem.indexOf(u8, args.source, "http://") != null or 
                   std.mem.indexOf(u8, args.source, "https://") != null;
    const is_git = std.mem.endsWith(u8, args.source, ".git");
    
    if (is_url or is_git) {
        const output = switch (output_config.formatter) {
            .text => try text.formatError(allocator, "Remote installation not yet implemented", output_config),
            .json => try json.formatError(allocator, "Remote installation not yet implemented"),
        };
        defer allocator.free(output);
        std.debug.print("{s}", .{output});
        return error.NotImplemented;
    }
    
    // Local installation
    std.debug.print("Installing tome from: {s}\n", .{args.source});
    
    // Validate tome
    const validation_result = try tome_mod.validator.validateTome(allocator, args.source);
    
    if (!validation_result.valid) {
        const error_output = switch (output_config.formatter) {
            .text => try text.formatError(allocator, "Tome validation failed", output_config),
            .json => try json.formatError(allocator, "Tome validation failed"),
        };
        defer allocator.free(error_output);
        std.debug.print("{s}", .{error_output});
        
        if (cli_config.debug_mode) {
            std.debug.print("Validation errors:\n", .{});
            for (validation_result.errors) |err| {
                std.debug.print("  - {s}: {s}\n", .{err.file_path, err.message});
            }
        }
        
        return error.ValidationFailed;
    }
    
    // Copy tome to tomes directory
    const tome_name = std.fs.path.basename(args.source);
    const dest_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ cfg.tomes_path, tome_name });
    defer allocator.free(dest_path);
    
    try std.fs.cwd().makePath(dest_path);
    
    var src_dir = try std.fs.cwd().openDir(args.source, .{});
    defer src_dir.close();
    
    var dest_dir = try std.fs.cwd().openDir(dest_path, .{});
    defer dest_dir.close();
    
    try copyDirRecursive(allocator, src_dir, dest_dir, args.source, dest_path);
    
    const success_output = switch (output_config.formatter) {
        .text => try text.formatSuccess(allocator, "Tome installed successfully", output_config),
        .json => try json.formatSuccess(allocator, "Tome installed successfully"),
    };
    defer allocator.free(success_output);
    std.debug.print("{s}", .{success_output});
}

fn runList(
    allocator: std.mem.Allocator,
    args: ListArgs,
    _: CliConfig,
    output_config: OutputConfig,
) !void {
    if (args.tomes or (args.tome_name == null and !args.neuronas)) {
        // List tomes (both installed and embedded)
        const installed_tomes = try tome_mod.installer.listInstalled(allocator);
        defer {
            for (installed_tomes) |*t| t.deinit(allocator);
            allocator.free(installed_tomes);
        }
        
        var tome_names = std.ArrayList([]const u8){};
        try tome_names.ensureTotalCapacity(allocator, installed_tomes.len + 10); // Space for installed + some embedded
        defer {
            for (tome_names.items) |item| allocator.free(item);
            tome_names.deinit(allocator);
        }
        
        // Add installed tomes
        for (installed_tomes) |tome| {
            try tome_names.append(allocator, try allocator.dupe(u8, tome.name));
        }
        
        // Add embedded tomes
        var embedded_dir = try std.fs.cwd().openDir("tomes/embedded", .{ .iterate = true });
        defer embedded_dir.close();
        
        var iter = embedded_dir.iterate();
        while (try iter.next()) |entry| {
            if (entry.kind == .directory) {
                // Check if already in list (avoid duplicates)
                var found = false;
                for (tome_names.items) |existing| {
                    if (std.mem.eql(u8, existing, entry.name)) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    try tome_names.append(allocator, try allocator.dupe(u8, entry.name));
                }
            }
        }
        
        const output = switch (output_config.formatter) {
            .text => try text.formatTomeList(allocator, tome_names.items, output_config),
            .json => try json.formatTomeList(allocator, tome_names.items),
        };
        defer allocator.free(output);
        std.debug.print("{s}", .{output});
    } else {
        // List neuronas
        const tome_name = args.tome_name orelse "c";
        
        // Load tomes
        var tome_loader = tome_mod.loader.TomeLoader.init(allocator);
        defer tome_loader.deinit();
        
        try tome_loader.loadAllEmbeddedTomes("tomes/embedded");
        const neuronas = tome_loader.getNeuronas();
        
        var filtered_neuronas = std.ArrayList([]const u8){};
        defer filtered_neuronas.deinit(allocator);
        
        for (neuronas) |*neurona| {
            if (std.mem.startsWith(u8, neurona.id, tome_name)) {
                try filtered_neuronas.append(allocator, neurona.id);
            }
        }
        
        const output = switch (output_config.formatter) {
            .text => try text.formatNeuronaList(allocator, filtered_neuronas.items, tome_name, output_config),
            .json => try json.formatTomeList(allocator, filtered_neuronas.items),
        };
        defer allocator.free(output);
        std.debug.print("{s}", .{output});
    }
}

fn runCreateTome(
    allocator: std.mem.Allocator,
    args: CreateTomeArgs,
    _: CliConfig,
    output_config: OutputConfig,
) !void {
    const base_path = args.path orelse ".";
    const tome_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ base_path, args.name });
    defer allocator.free(tome_path);
    
    // Create directory structure
    try std.fs.cwd().makePath(tome_path);
    try std.fs.cwd().makePath(try std.fmt.allocPrint(allocator, "{s}/neuronas", .{tome_path}));
    try std.fs.cwd().makePath(try std.fmt.allocPrint(allocator, "{s}/assets", .{tome_path}));
    
    // Create tome.json
    const tome_json = 
        \\{{
        \\  "name": "{s}",
        \\  "version": "0.1.0",
        \\  "author": "Your Name",
        \\  "license": "MIT",
        \\  "description": "A description of your tome",
        \\  "languages": [],
        \\  "dependencies": [],
        \\  "min_syntlas_version": "0.1.0"
        \\}}
    ;
    
    const formatted_json = try std.fmt.allocPrint(allocator, tome_json, .{args.name});
    defer allocator.free(formatted_json);
    
    const tome_json_path = try std.fmt.allocPrint(allocator, "{s}/tome.json", .{tome_path});
    defer allocator.free(tome_json_path);
    
    const json_file = try std.fs.cwd().createFile(tome_json_path, .{});
    defer json_file.close();
    try json_file.writeAll(formatted_json);
    
    // Create README.md
    const readme_path = try std.fmt.allocPrint(allocator, "{s}/README.md", .{tome_path});
    defer allocator.free(readme_path);
    
    const readme_file = try std.fs.cwd().createFile(readme_path, .{});
    defer readme_file.close();
    try readme_file.writeAll(
        \\# {s} Tome
        \\
        \\Description of your tome here.
        \\
        \\## Structure
        \\
        \\- `tome.json`: Tome metadata
        \\- `neuronas/`: Neurona markdown files
        \\- `assets/`: Images, diagrams, etc.
    );
    
    const success_output = switch (output_config.formatter) {
        .text => try text.formatSuccess(allocator, "Tome structure created successfully", output_config),
        .json => try json.formatSuccess(allocator, "Tome structure created successfully"),
    };
    defer allocator.free(success_output);
    std.debug.print("{s}", .{success_output});
}

fn runValidateTome(
    allocator: std.mem.Allocator,
    args: ValidateTomeArgs,
    cli_config: CliConfig,
    output_config: OutputConfig,
) !void {
    const validation_result = try tome_mod.validator.validateTome(allocator, args.path);
    
    if (validation_result.valid) {
        const success_output = switch (output_config.formatter) {
            .text => try text.formatSuccess(allocator, "Tome validation passed", output_config),
            .json => try json.formatSuccess(allocator, "Tome validation passed"),
        };
        defer allocator.free(success_output);
        std.debug.print("{s}", .{success_output});
    } else {
        const error_output = switch (output_config.formatter) {
            .text => try text.formatError(allocator, "Tome validation failed", output_config),
            .json => try json.formatError(allocator, "Tome validation failed"),
        };
        defer allocator.free(error_output);
        std.debug.print("{s}", .{error_output});
        
        if (cli_config.debug_mode) {
            std.debug.print("\nValidation errors:\n", .{});
            for (validation_result.errors) |err| {
                std.debug.print("  - {s}: {s}\n", .{err.file_path, err.message});
            }
        }
        
        return error.ValidationFailed;
    }
}

pub fn runHelp(
    allocator: std.mem.Allocator,
    args: mod.HelpArgs,
    cli_config: CliConfig,
) !void {
    if (args.command) |cmd| {
        if (std.mem.eql(u8, cmd, "search")) {
            try help.printCommandHelp(allocator, .search, cli_config);
        } else if (std.mem.eql(u8, cmd, "docs")) {
            try help.printCommandHelp(allocator, .docs, cli_config);
        } else if (std.mem.eql(u8, cmd, "snippet")) {
            try help.printCommandHelp(allocator, .snippet, cli_config);
        } else if (std.mem.eql(u8, cmd, "install")) {
            try help.printCommandHelp(allocator, .install, cli_config);
        } else if (std.mem.eql(u8, cmd, "list")) {
            try help.printCommandHelp(allocator, .list, cli_config);
        } else if (std.mem.eql(u8, cmd, "create-tome")) {
            try help.printCommandHelp(allocator, .@"create-tome", cli_config);
        } else if (std.mem.eql(u8, cmd, "validate-tome")) {
            try help.printCommandHelp(allocator, .@"validate-tome", cli_config);
        } else {
            try help.printGeneralHelp(allocator, cli_config);
        }
    } else {
        try help.printGeneralHelp(allocator, cli_config);
    }
}

fn copyDirRecursive(
    allocator: std.mem.Allocator,
    src_dir: std.fs.Dir,
    dest_dir: std.fs.Dir,
    src_base: []const u8,
    dest_base: []const u8,
) !void {
    var iter = src_dir.iterate();
    
    while (try iter.next()) |entry| {
        const src_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ src_base, entry.name });
        defer allocator.free(src_path);
        
        const dest_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ dest_base, entry.name });
        defer allocator.free(dest_path);
        
        if (entry.kind == .directory) {
            try dest_dir.makePath(entry.name);
            var sub_src = try src_dir.openDir(entry.name, .{});
            defer sub_src.close();
            
            var sub_dest = try dest_dir.openDir(entry.name, .{});
            defer sub_dest.close();
            
            try copyDirRecursive(allocator, sub_src, sub_dest, src_path, dest_path);
        } else {
            try std.fs.cwd().copyFile(src_path, std.fs.cwd(), dest_path, .{});
        }
    }
}

const Error = error{
    NeuronaNotFound,
    NotImplemented,
    ValidationFailed,
};