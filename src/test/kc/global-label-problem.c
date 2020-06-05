// Demonstrates problems with local labels overwriting global labels
// This should produce "abca" - but produces "abcc" because the local variable containing "c" overrides the global variable containing "a"

void main () {
    print("a");
    print("b");
    print1();
}

void print1() {
    print("c");
    print("a");
}

// Screen pointer and index
char* const SCREEN = 0x0400;
char idx = 0;

void print(char* msg) {
    while(*msg)
        SCREEN[idx++] = *msg++;
}


