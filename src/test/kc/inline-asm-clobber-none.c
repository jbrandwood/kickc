// Tests that inline ASM JSR clobbers all registers
byte* SCREEN = (byte*)$400;
void main() {
    for( byte i:0..10) {
        for( byte j:0..10) {
            for( byte k:0..10) {
                asm(clobbers "") {
                    pha
                    txa
                    pha
                    tya
                    pha
                    jsr $e544
                    pla
                    tay
                    pla
                    tax
                    pla
                }
            }
        }
    }
}
