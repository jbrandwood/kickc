// Incompatible struct assignment

struct Point {
    byte x;
    byte y;
};

void main() {
    struct Point p1;
    p1 = 4;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = p1.x;
}

