// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded zero-page address - global variable

char* const SCREEN = 0x0400;

char __address(0x02) i = 3;

void main() {
    while(i<7)
        SCREEN[i++] = i;
}