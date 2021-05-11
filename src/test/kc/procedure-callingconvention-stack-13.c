// Test a procedure with calling convention stack
// Recursion that works (no local variables)

char* const SCREEN = (char*)0x0400;

void main(void) {
    *SCREEN = pow2(6);
}

char __stackcall pow2(char n) {
  if (n == 0)
    return 1;
  else {
    char c = pow2(n-1);
    return c+c;
  }

}