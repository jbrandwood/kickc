// Implementing a semi-struct without the struct keyword by using pointer math and inline functions
//
// struct Point {
//    byte xpos; // The x-position
//    byte ypos; // The y-position
// };
// Point points[NUM_POINTS];

#include <print.h>

// The size of a point
const byte SIZEOF_POINT = 2;

// The number of points
const byte NUM_POINTS = 4;

// All points
byte points[NUM_POINTS*SIZEOF_POINT];

// Get a point by index
inline byte* getPoint(byte idx) {
    return points+idx*SIZEOF_POINT;
}

// Get x-position of the point
inline byte* pointXpos(byte* point) {
    return (byte*)(point+0);
}

// Get y-position of the point
inline byte* pointYpos(byte* point) {
    return (byte*)(point+1);
}

// Initialize some points and print them
void main() {
    init_points();
    print_points();
}

// Initialize points
void init_points() {
    byte pos = 10;
    for(byte i: 0..NUM_POINTS-1) {
        byte* point = getPoint(i);
        *pointXpos(point) = pos;
        pos +=10;
        *pointYpos(point) = pos;
        pos +=10;
    }
}

// Print points
void print_points() {
    print_cls();
    for(byte i: 0..NUM_POINTS-1) {
        byte* point = getPoint(i);
        print_u8(*pointXpos(point));
        print_str(" ");
        print_u8(*pointYpos(point));
        print_ln();
    }
}

