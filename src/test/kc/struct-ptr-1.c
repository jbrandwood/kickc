// Minimal struct - array of struct - near pointer math indexing

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
        *((byte*)points+OFFS_X+i*SIZEOF_POINT) = i;    // points[i].x = i;
        *((byte*)points+OFFS_Y+i*SIZEOF_POINT) = i+4;  // points[i].y = i+4;
    }
    byte* const SCREEN = (char*)0x0400;
    for( byte i: 0..3) {
        SCREEN[i] = *((byte*)points+OFFS_X+i*SIZEOF_POINT);      // SCREEN[i] = points[i].x;
        (SCREEN+40)[i] = *((byte*)points+OFFS_Y+i*SIZEOF_POINT); // (SCREEN+40)[i] = points[i].y;
    }
}