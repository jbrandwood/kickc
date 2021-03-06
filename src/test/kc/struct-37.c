// Complex C-struct - copying a sub-struct from C-standard layout to Unwound layout

// Vector with 16-coordinates that is part of a spline
struct SplineVector16 {
    char x;
    char y;
};

// A segment of a spline
struct Segment {
    enum SegmentType { MOVE_TO, SPLINE_TO, LINE_TO} type;
    struct SplineVector16 to;
    struct SplineVector16 via;
};

// True type letter c
struct Segment letter_c[] = {
     { MOVE_TO, {'a','b'}, {0,0} },
     { SPLINE_TO, {'c','d'}, {103,169} },
     { SPLINE_TO, {'e','f'}, {75,195} }
};

char* const SCREEN = (char*)0x0400;

void main() {
    char j=0;
    for( byte i: 0..2) {
        struct SplineVector16 to = letter_c[i].to;
        SCREEN[j++] = to.x;
        SCREEN[j++] = to.y;
    }
}