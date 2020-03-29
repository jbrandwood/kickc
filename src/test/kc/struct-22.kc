// Minimal struct with C-Standard behavior - call parameter (not supported yet)

struct Point {
    char x;
    char y;
};

void main() {
    __ma struct Point point1 = { 2, 3 };
    __ma struct Point point2 = { 4, 5 };
    print(point1);
    print(point2);
}

char* const SCREEN = 0x0400;

void print(struct Point p) {
    SCREEN[0] = p.x;
    SCREEN[1] = p.y;
}