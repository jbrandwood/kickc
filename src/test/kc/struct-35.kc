// Minimal struct with C-Standard behavior - copy assignment through struct pointer

struct Point {
    char x;
    char y;
};

__mem __ma struct Point point1 = { 2, 3 };
__mem __ma struct Point point2;

char* const SCREEN = 0x0400;

void main() {
    struct Point* p2 = &point2;
    *p2 = point1;
    SCREEN[0] = point2.x;
    SCREEN[1] = point2.y;
}