// Multiple calls with different (constant?) parameters should yield different values at runtime
// Currently the same constant parameter is passed on every call.
// Reason: Multiple versioned parameter constants x0#0, x0#1 are only output as a single constant in the ASM .const x0 = 0

byte* screen = (byte*)$0400;

void main() {
    line(1,2);
    line(3,5);
}

void line(byte x0, byte x1) {
  for(byte x  = x0; x<x1; x++) {
     *screen = x;
     screen++;
  }

}