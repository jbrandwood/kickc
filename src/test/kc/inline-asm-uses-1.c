// Demonstrates inline ASM using a variable (res)


void main() {
    char * const SCREEN = 0x1009;
    char x = fgetc(7);
    *SCREEN = x;
}

char * const CHKIN = 0x1000;
char * const GETIN = 0x1003;
char * const CLRCHN = 0x1006;

char fgetc(byte channel)
{
    char ret;
    asm {
        ldx channel
        jsr CHKIN
        jsr GETIN
        sta ret
        jsr CLRCHN
    }
    return ret;
}