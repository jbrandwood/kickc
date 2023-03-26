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

#pragma code_seg(test)
#pragma code_seg(test2)
#pragma code_seg(test3)
#pragma code_seg(Code)

void __bank(ram, 20) pval() {
    printval();
}

void __bank(ram, 21) ival() {
    incval();
}

void __bank(ram, 20) printval() {
    SCREEN[0] = val;
}

void __bank(ram, 21) incval() {
    val++;
}

#pragma nobank

void printother() {
    for(char i:0..5) {
        (SCREEN+40)[i]++;
    }
}





