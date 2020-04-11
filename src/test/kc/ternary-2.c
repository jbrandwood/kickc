// Tests the ternary operator - when the condition is constant

void main() {
    byte* const SCREEN = $400;
    SCREEN[0] = true?'a':'b';
    SCREEN[1] = false?'a':'b';
}
