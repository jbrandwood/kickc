// Tests (non-)optimization of constant pointers to pointers
// The two examples of &screen is not detected as identical leading to ASM that could be optimized more
void main() {
    byte* screen = (char*)0x400;
    sub('a',&screen);
    sub('b',&screen);
}

void sub(unsigned char ch, unsigned char **dst) {
    *(*dst)++ = ch;
}
