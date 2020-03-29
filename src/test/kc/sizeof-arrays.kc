// Tests the sizeof() operator on arrays

byte* const SCREEN = $400;

void main() {
    byte idx = 0;

    // Arrays
    byte ba[3];
    SCREEN[idx++] = '0'+sizeof(ba)/sizeof(byte);

    word wa[3];
    SCREEN[idx++] = '0'+sizeof(wa)/sizeof(word);

    const byte sz = 7;
    byte bb[sz+2];
    SCREEN[idx++] = '0'+sizeof(bb)/sizeof(byte);

    word wb[] = { 1, 2, 3, 4 };
    SCREEN[idx++] = '0'+sizeof(wb)/sizeof(word);

    byte sa[] = "camelot";
    SCREEN[idx++] = '0'+sizeof(sa)/sizeof(byte);

    byte sb[] = { 'a', 'b', 'c', 0};
    SCREEN[idx++] = '0'+sizeof(sb)/sizeof(byte);


}