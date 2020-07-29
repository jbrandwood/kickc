// Test the 65C02 CPU
// A program that uses 65C02 instructions

#pragma cpu(WDC65C02)

char* const SCREEN = 0x0400;

void main() {
    char a = SCREEN[0];
    SCREEN[1] = a+1; // will use INC A
}