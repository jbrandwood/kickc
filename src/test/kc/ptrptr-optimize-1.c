// Tests optimization of constant pointers to pointers
void main() {
    byte* screen = (char*)0x400;
    byte** pscreen = &screen;
    sub('a',pscreen);
    sub('b',pscreen);
}

void sub(unsigned char ch, unsigned char **dst) {
    *(*dst)++ = ch;
}
