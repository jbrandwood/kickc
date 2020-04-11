// Minimal struct -  variable array access

struct Point {
    byte x;
    byte y;
};

struct Point points[2];

void main() {
    for( byte i: 0..1) {
        points[i].x = 2+i;
        points[i].y = 3+i;
    }

    byte* const SCREEN = 0x0400;
    byte idx = 0;
    for( byte i: 0..1) {
        SCREEN[idx++] = points[i].x;
        SCREEN[idx++] = points[i].y;
        SCREEN[idx++] = ' ';
    }
}