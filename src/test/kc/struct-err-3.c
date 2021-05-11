// Incompatible struct parameter

struct Point {
    byte x;
    byte y;
};

void main() {
    print(7);
}

byte* const SCREEN = (char*)0x0400;

void print(struct Point p) {
    *SCREEN = p.x;
}

