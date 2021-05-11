// Test that volatile const vars are turned into load/store

char* const SCREEN = (char*)0x0400;

const volatile char ch = 3;

void main() {
    char i=3;
    while(i<7)
        SCREEN[i++] = ch;
}