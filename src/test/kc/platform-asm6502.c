// Tests the target platform ASM6502

#pragma target(asm6502)
#pragma start_address(0x3000)

unsigned char TABLE[10];

void main() {
    for(char i=0;i<10;i++)
        TABLE[i] = i;
}