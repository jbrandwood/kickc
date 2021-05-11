// Minimal struct -  array of 3-byte structs (required *3)

struct Point {
    signed byte x;
    signed byte y;
    signed byte z;
};

struct Point points[4];

void main() {
    for( byte i: 0..3) {
        points[i] = { (signed byte)i, -(signed byte)i, (signed byte)i };
    }
    struct Point* const SCREEN = (struct Point*)0x0400;
    for( byte i: 0..3) {
        SCREEN[i] = points[i];
    }

}