const std = @import("std");

const rng = std.crypto.random;

pub fn main() !void {
    var stdin_buf: [512]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);
    const stdin = &stdin_reader.interface;

    var stdout_buf: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_writer.interface;

    try stdout.print("{s}DEPTH CHARGE\n", .{spaces(30)});
    try stdout.print("{s}CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY\n", .{spaces(15)});
    try stdout.print("\n\n\n", .{});
    try stdout.print("DIMENSION OF SEARCH AREA: ", .{});
    try stdout.flush();

    const dimension = try inputInteger(stdin);
    const shots = std.math.log2_int(usize, dimension) + 1;

    const mission =
        \\
        \\
        \\YOU ARE THE CAPTAIN OF THE DESTROYER USS COMPUTER.
        \\AN ENEMY SUB HAS BEEN CAUSING YOU TROUBLE.  YOUR
        \\MISSION IS TO DESTROY IT.  YOU HAVE {} SHOTS.
        \\SPECIFY DEPTH CHARGE EXPLOSION POINT WITH A
        \\TRIO OF NUMBERS -- THE FIRST TWO ARE THE
        \\SURFACE COORDINATES; THE THIRD IS THE DEPTH.
        \\
        \\
    ;

    try stdout.print(mission, .{shots});

    var play_again = true;

    while (play_again) {
        try stdout.print("GOOD LUCK !\n\n", .{});
        try stdout.flush();

        const sub_lattitude = rng.intRangeAtMost(usize, 0, dimension);
        const sub_longitude = rng.intRangeAtMost(usize, 0, dimension);
        const sub_depth = rng.intRangeAtMost(usize, 0, dimension);

        var found_in_tries: usize = 0;

        for (1..(shots + 1)) |shot| {
            try stdout.print("\nTRIAL #{}\n", .{shot});
            try stdout.flush();

            const input_line = try inputString(stdin);

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

            try stdout.print("SONAR REPORTS SHOT WAS ", .{});

            if (lattitude > sub_lattitude) {
                try stdout.print("NORTH", .{});
            } else if (lattitude < sub_lattitude) {
                try stdout.print("SOUTH", .{});
            }

            if (longitude > sub_longitude) {
                try stdout.print("EAST", .{});
            } else if (longitude < sub_longitude) {
                try stdout.print("WEST", .{});
            }

            if ((lattitude != sub_lattitude) or (longitude != sub_longitude)) {
                try stdout.print(" AND", .{});
            }

            if (depth > sub_depth) {
                try stdout.print(" TOO LOW.\n", .{});
            } else if (depth < sub_depth) {
                try stdout.print(" TOO HIGH.\n", .{});
            } else {
                try stdout.print(" DEPTH OK.\n", .{});
            }
        }

        if (found_in_tries > 0) {
            try stdout.print("\nB O O M ! ! YOU FOUND IT IN {} TRIES!\n", .{found_in_tries});
        } else {
            try stdout.print("\nYOU HAVE BEEN TORPEDOED!  ABANDON SHIP!\n", .{});
            try stdout.print("THE SUBMARINE WAS AT {} {} {}\n", .{ sub_lattitude, sub_longitude, sub_depth });
        }

        try stdout.print("\nANOTHER GAME (Y OR N) ", .{});
        try stdout.flush();

        const another = try inputString(stdin);

        play_again = std.mem.eql(u8, another, "Y");
    }

    try stdout.print("\nOK.  HOPE YOU ENJOYED YOURSELF.\n", .{});
    try stdout.flush();
}

fn inputString(reader: *std.io.Reader) ![]const u8 {
    const line = (try reader.takeDelimiter('\n')) orelse "";
    const trimmed = std.mem.trim(u8, line, " ");

    return trimmed;
}

fn inputInteger(reader: *std.io.Reader) !usize {
    const input = try inputString(reader);
    const value = try std.fmt.parseInt(usize, input, 10);

    return value;
}

fn repeatChar(c: u8, comptime count: usize) [count]u8 {
    const repeated: [count]u8 = @splat(c);

    return repeated;
}

fn spaces(comptime count: usize) [count]u8 {
    return repeatChar(' ', count);
}
