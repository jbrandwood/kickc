// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!

byte* const SCREEN = 0x0400;
void main() {
    for( byte i: 0..40) {
        SCREEN[i] = (i&1)?0:0x80;
    }
}