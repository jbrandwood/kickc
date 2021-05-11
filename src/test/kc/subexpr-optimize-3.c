// Tests optimization of identical sub-expressions
void main() {
    byte* screen = (char*)0x400;
    for( byte i: 0..2) {
        *screen++ = i*2+i+3;
        *screen++ = i*2+i+3;
    }
}

