// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem-page address - global variable

char* const SCREEN = (char*)0x0400;

char __address(0x2000) i = 3;

void main() {
    while(i<7)
        SCREEN[i++] = i;
}