// Test the boolean NOT operator
// Bool not operator used directly on char
// Causes a  Type mismatch  - should instead add conversion cast.
// https://gitlab.com/camelot/kickc/issues/295

void main() {
    char* const screen = (char*)0x0400;
    for(char i: 0..7) {
        char b = (i&1);
        screen[i] = !b;
    }
}