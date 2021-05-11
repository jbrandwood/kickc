// Tests using integer conditions in if()
// This should produce '0 0 0' at the top of the screen

byte* const SCREEN = (byte*)0x0400;

void main() {
    byte idx = 0;
    // Hardcoded 0
    if(!0) SCREEN[idx++] = '0';
    // Hardcoded non-0
    if(!999) SCREEN[idx++] = '+';
    SCREEN[idx++] = ' ';
    // loop byte
    for( byte i:0..2) {
        if(!i) SCREEN[idx++] = '0';
    }
    SCREEN[idx++] = ' ';
    // loop word
    for( word i:0..2) {
        if(!i) SCREEN[idx++] = '0';
    }

}