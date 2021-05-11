// Minimal struct - two instances being used.

struct Point {
    byte x;
    byte y;
};

struct Point point1, point2;

void main() {
    point1.x = 2;
    point1.y = 3;
    point2.x = point1.y;
    point2.y = point1.x;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = point2.x;
    SCREEN[1] = point2.y;
}