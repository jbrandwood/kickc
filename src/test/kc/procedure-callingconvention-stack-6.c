// Test a procedure with calling convention stack
// Recursive fibonacci

char* const SCREEN = (char*)0x0400;

void main(void) {
    *SCREEN = fib(5);
}

char __stackcall fib(char n) {
  if (n == 0 || n == 1)
    return n;
  else
    return (fib(n-1) + fib(n-2));
}