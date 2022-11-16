// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val

#pragma calling(__stackcall)

char* const SCREEN = (char*)0x0400;

char val = 0;

void main(void) {
    for(char i:0..5) {
        pval();
        printother();
        ival();
    }
}

void __far(1) pval() {
    printval();
}

void __far(2) ival() {
    incval();
}

void __far(3) printval() {
    SCREEN[0] = val;
}

void __far(4) incval() {
    val++;
}

void __far(5) printother() {
    for(char i:0..5) {
        (SCREEN+40)[i]++;
    }
}





