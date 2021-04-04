// Test operator BYTE2()

void main() {
    volatile unsigned char bu = 7;
    volatile signed char bs = 7;
    volatile unsigned int wu = 20000;
    volatile signed int ws = -177;
    volatile unsigned long du = 2000000;
    volatile signed long ds = -3777777;
    char * volatile ptr = 0x0000;

    char * const SCREEN = 0x0400;
    char i = 0;
    SCREEN[i++] = BYTE2(17);
    SCREEN[i++] = BYTE2(377);
    SCREEN[i++] = BYTE2(377777);
    SCREEN[i++] = BYTE2(bu);
    SCREEN[i++] = BYTE2(bs);
    SCREEN[i++] = BYTE2(wu);
    SCREEN[i++] = BYTE2(ws);
    SCREEN[i++] = BYTE2(du);
    SCREEN[i++] = BYTE2(ds);
    SCREEN[i++] = BYTE2(ptr);
}