// Test that volatile vars are turned into load/store

volatile char i = 3;

char* const SCREEN = (char*)0x0400;

void main() {
    while(i<7)
        SCREEN[i++] = i;
}