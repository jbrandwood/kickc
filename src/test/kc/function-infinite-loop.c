// Test a function returning a value that has an infinite loop
// https://gitlab.com/camelot/kickc/-/issues/310

char * const SCREEN = 0x0400;

void main() {
    SCREEN[0] = get(7);
    SCREEN[0] = get(5);
}

char get(char x) {
    while(1)
        x++;
    return x+4;
}