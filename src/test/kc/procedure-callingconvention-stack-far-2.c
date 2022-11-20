// Test a procedure with calling convention stack
// A slightly more complex call

char* const SCREEN = (char*)0x0400;

char i = 0;

void main(void) {
    for(char a:0..1) {
        char v = a+1;
        char w = plus('0', v);
        SCREEN[i] = w+a;
    }
}

// this should give a pragma error during compile, as test is not declared yet.
char __far(test, 20) __stackcall plus(char a, char b) {
    i++;
    return a+b;
}