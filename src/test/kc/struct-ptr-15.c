// Minimal struct -  using pointers to nested structs

struct Point {
    byte x;
    byte y;
};

struct Circle {
    byte radius;
    struct Point center;
};

struct Circle circles[2];

void main() {
    circles[0].center.x = 2;
    circles[0].center.y = 3;
    circles[0].radius = 5;
    circles[1].center.x = 8;
    circles[1].center.y = 9;
    circles[1].radius = 15;

    byte* const SCREEN = 0x0400;
    byte idx =0;
    struct Circle* ptr = circles;
    for(byte i:0..1) {
        byte x = ptr->center.x;
        byte y = ptr->center.y;
        SCREEN[idx++] = x;
        SCREEN[idx++] = y;
        ptr++;
    }

}
