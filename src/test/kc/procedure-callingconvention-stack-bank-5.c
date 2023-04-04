// Test a procedure with calling convention stack
// Recursion that works (no local variables)

#pragma code_seg(stage)
#pragma link("procedure-callingconvention-stack-bank.ld")
#pragma platform(cx16)

char* const SCREEN = (char*)0x0400;

void main(void) {
    *SCREEN = pow2(6);
}

char __stackcall __bank(ram,1) pow2(char n) {
  if (n == 0)
    return 1;
  else {
    char c = pow2(n-1);
    return c+c;
  }

}