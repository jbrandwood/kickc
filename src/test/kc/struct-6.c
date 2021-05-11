// Minimal struct - nesting structs

struct Point {
    byte x;
    byte y;
};

struct Circle {
    struct Point center;
    byte radius;
};

void main() {
    struct Point p = { 10, 10 };
    struct Circle c = { p, 5 };
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = c.center.x;
    SCREEN[1] = c.center.y;
    SCREEN[2] = c.radius;
}
