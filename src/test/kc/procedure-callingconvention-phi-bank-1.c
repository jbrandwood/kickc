// Test a far call procedure with a calling convention sp

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(stage)
#pragma bank(ram, 1)

char plus(char a, char b) {
    return a+b;
}
