// Minimal struct with Unwound behavior - struct containing struct copying

struct Point {
    char x;
    char y;
};

struct Vector {
    struct Point p;
    struct Point q;
};

char* const SCREEN = (char*)0x0400;

void main() {
    char idx = 0;
    __ssa struct Vector v1 = { {2, 3}, { 4, 5 } };
    __ssa struct Vector v2 = v1;
    __ssa struct Vector v3 = { v1.p, {6, 7} };
    __ssa struct Vector v4 = { {v1.p.x, v1.p.y }, {8, 9} };
    SCREEN[idx++] = v1.p.x;
    SCREEN[idx++] = v1.p.y;
    SCREEN[idx++] = v1.q.x;
    SCREEN[idx++] = v1.q.y;
    SCREEN[idx++] = v2.p.x;
    SCREEN[idx++] = v2.p.y;
    SCREEN[idx++] = v2.q.x;
    SCREEN[idx++] = v2.q.y;
    SCREEN[idx++] = v3.p.x;
    SCREEN[idx++] = v3.p.y;
    SCREEN[idx++] = v3.q.x;
    SCREEN[idx++] = v3.q.y;
    SCREEN[idx++] = v4.p.x;
    SCREEN[idx++] = v4.p.y;
    SCREEN[idx++] = v4.q.x;
    SCREEN[idx++] = v4.q.y;
}