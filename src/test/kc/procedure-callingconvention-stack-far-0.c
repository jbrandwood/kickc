// Test a procedure with calling convention stack

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(test)
char __far(test, 2) __stackcall plus(char a, char b) {
    return a+b;
}