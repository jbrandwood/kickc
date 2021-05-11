// Minimal struct - nesting structs 3 levels

struct Point {
    byte x;
    byte y;
};

struct Circle {
    struct Point center;
    byte radius;
};

struct TwoCircles {
    struct Circle c1;
    struct Circle c2;
};


void main() {
    struct TwoCircles t = { { { 1, 2}, 3 }, { { 4, 5}, 6 } };
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = t.c1.center.x;
    SCREEN[1] = t.c1.center.y;
    SCREEN[2] = t.c1.radius;
    SCREEN[3] = t.c2.center.x;
    SCREEN[4] = t.c2.center.y;
    SCREEN[5] = t.c2.radius;
}
