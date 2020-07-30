// Test the 45GS02 CPU
// A program that uses 45GS02 instructions

#pragma cpu(MEGA45GS02)

unsigned long* SCREEN = 0x0400;

void main() {
    unsigned long sum = 0;
    unsigned long addend = 123456;
    for(char i=0;i<100;i++) {
        sum += addend; // will utilize ADQ/STQ
        addend += i;
    }
    *SCREEN = sum;   // will utilize LDQ/STQ
}