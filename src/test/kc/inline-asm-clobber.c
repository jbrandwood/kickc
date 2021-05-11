// Tests that inline ASM clobbering is taken into account when assigning registers
byte* SCREEN = (byte*)$400;
void main() {
    // First loop with no clobber
    for(byte i : 0..100) {
        for(byte j: 0..100) {
            SCREEN[i] = j;
        }
    }
    // Then loop with clobbering A&X
    for(byte k : 0..100) {
        for(byte l: 0..100) {
            asm {
                // Clobber all registers
                eor #$55
                tax
            }
            SCREEN[k] = l;
        }
    }
}
