// Tests simple word pointer math
void main() {
    // Clever word array that represents C64 numbers 0-7
    word words[] = { $3130, $3332, $3534, $3736};
    byte* const SCREEN = (char*)$400;
    byte idx = 0;
    for( byte i: 0..3) {
        word w = *(words+i);
        SCREEN[idx++] = BYTE0(w);
        SCREEN[idx++] = BYTE1(w);
        idx++;
    }

}
