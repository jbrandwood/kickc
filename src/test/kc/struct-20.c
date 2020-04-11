// Minimal struct with C-Standard behavior - struct containing struct with initializer using sub-struct value

struct Point {
    char x;
    char y;
};

struct Vector {
    struct Point p;
    struct Point q;
};

char* const SCREEN = 0x0400;

void main() {
    __ma struct Point p1 = { 2, 3 };
    __ma struct Point p2 = { 4, 5 };
    __ma struct Vector v = { p1, p2 };
    SCREEN[0] = v.p.x;
    SCREEN[1] = v.p.y;
    SCREEN[2] = v.q.x;
    SCREEN[3] = v.q.y;
}