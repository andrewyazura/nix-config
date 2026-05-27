const std = @import("std");
const mem = std.mem;
const targets = [_][]const u8{ "nvim", "lazygit", "gemini", "claude" };

pub fn main(init: std.process.Init) !void {
    const alloc = std.heap.smp_allocator;
    const io = init.io;

    const resurrect_path = init.environ_map.get("TMUX_RESURRECT_FILE") orelse {
        std.log.err("Fatal: TMUX_RESURRECT_FILE environment variable is missing", .{});
        std.process.exit(1);
    };

    const cwd = std.Io.Dir.cwd();

    const limit = 1024 * 1024;
    const resurrect_save_buffer = try cwd.readFileAlloc(io, resurrect_path, alloc, .limited(limit));
    defer alloc.free(resurrect_save_buffer);

    const tmp_path = try mem.concat(alloc, u8, &.{ resurrect_path, ".tmp" });
    defer alloc.free(tmp_path);

    const tmp_file = try cwd.createFile(io, tmp_path, .{});
    defer tmp_file.close(io);

    var lines = mem.splitScalar(u8, resurrect_save_buffer, '\n');
    while (lines.next()) |line| {
        if (!mem.startsWith(u8, line, "pane")) {
            try tmp_file.writeStreamingAll(io, line);
            try tmp_file.writeStreamingAll(io, "\n");
            continue;
        }

        var columns: [11][]const u8 = undefined;
        var iterator = mem.splitScalar(u8, line, '\t');
        for (&columns) |*c| {
            c.* = iterator.next() orelse break;
        }

        std.debug.print("{s}\n", .{columns[9]});
        std.debug.print("{s}\n\n", .{columns[10]});

        try tmp_file.writeStreamingAll(io, line);
        try tmp_file.writeStreamingAll(io, "\n");
        continue;
    }

    try std.Io.Dir.renameAbsolute(tmp_path, resurrect_path, io);
}
