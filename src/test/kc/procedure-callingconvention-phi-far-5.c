// Test a far call procedure with a calling convention phi

char* const SCREEN = (char*)0x0400;

#pragma code_seg(bank_1)
#pragma far(bank_1, 1)

char func_bank1_a(char a, char b) {
    return a+b;
}

char func_bank1_c(char a, char b) {
    // this should be a near call, because the call is from the same bank.
    return func_bank1_a(a,b);
}

char func_bank1_d(char a, char b) {
    // this should be a far call, because the call is to an other bank.
    return func_bank2_a(a,b);
}

#pragma code_seg(bank_2)
#pragma far(bank_2, 2)

char func_bank2_a(char a, char b) {
    return a+b;
}


char func_bank2_c(char a, char b) {
    // this should be a far call, because the call is from another bank.
    return func_bank1_a(a,b);
}

char func_bank2_d(char a, char b) {
    // this should be a near call, because the call is from the same bank.
    return func_bank2_a(a,b);
}

char func_bank2_e(char a, char b) {
    // this should be a near call, because the call is from the same bank.
    return func_bank2_b(a,b);
}

char func_bank2_f(char a, char b) {
    // this should be a far call, because the call is from another bank.
    return func_bank1_b(a,b);
}

#pragma near

char __far(bank_1, 1) func_bank1_b(char a, char b) {
    return a+b;
}

char __far(bank_2, 2) func_bank2_b(char a, char b) {
    return a+b;
}

#pragma near

char func_bank1_e(char a, char b) {
    // this should be a far call, because the call is to bank 1.
    return func_bank1_a(a,b);
}

char func_bank1_f(char a, char b) {
    // this should be a far call, because the call is to bank 2.
    return func_bank2_a(a,b);
}

#pragma code_seg(Code)

void main(void) {
    // far call
    SCREEN[0] = func_bank1_a('0', 7);
    // far call
    SCREEN[0] = func_bank1_b('0', 7);
    // far call
    SCREEN[0] = func_bank1_c('0', 7);
    // far call
    SCREEN[0] = func_bank1_d('0', 7);
    // near call
    SCREEN[0] = func_bank1_e('0', 7);
    // near call
    SCREEN[0] = func_bank1_f('0', 7);
    // far call
    SCREEN[0] = func_bank2_a('0', 7);
    // far call
    SCREEN[0] = func_bank2_b('0', 7);
    // far call
    SCREEN[0] = func_bank2_c('0', 7);
    // far call
    SCREEN[0] = func_bank2_d('0', 7);
    // far call
    SCREEN[0] = func_bank2_e('0', 7);
    // far call
    SCREEN[0] = func_bank2_f('0', 7);
}

