void main() {
    byte* SCREEN  = $0400;
    for( register(X) byte x: 0..100 ) {
        for( register(X) byte y: 0..100 ) {
            SCREEN[x] = y;
        }
    }
}
