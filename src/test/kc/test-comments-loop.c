void main() {
    byte* const SCREEN = $400;
    // Do some sums
    for(byte b: 0..10 ) {
        SCREEN[b] = 'a';
    }
}

