.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
    ldx #$64
  b1:
    dex
    cpx #0
    bne b2
    sty SCREEN
    rts
  b2:
    cpx #$32+1
    bcs b4
    dey
    jmp b1
  b4:
    iny
    jmp b1
}
