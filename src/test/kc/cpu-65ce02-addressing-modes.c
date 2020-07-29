// Tests the different ASM addressing modes

#pragma cpu(csg65ce02)

void main() {

    asm {
        // 6502:impl
        inx
        // 6502:imm
        lda #$12
        // 65CE02:immword
        phw #$1234
        // 6502:zp
        lda $12
        // 6502:zp,x
        lda $12,x
        // 6502:zp,y
        ldx $12,y
        // 65C02: (zp)
        //ora ($12)
        // 6502:(zp,x)
        lda ($12,x)
        // 6502:(zp),y
        lda ($12),y
        // 65CE02: (zp),z
        ora ($12),z
        // 65CE02: Stack Pointer Indirect Indexed
        lda ($12,sp),y
        // 6502:absolute
        lda $1234
        // 6502:abs,x
        lda $1234,x
        // 6502:abs,y
        lda $1234,y
        // 6502:relative
        beq lbl1
        // 65CE02:word relative
        lbeq far
        // 65C02: $12, rel
        bbr0 $12,lbl2
        lbl1:
        // 6502:(abs)
        jmp ($1234)
        lbl2:
        // 65C02: ($1234,X)
        jmp ($1234,x)

        // TODO Indirect Long,Z
        //lda (($12)),z

        // TODO Indirect Long
        //lda (($12))

    }



}

__address(0x2000) char far[] = { 0x60 };