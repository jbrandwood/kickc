// Procedure Declaration

char f(char a);

void g();

void h(void);

//void i(char a, ...);

char f(char a) {
    return a+1;
}

void main() {
    char * const SCREEN = 0x0400;
    SCREEN[0] = f('a');
    SCREEN[1] = f('b');
}

