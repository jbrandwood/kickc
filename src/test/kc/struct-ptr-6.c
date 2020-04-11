// Minimal struct - accessing pointer to struct in memory using arrow operator

struct Point {
    byte x;
    byte y;
};

struct Point* points = 0x1000;

void main() {
    byte* const SCREEN = 0x0400;
    SCREEN[0] = points->x;
    SCREEN[1] = points->y;
    points++;
    SCREEN[2] = points->x;
    SCREEN[3] = points->y;
}