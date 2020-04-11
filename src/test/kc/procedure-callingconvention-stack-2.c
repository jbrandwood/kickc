// Test a procedure with calling convention stack - and enough parameters to use fast ASM for cleaning stack

word* const SCREEN = 0x0400;

void main(void) {
    SCREEN[0] = plus(0x1234, 0x2345);
}

word __stackcall plus(word a, word b) {
    return a+b;
}