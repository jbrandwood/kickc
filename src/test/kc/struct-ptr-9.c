// Minimal struct -  array access with struct value copying (and initializing)

struct Point {
    byte x;
    byte y;
};

struct Point points[2];

void main() {
    for( byte i: 0..1) {
        points[i] = { 2, i };
    }

    struct Point* const SCREEN = (struct Point*)0x0400;
    for( byte i: 0..1) {
        SCREEN[i] = points[i];
    }
}