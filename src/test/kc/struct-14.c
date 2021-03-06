// Minimal struct with C-Standard behavior - declaration, instantiation and usage

struct Point {
    char x;
    char y;
};

struct Point points[1];

char* const SCREEN = (char*)0x0400;

void main() {
    points[0].x = 2;
    points[0].y = 3;
    SCREEN[0] = points[0].x;
    SCREEN[1] = points[0].y;
}