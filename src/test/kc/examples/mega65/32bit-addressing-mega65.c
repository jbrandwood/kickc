// 32-bit addressing using the new addressing mode
#pragma target(mega65)

// Absolute 32-bit address to use for storing/loading data
volatile __zp unsigned long ADDR32; 

// The address of the coloir RAM in MEGA65 main memory
const unsigned long MEGA65_MEM_COLOR_RAM = 0xff80000;

void main() {
    // Modify Color Ram using 32-bit addressing
    ADDR32 = MEGA65_MEM_COLOR_RAM;
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