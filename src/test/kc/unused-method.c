void main() {
    byte* screen = (byte*)$400;
    screen[0] = 1;
}

byte sum(byte b1, byte b2) {
    return b1+b2;
}