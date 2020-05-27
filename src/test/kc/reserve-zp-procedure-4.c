// Demonstrates a procedure reserving addresses on zeropage

void main() {
    byte* const SCREEN = $400;
    for( volatile byte i : 0..2) {
        SCREEN[i] = sub1(i);
    }
}

__zp_reserve(2..4) byte sub1(byte i) {
    return i+i;
}

__zp_reserve(5..7) byte sub2(byte i) {
    return i+i+i;
}