// Minimal struct with C-Standard behavior - address-of

struct Point {
    char x;
    char y;
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1 = { 2, 3 };
    struct Point* ptr = &point1;
    SCREEN[0] = ptr->x;
    SCREEN[1] = ptr->y;
}