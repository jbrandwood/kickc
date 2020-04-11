// Test the 6502 CPU without support for illegal opcodes
// By a program that normally uses illegal opcodes

#pragma cpu(MOS6502)

void main() {
    char* const screen = 0x0400;
    char c=0;
    while(c<100) {
        screen[c] = '*';
        if((c&4)==0) {
            c+=5;
        }
        c++;
    }

}