// Tests the number type used for constant expressions


void main() {
    testBytes();
    testSBytes();
}

void testBytes() {
    // Constant values resolvable to bytes
    byte* const SCREEN = 0x0400;
    byte idx = 0;
    SCREEN[idx++] = 12;
    SCREEN[idx++] = 6+6;
    SCREEN[idx++] = 18-6;
    SCREEN[idx++] = 1812-1800;
    SCREEN[idx++] = 1+2+3+6;
    SCREEN[idx++] = 2*6;
    SCREEN[idx++] = 3<<2;
    SCREEN[idx++] = 24>>1;
    SCREEN[idx++] = 15&28;
    SCREEN[idx++] = 4|8;
    SCREEN[idx++] = 5^9;
    SCREEN[idx++] = (2+2)*(15/5);
    SCREEN[idx++] = (byte)(4096+12);
}

void testSBytes() {
    // Constant values resolvable to signed bytes
    signed byte* const SCREEN = 0x0428;
    byte idx = 0;
    SCREEN[idx++] = -12;
    SCREEN[idx++] = -6-6;
    SCREEN[idx++] = -18+6;
    SCREEN[idx++] = -1812+1800;
    SCREEN[idx++] = -1-2-3-6;
    SCREEN[idx++] = -2*6;
    SCREEN[idx++] = -3<<2;
    SCREEN[idx++] = -24>>1;
    SCREEN[idx++] = -4&-9;
    SCREEN[idx++] = -0x10|-0xfc;
    SCREEN[idx++] = (-2-2)*(15/5);
    SCREEN[idx++] = (signed byte)(4096-12);
}
