// Test removal of empty function

char * const SCREEN = 0x0400;

void main() {
    empty();
    SCREEN[0] = 'x';
}

void empty() {
}