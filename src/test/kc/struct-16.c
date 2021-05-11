// Minimal struct with C-Standard behavior - initializer

struct Point {
    char x;
    char y;
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1 = { 2, 3 };
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.y;
}