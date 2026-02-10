const std = @import("std");

const rng = std.crypto.random;

pub fn main() !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    const allocator = debug_allocator.allocator();

    defer {
        _ = debug_allocator.deinit();
    }

    var stdout_buf: [512]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(stdout_buf[0..]);

    const pad_15 = try spaces(allocator, 15);

    try stdout.interface.print("{s}{s}DEPTH CHARGE\n", .{ pad_15, pad_15 });
    try stdout.interface.print("{s}CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY\n", .{pad_15});
    try stdout.interface.print("\n\n\n", .{});
    try stdout.interface.print("DIMENSION OF SEARCH AREA: ", .{});
    try stdout.interface.flush();

    allocator.free(pad_15);

    const dimension = try inputInteger(allocator);
    try stdout.interface.print("\n", .{});

    const shots = std.math.log2_int(usize, dimension) + 1;

    try stdout.interface.print("\nYOU ARE THE CAPTAIN OF THE DESTROYER USS COMPUTER.\n", .{});
    try stdout.interface.print("AN ENEMY SUB HAS BEEN CAUSING YOU TROUBLE.  YOUR\n", .{});
    try stdout.interface.print("MISSION IS TO DESTROY IT.  YOU HAVE {} SHOTS.\n", .{shots});
    try stdout.interface.print("SPECIFY DEPTH CHARGE EXPLOSION POINT WITH A\n", .{});
    try stdout.interface.print("TRIO OF NUMBERS -- THE FIRST TWO ARE THE\n", .{});
    try stdout.interface.print("SURFACE COORDINATES; THE THIRD IS THE DEPTH.\n\n", .{});

    var play_again = true;

    while (play_again) {
        try stdout.interface.print("GOOD LUCK !\n\n", .{});
        try stdout.interface.flush();

        const sub_lattitude = rng.intRangeAtMost(usize, 0, dimension);
        const sub_longitude = rng.intRangeAtMost(usize, 0, dimension);
        const sub_depth = rng.intRangeAtMost(usize, 0, dimension);

        var found_in_tries: usize = 0;

        for (1..(shots + 1)) |shot| {
            try stdout.interface.print("\nTRIAL #{}\n", .{shot});
            try stdout.interface.flush();

            const input_line = try inputString(allocator);
            defer allocator.free(input_line);

            var iterator = std.mem.splitScalar(u8, input_line, ' ');

            const latt_text = iterator.next().?;
            const long_text = iterator.next().?;
            const deep_text = iterator.next().?;

            const lattitude = try std.fmt.parseInt(usize, latt_text, 10);
            const longitude = try std.fmt.parseInt(usize, long_text, 10);
            const depth = try std.fmt.parseInt(usize, deep_text, 10);

            if (longitude == sub_longitude and lattitude == sub_lattitude and depth == sub_depth) {
                found_in_tries = shot;
                break;
            }

            try stdout.interface.print("SONAR REPORTS SHOT WAS ", .{});

            if (lattitude > sub_lattitude) {
                try stdout.interface.print("NORTH", .{});
            } else if (lattitude < sub_lattitude) {
                try stdout.interface.print("SOUTH", .{});
            }

            if (longitude > sub_longitude) {
                try stdout.interface.print("EAST", .{});
            } else if (longitude < sub_longitude) {
                try stdout.interface.print("WEST", .{});
            }

            if ((lattitude != sub_lattitude) or (longitude != sub_longitude)) {
                try stdout.interface.print(" AND", .{});
            }

            if (depth > sub_depth) {
                try stdout.interface.print(" TOO LOW.\n", .{});
            } else if (depth < sub_depth) {
                try stdout.interface.print(" TOO HIGH.\n", .{});
            } else {
                try stdout.interface.print(" DEPTH OK.\n", .{});
            }
        }

        if (found_in_tries > 0) {
            try stdout.interface.print("\nB O O M ! ! YOU FOUND IT IN {} TRIES!\n", .{found_in_tries});
        } else {
            try stdout.interface.print("\nYOU HAVE BEEN TORPEDOED!  ABANDON SHIP!\n", .{});
            try stdout.interface.print("THE SUBMARINE WAS AT {} {} {}\n", .{ sub_lattitude, sub_longitude, sub_depth });
        }

        try stdout.interface.print("\nANOTHER GAME (Y OR N) ", .{});
        try stdout.interface.flush();

        const another = try inputString(allocator);
        defer allocator.free(another);

        play_again = std.mem.eql(u8, another, "Y");
    }

    try stdout.interface.print("\nOK.  HOPE YOU ENJOYED YOURSELF.\n", .{});
    try stdout.interface.flush();
}

fn inputString(allocator: std.mem.Allocator) ![]u8 {
    var buf: [64]u8 = undefined;

    const bytes_read = try std.fs.File.stdin().read(buf[0..]);
    const newline_index = std.mem.indexOf(u8, buf[0..bytes_read], "\n") orelse bytes_read;
    const trimmed = std.mem.trim(u8, buf[0..newline_index], " \n");
    const out = try allocator.alloc(u8, trimmed.len);

    std.mem.copyForwards(u8, out, trimmed);

    return out;
}

fn inputInteger(allocator: std.mem.Allocator) !usize {
    const input = try inputString(allocator);
    const value = try std.fmt.parseInt(usize, input, 10);

    allocator.free(input);

    return value;
}

fn repeatChar(allocator: std.mem.Allocator, c: u8, count: usize) ![]u8 {
    const buf = try allocator.alloc(u8, count);

    @memset(buf, c);

    return buf;
}

fn spaces(allocator: std.mem.Allocator, count: usize) ![]u8 {
    return repeatChar(allocator, ' ', count);
}
