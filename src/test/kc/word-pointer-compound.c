// Test word pointer compound assignment

void main() {
    word words[] = { $3031, $3233, $3435 };

    for( byte i: 0..2) {
        words[i] += $0101;
    }

    byte* const SCREEN = (byte*)$400;

    SCREEN[0] = BYTE1(words[0]);
    SCREEN[1] = BYTE0(words[0]);
    SCREEN[2] = BYTE1(words[1]);
    SCREEN[3] = BYTE0(words[1]);
    SCREEN[4] = BYTE1(words[2]);
    SCREEN[5] = BYTE0(words[2]);



}

