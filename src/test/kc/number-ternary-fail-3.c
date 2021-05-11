// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!

void main() {
    char* BASIC = (char*)0xa000;
    char* SCREEN = (char*)0x0400;
    for( char i: 0..7 ) {
        char glyph_bits = BASIC[i];
        char glyph_bit = (glyph_bits&0x80)?1:0;
        SCREEN[i] = glyph_bit;
    }
}

