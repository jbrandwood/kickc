// Test that a volatile nomodify-variable works as expected

const volatile char i = 7;

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = i;
}