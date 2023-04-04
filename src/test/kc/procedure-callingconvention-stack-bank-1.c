// Test a procedure with calling convention stack

#pragma code_seg(stage)
#pragma link("procedure-callingconvention-stack-bank.ld")
#pragma target(cx16)

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma calling(__stackcall)
#pragma code_seg(stage)

char __bank(ram,20) plus(char a, char b) {
    return a+b;
}