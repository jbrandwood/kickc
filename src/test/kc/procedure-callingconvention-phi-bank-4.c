// Test a far call procedure with a calling convention phi

#pragma link("procedure-callingconvention-phi-bank.ld")
#pragma target(cx16)

char* const SCREEN = (char*)0x0400;

#pragma code_seg(stage)
#pragma bank(ram, 20)

char plus(char a, char b) {
    return a+b;
}

#pragma nobank(dummy)

void main(void) {
    SCREEN[0] = plus('0', 7);
}

