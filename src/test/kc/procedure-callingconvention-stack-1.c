// Test a procedure with calling convention stack

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma calling(__stackcall)

char plus(char a, char b) {
    return a+b;
}