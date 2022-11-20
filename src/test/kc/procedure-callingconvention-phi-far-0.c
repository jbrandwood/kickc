// Test a procedure with calling convention stack

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(stage)
char __far(stage,2) plus(char a, char b) {
    return a+b;
}
