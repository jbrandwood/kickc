// Test __varcall calling convention
// Return value

char * const BGCOL = 0xd021;

void main() {
    char a = 1;
    *BGCOL = a;
    a = plus(a, 1);
    *BGCOL = a;
    a = plus(a, 1);
    *BGCOL = a;
}

__varcall char plus(char a, char b) {
    return a+b;
}