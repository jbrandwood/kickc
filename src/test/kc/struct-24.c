// Minimal struct with C-Standard behavior - member array

struct Point {
    char x;
    char initials[2];
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1;
    point1.x = 2;
    point1.initials[0] = 'j';
    point1.initials[1] = 'g';
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.initials[0];
    SCREEN[2] = point1.initials[1];
}