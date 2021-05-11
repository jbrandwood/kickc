// Minimal struct - array of struct - far pointer math indexing

struct Point {
    byte x;
    byte y;
};

struct Point points[4];

const byte SIZEOF_POINT = 2;
const byte OFFS_X = 0;
const byte OFFS_Y = 1;

void main() {
    for( byte i: 0..3) {
        struct Point* point_i = points+i;
        *((byte*)point_i+OFFS_X) = i;    // points[i].x = i;
        *((byte*)point_i+OFFS_Y)  = i+4;  // points[i].y = i+4;
    }
    byte* const SCREEN = (char*)0x0400;
    for( byte i: 0..3) {
        struct Point* point_i = points+i;
        SCREEN[i] = *((byte*)point_i+OFFS_X);      // SCREEN[i] = points[i].x;
        (SCREEN+40)[i] = *((byte*)point_i+OFFS_Y); // (SCREEN+40)[i] = points[i].y;
    }
}