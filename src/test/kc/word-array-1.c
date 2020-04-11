// Tests a simple word array
void main() {
    // Clever word array that represents C64 numbers 0-7
    word words[] = { $3031, $3233, $3435, $3637 };
    byte* const SCREEN = $400;
    byte idx = 0;
    for( byte i: 0..3) {
        word w = words[i];
        SCREEN[idx++] = >w;
        SCREEN[idx++] = <w;
        idx++;
    }

}
