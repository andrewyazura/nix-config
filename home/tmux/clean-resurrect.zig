const std = @import("std");
const mem = std.mem;

const targets = std.StaticStringMap([]const u8).initComptime(.{
    .{ "nvim",            ":nvim" },
    .{ "lazygit",         ":lazygit" },
});

const nix_shell_prefix = ":bash --rcfile /private/tmp/nix-shell";

pub fn main(init: std.process.Init) !void {
    const alloc = std.heap.smp_allocator;
    const io = init.io;

    const resurrect_path = init.environ_map.get("TMUX_RESURRECT_FILE") orelse {
        std.log.err("Fatal: TMUX_RESURRECT_FILE environment variable is missing", .{});
        std.process.exit(1);
    };

    const cwd = std.Io.Dir.cwd();

    const resurrect_save_buffer = try cwd.readFileAlloc(io, resurrect_path, alloc, .limited(1024 * 1024));
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
        var col_iter = mem.splitScalar(u8, line, '\t');
        for (&columns) |*c| {
            c.* = col_iter.next() orelse break;
        }

        const replacement: []const u8 =
            if (targets.get(columns[9])) |cmd| cmd
            else if (mem.startsWith(u8, columns[10], nix_shell_prefix)) ":"
            else "";

        if (replacement.len > 0) {
            for (columns[0..10]) |col| {
                try tmp_file.writeStreamingAll(io, col);
                try tmp_file.writeStreamingAll(io, "\t");
            }
            try tmp_file.writeStreamingAll(io, replacement);
            try tmp_file.writeStreamingAll(io, "\n");
        } else {
            try tmp_file.writeStreamingAll(io, line);
            try tmp_file.writeStreamingAll(io, "\n");
        }
    }

    try std.Io.Dir.renameAbsolute(tmp_path, resurrect_path, io);
}
