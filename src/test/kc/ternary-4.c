// Tests the ternary operator - complex nested conditional operators

void main() {
    char* const SCREEN = $400;
    char i=0;
    for(char b: 0..3) {
        for( char v: 0..3) {
            char x = (b) ? 24 + (v & 2 ? 8 : 13) * 8 : 0;
            SCREEN[i++] = x;
        }
    }
}

