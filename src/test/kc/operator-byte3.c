// Test operator BYTE3()

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
    SCREEN[i++] = BYTE3(17);
    SCREEN[i++] = BYTE3(377);
    SCREEN[i++] = BYTE3(333377777);
    SCREEN[i++] = BYTE3(bu);
    SCREEN[i++] = BYTE3(bs);
    SCREEN[i++] = BYTE3(wu);
    SCREEN[i++] = BYTE3(ws);
    SCREEN[i++] = BYTE3(du);
    SCREEN[i++] = BYTE3(ds);
    SCREEN[i++] = BYTE3(ptr);
}