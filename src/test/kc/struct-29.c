// Minimal struct with C-Standard behavior - global main-mem struct should be initialized in data, not code

struct Point {
    char x;
    char initials[2];
};

__mem __ma struct Point point1 = { 2, { 'j', 'g' } };

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = point1.x;
    SCREEN[1] = point1.initials[0];
    SCREEN[2] = point1.initials[1];
}