// Tests the different ASM addressing modes
.cpu _6502NoIllegals
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // asm
    inx
    lda #$12
    lda.z $12
    lda.z $12,x
    ldx.z $12,y
    lda ($12,x)
    lda ($12),y
    lda $1234
    lda $1234,x
    lda $1234,y
    beq !+
    jmp ($1234)
  !:
    // }
    rts
}
