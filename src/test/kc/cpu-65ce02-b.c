// Test the 65CE02 CPU
// A program that uses 65CE02 instructions

#pragma cpu(CSG65CE02)

char* const SCREEN = (char*)0x0400;

void main() {
    for(register(Z) char i=0;i<100;i++)
        SCREEN[i] = i;
}