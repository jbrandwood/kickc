// Demonstrates global directive reserving addresses on zeropage

#pragma zp_reserve(2,5)

void main() {
    byte* const SCREEN = (char*)$400;
    for( volatile byte i : 0..2) {
        SCREEN[i] = sub1(i);
    }
}

__zp_reserve(3) byte sub1(byte i) {
    return i+i;
}

