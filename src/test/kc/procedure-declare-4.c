// Procedure Declaration - a procedure with paramters&return declared multiple times & defined

char sum(char a, char b);

void main() {
    char * const SCREEN = 0x0400;
    SCREEN[0] = f('a', 1);
    SCREEN[1] = f('b', 2);
}

char sum(char x, char y);

char sum(char q, char w) {
    return q+w+1;
}

char sum(char z, char r);


