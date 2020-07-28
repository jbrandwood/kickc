// Tests the different ASM addressing modes
.cpu _65c02
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
    ora.z ($12)
    lda ($12,x)
    lda ($12),y
    lda $1234
    lda $1234,x
    lda $1234,y
    beq lbl1
    bbr0 $12,lbl2
  lbl1:
    jmp ($1234)
  lbl2:
    jmp ($1234,x)
    // }
}
