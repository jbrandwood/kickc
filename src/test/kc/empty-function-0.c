// Test removal of empty function

char v;

char * const SCREEN = (char*)0x0400;

void main() {
    set();
    SCREEN[0] = v;
}

void set() {
    v = 7;
}