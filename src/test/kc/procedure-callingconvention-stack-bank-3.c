// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val

#pragma calling(__stackcall)

#pragma code_seg(stage)
#pragma link("procedure-callingconvention-stack-bank.ld")
#pragma target(cx16)

char* const SCREEN = (char*)0x0400;

char val = 0;

void main(void) {
    for(char i:0..5) {
        pval();
        printother();
        ival();
    }
}

#pragma code_seg(stage)

void __bank(ram, 20) pval() {
    printval();
}

#pragma code_seg(platform)

void __bank(ram, 21) ival() {
    incval();
}

#pragma code_seg(stage)

void __bank(ram, 20) printval() {
    SCREEN[0] = val;
}


#pragma code_seg(platform)

void __bank(ram, 21) incval() {
    val++;
}

#pragma nobank
#pragma code_seg(Code)

void printother() {
    for(char i:0..5) {
        (SCREEN+40)[i]++;
    }
}





