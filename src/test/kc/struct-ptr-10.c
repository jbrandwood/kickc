// Minimal struct -  array with 256+ structs

struct Point {
    byte x;
    byte y;
};

struct Point points[500];

void main() {
    for( word i: 0..499) {
        points[i] = { 2, (byte)i };
    }
    struct Point* const SCREEN = 0x0400;
    for( word i: 0..499) {
        SCREEN[i] = points[i];
    }

}