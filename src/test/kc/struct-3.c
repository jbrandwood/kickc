// Minimal struct - passing struct value parameter

struct Point {
    byte x;
    byte y;
};

void main() {
    struct Point p1;
    p1.x = 1;
    p1.y = 4;
    print(p1);
    p1.x = 2;
    print(p1);
}

byte* const SCREEN = 0x0400;
byte idx = 0;

void print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = p.y;
}