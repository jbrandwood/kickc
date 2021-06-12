// Reference file for Minimal struct -  using address-of

void main() {
    word p = { 2, 3 };
    word *q = &p;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = BYTE0(*q);
    SCREEN[1] = BYTE1(*q);
}