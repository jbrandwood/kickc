

void main() {
    for( byte x: 0..100 ) {
        for( byte y: 0..100 ) {
            for( byte a: 0..100 ) {
                byte val1 = a+x;
                print(y, val1);
            }
        }
    }
}

void print(register(X) byte idx, byte val) {
    byte* const SCREEN  = (byte*)$400;
    SCREEN[idx] = val;
}