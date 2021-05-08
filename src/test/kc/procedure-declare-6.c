// Procedure Declaration - declaration and definition mismatch of a procedure

char f(char a);

int f(char a) {
    return a+1;
}

void main() {
    int * const SCREEN = 0x0400;
    SCREEN[0] = f('a');
    SCREEN[1] = f('b');
}

