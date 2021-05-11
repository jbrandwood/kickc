// Access to non-existing member

struct Point {
    byte x;
    byte y;
};

byte* const SCREEN = (char*)0x0400;

void main() {
    struct Point p;
    SCREEN[0] = p.z;
}

