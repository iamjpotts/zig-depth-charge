
A translation of the terminal game `Depth Charge` from `BASIC` to `zig`
version `0.15`. The original game is from the book `Basic Computer Games`.

This was a learning exercise for learning `zig.`

# Game Guide

You choose the size of your three-dimensional search space. Each axis
is the same size. The game will compute the maximum number of attempts
you are allowed based on the size of the search space.

The original text and prompts of the game are preserved, but are unclear.

You enter three coordinates:

* Coordinate 1 - lattitude (north vs south; higher values are farther _north_)
* Coordinate 2 - longitude (east vs west; higher values are farther _east_)
* Coordinate 3 - depth (higher values are _deeper_; but `too high` means too _shallow_)

A winning strategy is a binary search.

# Running The Game

1. Download and install [zig](https://ziglang.org/download/) 0.15
2. Clone this repository
3. `zig build run`

# Implementation

Similar to the original, the implementation is unforgiving; not all possible
user inputs are handled gracefully. For example, if you enter text instead
of a number, your warship crashes on the rocks because the game crashed.

# Example Output

```text
                              DEPTH CHARGE
               CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY



DIMENSION OF SEARCH AREA: 100


YOU ARE THE CAPTAIN OF THE DESTROYER USS COMPUTER.
AN ENEMY SUB HAS BEEN CAUSING YOU TROUBLE.  YOUR
MISSION IS TO DESTROY IT.  YOU HAVE 7 SHOTS.
SPECIFY DEPTH CHARGE EXPLOSION POINT WITH A
TRIO OF NUMBERS -- THE FIRST TWO ARE THE
SURFACE COORDINATES; THE THIRD IS THE DEPTH.

GOOD LUCK !


TRIAL #1
50 50 50
SONAR REPORTS SHOT WAS NORTHWEST AND TOO LOW.

TRIAL #2
25 75 25
SONAR REPORTS SHOT WAS NORTHWEST AND TOO HIGH.

TRIAL #3
12 82 32
SONAR REPORTS SHOT WAS NORTHWEST AND TOO LOW.

TRIAL #4
6 91 28
SONAR REPORTS SHOT WAS NORTH AND TOO LOW.

TRIAL #5
3 91 26
SONAR REPORTS SHOT WAS NORTH AND TOO HIGH.

TRIAL #6
2 91 27

B O O M ! ! YOU FOUND IT IN 6 TRIES!

ANOTHER GAME (Y OR N) Y
GOOD LUCK !


TRIAL #1
25 25 25
SONAR REPORTS SHOT WAS SOUTHWEST AND TOO HIGH.

TRIAL #2
50 50 50
SONAR REPORTS SHOT WAS NORTHWEST AND TOO LOW.

TRIAL #3
32 75 32
SONAR REPORTS SHOT WAS NORTHEAST AND TOO HIGH.

TRIAL #4
28 62 40
SONAR REPORTS SHOT WAS NORTHWEST AND TOO LOW.

TRIAL #5
26 68 36
SONAR REPORTS SHOT WAS WEST AND TOO HIGH.

TRIAL #6
26 71 38
SONAR REPORTS SHOT WAS WEST AND TOO LOW.

TRIAL #7
26 73 37
SONAR REPORTS SHOT WAS WEST AND DEPTH OK.

YOU HAVE BEEN TORPEDOED!  ABANDON SHIP!
THE SUBMARINE WAS AT 26 74 37

ANOTHER GAME (Y OR N) N

OK.  HOPE YOU ENJOYED YOURSELF.
```
