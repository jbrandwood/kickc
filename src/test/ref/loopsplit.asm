.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldy #0
    ldx #$64
  b1:
    dex
    cpx #0
    bne b2
    rts
  b2:
    cpx #$32+1
    bcs b3
    dey
    jmp b1
  b3:
    iny
    jmp b1
}
