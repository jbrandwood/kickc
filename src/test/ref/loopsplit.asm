.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
    ldx #$64
  __b1:
    dex
    cpx #0
    bne __b2
    sty SCREEN
    rts
  __b2:
    cpx #$32+1
    bcs __b4
    dey
    jmp __b1
  __b4:
    iny
    jmp __b1
}
