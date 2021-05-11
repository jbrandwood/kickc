// Tests the ternary operator

void main() {
    byte* const SCREEN = (char*)$400;
    for( byte i: 0..9) {
        SCREEN[i] = i<5?'a':'b';
    }
}
