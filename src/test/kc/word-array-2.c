// Tests a word-array with 128+ elements

word words[256];

void main() {
    for(byte i: 0..0xff) {
        words[(word)i] = ((word)i)*0x100+i;
    }

    word* const SCREEN = $0400;
    SCREEN[0] = words[(word)255];

}
