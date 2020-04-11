// Error where the compiler is reusing the same ZP for two byte* variables.

byte* MEM = 0x0400;
byte* malloc() {
    return ++MEM;
}

byte* SCREEN_1 = malloc();
byte* SCREEN_2 = malloc();

void main() {
    *SCREEN_1 = 0;
    *SCREEN_2 = 0;
}

