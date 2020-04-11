// Minimal struct - array of struct

struct Point {
    byte x;
    byte y;
};

struct Point points[4];

void main() {
    for( byte i: 0..4) {
        points[i].x = i;
        points[i].y = i+1;
    }
    byte* const SCREEN = 0x0400;
    for( byte i: 0..4) {
        SCREEN[i] = points[i].x;
        (SCREEN+40)[i] = points[i].y;
    }
}