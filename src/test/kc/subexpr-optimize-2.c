// Tests optimization of identical sub-expressions
void main() {
    byte* screen = (char*)0x400;
    for( byte i: 0..2) {
        *screen++ = (i+1)*2;
        *screen++ = (i+1)*2;
    }
}

