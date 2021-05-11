// Complex C-struct - copying a sub-struct with 2-byte members from C-standard layout to C-standard layout (expecting a memcpy)

// Vector with 16-coordinates that is part of a spline
struct Vector {
    signed int x;
    signed int y;
};

// A segment of a spline
struct Segment {
    enum SegmentType { MOVE_TO, SPLINE_TO, LINE_TO} type;
    struct Vector to;
    struct Vector via;
};

// True type letter c
struct Segment letter_c[] = {
     { MOVE_TO, {'a','b'}, {0,0} },
     { SPLINE_TO, {'c','d'}, {103,169} },
     { SPLINE_TO, {'e','f'}, {75,195} }
};

signed int* const SCREEN = (signed int*)0x0400;

void main() {
    char j=0;
    for( byte i: 0..2) {
        __ma struct Vector to = letter_c[i].to;
        SCREEN[j++] = to.x;
        SCREEN[j++] = to.y;
    }
}