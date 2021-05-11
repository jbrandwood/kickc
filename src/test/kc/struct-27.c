// Minimal struct with C-Standard behavior - member is array, copy assignment

struct Point {
    char x;
    char initials[3];
};

char* const SCREEN = (char*)0x0400;

void main() {
    __ma struct Point point1 = { 2, "jg" };
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.initials[0];
    SCREEN[2] = point1.initials[1];
}