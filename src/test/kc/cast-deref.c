// Example of NOP-casting a dereferenced signed byte to a byte

void main() {
    signed byte sbs[] = { -1, -2, -3, -4};
    byte* SCREEN = $0400;
    for(byte i : 0..3) {
        SCREEN[i] = (byte) sbs[i];
    }
}