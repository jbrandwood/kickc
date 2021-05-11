// Demonstrates global directive reserving a range of addresses on zeropage

#pragma zp_reserve(0x00..0x7f)

void main() {
    byte* const SCREEN = (char*)$400;
    for( volatile byte i : 0..2) {
        SCREEN[i] = sub1(i);
    }
}

__zp_reserve(0x80) byte sub1(byte i) {
    return i+i;
}

