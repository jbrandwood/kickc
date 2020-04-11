// Minimal struct with C-Standard behavior - struct containing struct with initializer

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
    __ma struct Vector v = { {2, 3}, {4, 5} };
    SCREEN[0] = v.p.x;
    SCREEN[1] = v.p.y;
    SCREEN[2] = v.q.x;
    SCREEN[3] = v.q.y;
}