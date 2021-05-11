// Minimal struct with C-Standard behavior - declaration, instantiation and usage

struct Point {
    char x;
    char y;
};

__ma struct Point point;

char* const SCREEN = (char*)0x0400;

void main() {
    point.x = 2;
    point.y = 3;
    SCREEN[0] = point.x;
    SCREEN[1] = point.y;
}