// Tests creating a literal pointer from two bytes

void main() {
    puta(4, 0x00);
    puta(5, 0x18);
}

void puta(byte ph, byte pl) {
    byte* screen = (byte*) MAKEWORD( ph, pl );
    *screen = 'a';
}