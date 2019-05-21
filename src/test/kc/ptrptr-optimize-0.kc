// Tests optimization of constant pointers to pointers
void main() {
    byte* screen = 0x400;
    byte** pscreen = &screen;
    **pscreen = 'a';
    (*pscreen)++;
    **pscreen = 'b';
}