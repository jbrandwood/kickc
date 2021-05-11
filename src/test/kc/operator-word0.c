// Test operator WORD0()

void main() {
    volatile unsigned char bu = 7;
    volatile signed char bs = 7;
    volatile unsigned int wu = 20000;
    volatile signed int ws = -177;
    volatile unsigned long du = 2000000;
    volatile signed long ds = -3777777;
    char * volatile ptr = (char*)0x0000;

    unsigned int * const SCREEN = (char*)0x0400;
    char i = 0;
    SCREEN[i++] = WORD0(17);
    SCREEN[i++] = WORD0(377);
    SCREEN[i++] = WORD0(bu);
    SCREEN[i++] = WORD0(bs);
    SCREEN[i++] = WORD0(wu);
    SCREEN[i++] = WORD0(ws);
    SCREEN[i++] = WORD0(du);
    SCREEN[i++] = WORD0(ds);
    SCREEN[i++] = WORD0(ptr);
}