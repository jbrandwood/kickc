// Demonstrates problem with a double call not being detected as a type error

void main() {
    clrscr()();
}

void clrscr(void) {
    char * const SCREEN = (char*)0x0400;
    SCREEN[0] = '@';
}