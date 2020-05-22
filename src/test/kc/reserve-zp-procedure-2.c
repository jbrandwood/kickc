// Demonstrates a procedure reserving addresses on zeropage

void main() {
    byte* const SCREEN = $400;
    for( volatile byte i : 0..2) {
        SCREEN[i] = sub1(i);
        (SCREEN+40)[i] = sub2(i);
    }
}

__zp_reserve(2, 3, 4) byte sub1(byte i) {
    return i+i;
}

__zp_reserve(5, 6, 7) byte sub2(byte i) {
    return i+i+i;
}