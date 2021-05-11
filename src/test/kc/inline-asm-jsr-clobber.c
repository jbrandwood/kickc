// Tests that inline ASM JSR clobbers all registers
byte* SCREEN = (byte*)$400;
void main() {
    for( byte i:0..10) {
        asm {
            jsr $e544
        }
    }
}
