// 32-bit addressing using the new addressing mode
#pragma target(mega65)

// Absolute 32-bit address to use for storing/loading data
volatile __zp unsigned long ADDR32; 

void main() {
    // Modify Color Ram using 32-bit addressing
    ADDR32 = 0xff80000;
    asm {
        ldz #0
    !:
        tza
        sta ((ADDR32)),z
        inz
        cpz #80
        bne !-
    }

    // Modify Screen using 32-bit addressing
    ADDR32 = 0x00000800;
    asm {
        lda #'*'
        ldz #79
    !:
        sta ((ADDR32)),z
        dez
        bpl !-
    }

}