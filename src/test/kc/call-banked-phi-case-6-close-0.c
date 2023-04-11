// Test a procedure with calling convention PHI - case #6

#pragma link("call-banked-phi.ld")

char* const SCREEN = (char*)0x0400;

#pragma code_seg(Code)
void main(void) {
    SCREEN[0] = plus('0', 7); // close call
}

#pragma code_seg(RAM_Bank1)
__bank(cx16_ram, 1) char plus(char a, char b) {
    return min(a, b); // close call
}

#pragma code_seg(ROM_Bank1)
__bank(cx16_rom, 1) char min(char a, char b) {
    return a+b;
}
