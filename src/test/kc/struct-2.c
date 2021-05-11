// Minimal struct - two instances being copied (using assignment)

struct Point {
    byte x;
    byte y;
};

struct Point point1, point2;

void main() {
    point1.x = 2;
    point1.y = 3;
    point2 = point1;
    point2.x = 4;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.y;
    SCREEN[2] = point2.x;
    SCREEN[3] = point2.y;
}