// Unrolling a loop containing an inner call

void main() {
    byte* SCREEN = $400;
    byte a=$10;
    inline for(byte i: 0..2) {
        a = plus(a, i);
        SCREEN[i] = a;
    }

}

byte plus(byte a, byte b) {
    return a+b;
}