// Test removal of empty function

char * const SCREEN = (char*)0x0400;

void main() {
    empty();
    SCREEN[0] = 'x';
}

void empty() {
}