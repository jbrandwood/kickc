// Tests optimization of identical sub-expressions
void main() {
    byte* screen = 0x400;
    for( byte i: 0..2) {
        *screen++ = (i&1)?i+3:i*4;
        *screen++ = (i&1)?i+3:i*4;
    }
}

