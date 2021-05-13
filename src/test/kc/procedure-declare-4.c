// Procedure Declaration - a procedure with paramters&return declared multiple times & defined

char sum(char a, char b);

void main() {
    char * const SCREEN = (char*)0x0400;
    SCREEN[0] = sum('a', 1);
    SCREEN[1] = sum('b', 2);
}

char sum(char x, char y);

// Calculate sum of two integers plus 1
char sum(char q, char w) {
    return q+w+1;
}

char sum(char z, char r);


