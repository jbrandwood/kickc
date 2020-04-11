// Tests the sizeof() operator on structs

struct Point {
    byte x;
    byte y;
};

struct Circle {
    struct Point center;
    byte radius;
};

byte* const SCREEN = $400;

void main() {
    byte idx = 0;

    // Struct Types
    SCREEN[idx++] = '0'+sizeof(struct Point);
    SCREEN[idx++] = '0'+sizeof(struct Circle);

    idx++;
    // Struct Values
    struct Point p;
    SCREEN[idx++] = '0'+sizeof(p);
    struct Circle c;
    SCREEN[idx++] = '0'+sizeof(c);

    idx++;
    // Struct Arrays
    const byte NUM_POINTS = 4;
    struct Point points[NUM_POINTS];
    SCREEN[idx++] = '0'+sizeof(points);
    SCREEN[idx++] = '0'+sizeof(points)/sizeof(struct Point);
    const byte NUM_CIRCLES = NUM_POINTS-1;
    struct Circle circles[NUM_CIRCLES];
    SCREEN[idx++] = '0'+sizeof(circles);
    SCREEN[idx++] = '0'+sizeof(circles)/sizeof(struct Circle);

}