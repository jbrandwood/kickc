// Test a far call procedure with a calling convention PHI into ROM

#pragma code_seg(stage)
#pragma link("procedure-callingconvention-phi-bank.ld")
#pragma target(cx16)

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(stage)
#pragma bank(rom, 1) // test rom bank

char plus(char a, char b) {
    return a+b;
}

