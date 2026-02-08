# Alias for `just -l`
default:
    @just -l

fmt:
    @zig fmt .
 
run:
    @zig build run

