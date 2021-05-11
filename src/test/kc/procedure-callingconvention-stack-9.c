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

void pval() {
    printval();
}

void ival() {
    incval();
}

void printval() {
    SCREEN[0] = val;
}

void incval() {
    val++;
}

void printother() {
    for(char i:0..5) {
        (SCREEN+40)[i]++;
    }
}





