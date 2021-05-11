

void main() {
    for( register(Y) byte x: 0..100 ) {
        for( byte y: 0..100 ) {
            for( byte a: 0..100 ) {
                register(A) byte val1 = a+x;
                print(y, val1);
            }
        }
    }
}

void print(register(X) byte idx, byte val) {
    byte* SCREEN  = (byte*)$400;
    SCREEN[idx] = val;
}