// Test operator BYTE0()

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
    SCREEN[i++] = BYTE1(17);
    SCREEN[i++] = BYTE1(377);
    SCREEN[i++] = BYTE1(bu);
    SCREEN[i++] = BYTE1(bs);
    SCREEN[i++] = BYTE1(wu);
    SCREEN[i++] = BYTE1(ws);
    SCREEN[i++] = BYTE1(du);
    SCREEN[i++] = BYTE1(ds);
    SCREEN[i++] = BYTE1(ptr);
}