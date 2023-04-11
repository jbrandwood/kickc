// Test a procedure with calling convention PHI - case #4

#pragma link("call-banked-phi.ld")


char* const SCREEN = (char*)0x0400;

#pragma code_seg(Code)
void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(RAM_Bank1)
char __bank(cx16_ram, 1) plus(char a, char b) {
    return min(a, b);
}

#pragma code_seg(RAM_Bank1)
char __bank(cx16_ram, 1) min(char a, char b) {
    return a+b;
}
