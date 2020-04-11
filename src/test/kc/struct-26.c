// Minimal struct with C-Standard behavior - member is array, copy assignment

struct Point {
    char x;
    char initials[2];
};

char* const SCREEN = 0x0400;

void main() {
    __ma struct Point point1;
    point1.x = 2;
    point1.initials[0] = 'j';
    point1.initials[1] = 'g';
    __ma struct Point point2 = point1;
    SCREEN[0] = point2.x;
    SCREEN[1] = point2.initials[0];
    SCREEN[2] = point2.initials[1];
}