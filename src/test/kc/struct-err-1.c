// Incompatible struct assignment

struct Point1 {
    byte x;
    byte y;
};

struct Point2 {
    byte x;
    byte y;
};

void main() {
    struct Point1 p1;
    struct Point2 p2;
    p1.x = 4;
    p2 = p1;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = p2.x;
    SCREEN[0] = p2.y;

}

