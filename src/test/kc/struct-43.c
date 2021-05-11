// Minimal struct with C-Standard behavior - struct with internal int array

struct Point {
    char x;
    unsigned int pos[2];
    unsigned int id;
};

__mem __ma struct Point point1 = { 4, {1, 2}, 3 };

unsigned int* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = point1.id;
    SCREEN[1] = point1.pos[0];
    SCREEN[2] = point1.pos[1];
}