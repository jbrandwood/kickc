// Test a procedure with calling convention stack
// Return value larger than parameter

int* const SCREEN = (int*)0x0400;

void main(void) {
    SCREEN[0] = next();
    SCREEN[1] = next();
}

int  current = 48;

int __stackcall next() {
    return current++;
}