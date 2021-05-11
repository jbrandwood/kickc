// Test that volatile vars are turned into load/store

char* const SCREEN = (char*)0x0400;

void main() {
    volatile char i = 3;
    while(i<7)
        SCREEN[i++] = i;
}