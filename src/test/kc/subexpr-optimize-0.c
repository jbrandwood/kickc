// Tests optimization of identical sub-expressions
// The two examples of i*2 is detected as identical leading to optimized ASM where *2 is only calculated once
void main() {
    byte* screen = 0x400;
    for( byte i: 0..2) {
        *screen++ = i*2;
        *screen++ = i*2;
    }
}

