// Test a procedure with calling convention PHI - case #1

#pragma link("call-banked-stack.ld")

char* const SCREEN = (char*)0x0400;

#pragma code_seg(Code)
void main(void) {
    SCREEN[0] = plus('0', 7); // near stack call
}

#pragma code_seg(Code)
__stackcall char plus(char a, char b) {
    return a+b;
}
