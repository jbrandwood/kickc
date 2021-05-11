// Minimal struct with C-Standard behavior - call return value (not supported yet)

struct Point {
    char x;
    char y;
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1 = getPoint(2, 3);
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.y;
    __ma struct Point point2 = getPoint(4, 5);
    SCREEN[2] = point2.x;
    SCREEN[3] = point2.y;
}

struct Point getPoint(char x, char y) {
    struct Point p = { x, y };
    return p;
}