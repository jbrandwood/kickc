// Tests simple word pointer iteration
void main() {
    // Clever word array that represents C64 numbers 0-7
    word words[] = { $3130, $3332, $3534, $3736};
    byte* const SCREEN = (char*)$400;
    byte idx = 0;
    word* wp = words;
    for( byte i: 0..3) {
        word w = *(wp++);
        SCREEN[idx++] = <w;
        SCREEN[idx++] = >w;
        idx++;
    }

}
