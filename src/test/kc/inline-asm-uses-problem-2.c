// Demonstrates problem with inline ASM usages - and early-detect constants
// zp2 should be forced to live at address $fc - but is identified to be constant by Pass1EarlyConstantIdentification

void main() {
    __address(0xfc) char * zp2 = 0x0400;
    zp2[1] = '*';
    asm {
        lda #$28
        sta zp2
    }
    zp2[2] = '*';
}