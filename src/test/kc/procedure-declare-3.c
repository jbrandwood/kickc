// Procedure Declaration - a procedure with paramters&return declared & defined

char sum(char a, char b);

void main() {
    char * const SCREEN = (char*)0x0400;
    SCREEN[0] = sum('a', 1);
    SCREEN[1] = sum('b', 2);
}

char sum(char a, char b) {
    return a+b+1;
}

