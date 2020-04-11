// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem address - local variable

char* const SCREEN = 0x0400;

void main() {
    char __address(0x2000) i = 3;
    while(i<7)
        SCREEN[i++] = i;
}