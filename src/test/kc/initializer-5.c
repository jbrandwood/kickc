// Demonstrates initializing an array of structs - with trailing commas

struct Point {
    char x;
    int y;
};

struct Point points[] = {
    { 1, 2, },
    { 3, 4, },
    { 5, 6, },
};

void main() {
    char* const SCREEN = (char*)0x0400;
    char idx = 0;
    for( char i: 0..2) {
        SCREEN[idx++] = points[i].x;
        SCREEN[idx++] = <points[i].y;
        SCREEN[idx++] = >points[i].y;
    }
}