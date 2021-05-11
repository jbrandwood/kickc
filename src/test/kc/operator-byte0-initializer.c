// Test operator BYTE0() / BYTE1() in initializers

char VALS[] = {
    BYTE0(123123123),
    BYTE1(123123123),
    BYTE2(123123123),
    BYTE3(123123123)
};


void main() {

    char * const SCREEN = (char*)0x0400;
    char i = 0;
    SCREEN[i++] = VALS[0];
    SCREEN[i++] = VALS[1];
    SCREEN[i++] = VALS[2];
    SCREEN[i++] = VALS[3];
}