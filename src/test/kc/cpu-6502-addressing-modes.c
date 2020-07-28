// Tests the different ASM addressing modes

#pragma cpu(mos6502)

void main() {

    asm {
        // 6502:impl
        inx
        // 6502:im
        lda #$12
        // 6502:zp
        lda $12
        // 6502:zp,x
        lda $12,x
        // 6502:zp,y
        ldx $12,y
        // 6502:(zp,x)
        lda ($12,x)
        // 6502:(zp),y
        lda ($12),y
        // 6502:absolute
        lda $1234
        // 6502:abs,x
        lda $1234,x
        // 6502:abs,y
        lda $1234,y
        // 6502:relative
        beq !+
        // 6502:(abs))
        jmp ($1234)
        !:
    }

}