// Test a procedure with calling convention stack
// Illustrates live ranges for main::val and printline::i

#pragma calling(__stackcall)

char* const SCREEN = 0x0400;

void main(void) {
    char val;
    val = *SCREEN;
    printline();
    SCREEN[80] = val;
}

void printline() {
    for(char i=0; i<40; i++) {
        SCREEN[i] = '*';
    }
}

