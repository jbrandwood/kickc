// Tests the different ASM addressing modes
.cpu _45gs02
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // asm
    inx
    lda #$12
    phw #$1234
    lda.z $12
    lda.z $12,x
    ldx.z $12,y
    lda ($12,x)
    lda ($12),y
    ora.z ($12),z
    lda.z ($12,sp),y
    lda $1234
    lda $1234,x
    lda $1234,y
    beq lbl1
    lbeq far
    bbr0 $12,lbl2
  lbl1:
    jmp ($1234)
  lbl2:
    jmp ($1234,x)
  lbl3:
    lda.z (($12)),z
    ldq.z (($12))
    // }
    rts
}
.pc = $2000 "far"
  far: .byte $60
