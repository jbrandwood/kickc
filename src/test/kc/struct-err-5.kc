// Access to non-existing member

struct Point {
    byte x;
    byte y;
};

byte* const SCREEN = 0x0400;

void main() {
    struct Point p;
    do {
        SCREEN[0] = p.x;
    } while(p.z!=0xff);
}

