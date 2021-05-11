// Test operator BYTE0()

void main() {
    volatile unsigned char bu = 7;
    volatile signed char bs = 7;
    volatile unsigned int wu = 20000;
    volatile signed int ws = -177;
    volatile unsigned long du = 2000000;
    volatile signed long ds = -3777777;
    char * volatile ptr = (char*)0x0000;

    char * const SCREEN = (char*)0x0400;
    char i = 0;
    SCREEN[i++] = BYTE0(17);
    SCREEN[i++] = BYTE0(377);
    SCREEN[i++] = BYTE0(bu);
    SCREEN[i++] = BYTE0(bs);
    SCREEN[i++] = BYTE0(wu);
    SCREEN[i++] = BYTE0(ws);
    SCREEN[i++] = BYTE0(du);
    SCREEN[i++] = BYTE0(ds);
    SCREEN[i++] = BYTE0(ptr);
}