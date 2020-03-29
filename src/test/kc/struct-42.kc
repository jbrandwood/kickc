// Minimal struct with C-Standard behavior - copying into a struct array

struct Point {
    char x;
    char y;
};

struct Point points[3];

char* const SCREEN = 0x0400;

void main() {
    for( char i: 0..2)
        points[i] = { 2, 3 };
    SCREEN[0] = points[2].x;
    SCREEN[1] = points[2].y;
}