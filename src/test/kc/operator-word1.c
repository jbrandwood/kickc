// Test operator WORD1()

void main() {
    volatile unsigned char bu = 7;
    volatile signed char bs = 7;
    volatile unsigned int wu = 20000;
    volatile signed int ws = -177;
    volatile unsigned long du = 2000000;
    volatile signed long ds = -3777777;
    char * volatile ptr = 0x0000;

    unsigned int * const SCREEN = 0x0400;
    char i = 0;
    SCREEN[i++] = WORD1(17);
    SCREEN[i++] = WORD1(377);
    SCREEN[i++] = WORD1(bu);
    SCREEN[i++] = WORD1(bs);
    SCREEN[i++] = WORD1(wu);
    SCREEN[i++] = WORD1(ws);
    SCREEN[i++] = WORD1(du);
    SCREEN[i++] = WORD1(ds);
    SCREEN[i++] = WORD1(ptr);
}