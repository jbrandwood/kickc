// Test a far call procedure with a calling convention phi

char* const SCREEN = (char*)0x0400;

#pragma code_seg(stage)
#pragma bank(stage, 20)

char plus(char a, char b) {
    return a+b;
}

#pragma nobank

void main(void) {
    SCREEN[0] = plus('0', 7);
}

