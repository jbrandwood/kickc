// Minimal struct with C-Standard behavior - copying

struct Point {
    char x;
    char y;
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1;
    point1.x = 2;
    point1.y = 3;
    __ma struct Point point2 = point1;
    SCREEN[0] = point2.x;
    SCREEN[1] = point2.y;
}