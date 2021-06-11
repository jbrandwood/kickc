// Test using operator byte0() in an lvalue

void main() {
    unsigned int * const SCREEN = (unsigned int *)0x0400;
    unsigned int w = 12345;
    unsigned int ws[] = { 23456, 34567 };
    char i = 0;

    SCREEN[i++] = w;
    BYTE0(w) = 1;
    SCREEN[i++] = w;
    BYTE1(w) = 2;
    SCREEN[i++] = w;

    for(char j=0;j<2;j++) {
        SCREEN[i++] = ws[j];
        BYTE0(ws[j]) = 2;
        SCREEN[i++] = ws[j];
    }

}