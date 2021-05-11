// Tests the sizeof() operator on arrays

byte* const SCREEN = (char*)$400;

void main() {
    byte idx = 0;

    // Arrays
    byte ba[3];
    SCREEN[idx++] = '0'+(char)(sizeof(ba)/sizeof(byte));

    word wa[3];
    SCREEN[idx++] = '0'+(char)(sizeof(wa)/sizeof(word));

    const byte sz = 7;
    byte bb[sz+2];
    SCREEN[idx++] = '0'+(char)(sizeof(bb)/sizeof(byte));

    word wb[] = { 1, 2, 3, 4 };
    SCREEN[idx++] = '0'+(char)(sizeof(wb)/sizeof(word));

    byte sa[] = "camelot";
    SCREEN[idx++] = '0'+(char)(sizeof(sa)/sizeof(byte));

    byte sb[] = { 'a', 'b', 'c', 0};
    SCREEN[idx++] = '0'+(char)(sizeof(sb)/sizeof(byte));

}