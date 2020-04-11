// Test effective live range and register allocation
// Here main::c, out2::c and out::c can all have the same allocation - and the global idx can be allocated to a hardware register.

char* const SCREEN  = 0x0400;
char idx = 0;

void main() {
    for(char c: 0..39 ) {
        out2(c);
    }
}

void out2(char c) {
    out(c);
}

void out(char c) {
    idx++;
    SCREEN[idx] = c;
}