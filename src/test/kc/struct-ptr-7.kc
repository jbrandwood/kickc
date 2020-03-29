// Minimal struct - direct (constant) array access

struct Point {
    byte x;
    byte y;
};

struct Point points[2];

void main() {
    points[0].x = 2;
    points[0].y = 3;
    points[1].x = 5;
    points[1].y = 6;

    byte* const SCREEN = 0x0400;
    SCREEN[0] = points[0].x;
    SCREEN[1] = points[0].y;
    SCREEN[3] = points[1].x;
    SCREEN[4] = points[1].y;
}