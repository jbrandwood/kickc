// Test a procedure with calling convention stack
// Test casting of parameter types
// Currently fails because the pushed are done based on the actual value instead of the declared parameter type
// https://gitlab.com/camelot/kickc/issues/319

word* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

word __stackcall plus(word a, word b) {
    return a+b;
}