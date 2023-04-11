// Test a procedure with calling convention PHI - case #1

#pragma code_seg(Code)
#pragma link("call-banked-phi.ld")

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

char plus(char a, char b) {
    return a+b;
}
