// Procedure Declaration

char f(char a);

void main() {
    char * const SCREEN = 0x0400;
    SCREEN[0] = f('a');
    SCREEN[1] = f('b');
}

char f(char a) {
    return a+1;
}
