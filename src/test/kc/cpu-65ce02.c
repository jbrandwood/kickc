// Test the 65CE02 CPU
// A program that uses 65CE02 instructions

#pragma cpu(CSG65CE02)

signed char* const SCREEN = 0x0400;

void main() {
    signed char a = SCREEN[0];
    a = -a;
    SCREEN[1] = a; // Becomes a NEG
    SCREEN[2] = a/4; // Becomes ASR
}