// Tests casting pointer types to other pointer types does not produce any ASM code

void main() {
    byte* bscreen = (char*)0x0400;
    for(byte i: 0..2) {
        word* wscreen = (word*)bscreen;
        wscreen[i] = (word)i;
    }
}