// Tests the target platform ASM6502

#pragma target(asm6502)
#pragma pc(0x2000)

unsigned char TABLE[10];

void main() {
    for(char i=0;i<10;i++)
        TABLE[i] = i;
}