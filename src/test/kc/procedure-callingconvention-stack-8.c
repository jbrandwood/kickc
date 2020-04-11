// Test a procedure with calling convention stack
// Illustrates live ranges for printline::i and global variable val

#pragma calling(__stackcall)

char* const SCREEN = 0x0400;

char val = 0;

void main(void) {
    val = '-';
    printline();
    SCREEN[80] = val;
}

void printline() {
    for(char i=0; i<40; i++) {
        SCREEN[i] = '*';
    }
}

