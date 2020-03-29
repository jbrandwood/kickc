// Minimal struct - struct return value

struct Point {
    byte x;
    byte y;
};

void main() {
    struct Point q;
    q = point();

    byte* const SCREEN = 0x0400;
    SCREEN[0] = q.x;
    SCREEN[1] = q.y;
}

struct Point point() {
    struct Point p = { 2, 3 };
    return p;
}