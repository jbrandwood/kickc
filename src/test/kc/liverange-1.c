// Test propagation of live ranges back over PHI-calls
// The idx-variable is alive between the two calls to out() - but not before the first call.


void main() {
    out('c');
    out('m');
}

char* const SCREEN = (char*)0x0400;
char idx = 0;

void out(char c) {
    SCREEN[idx++] = c;
}