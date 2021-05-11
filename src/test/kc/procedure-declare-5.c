// Procedure Declaration - a void procedure declared with empty parenthesis

char f(void);

char f() {
    return 7;
}

void main() {
    char * const SCREEN = (char*)0x0400;
    SCREEN[0] = f();
}

