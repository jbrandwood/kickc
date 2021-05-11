// Demonstrate that local variable shadowing a global procedure causes an error

void main() {
    char doit = 7;
    doit();
}

char * const SCREEN = (char*)0x0400;

void doit() {
    SCREEN[0] = '*';
}