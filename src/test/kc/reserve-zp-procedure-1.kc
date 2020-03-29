// Demonstrates a procedure reserving addresses on zeropage

void main() {
    byte* const SCREEN = $400;
    for( volatile byte i : 0..2) {
        SCREEN[i] = sub1(i);
    }
}

reserve(2, 3, 4) byte sub1(byte i) {
    return i+i;
}
