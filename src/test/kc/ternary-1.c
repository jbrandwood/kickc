// Tests the ternary operator

void main() {
    byte* const SCREEN = $400;
    for( byte i: 0..9) {
        SCREEN[i] = i<5?'a':'b';
    }
}
